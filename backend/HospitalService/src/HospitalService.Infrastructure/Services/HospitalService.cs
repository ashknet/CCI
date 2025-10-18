using Microsoft.EntityFrameworkCore;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Data;
using MedTravel.Shared.Models;

namespace HospitalService.Infrastructure.Services;

public class HospitalService : IHospitalService
{
    private readonly HospitalDbContext _context;

    public HospitalService(HospitalDbContext context)
    {
        _context = context;
    }

    public async Task<HospitalProfileDto?> GetHospitalProfileAsync(Guid hospitalId)
    {
        var hospital = await _context.Hospitals
            .Include(h => h.City)
                .ThenInclude(c => c.Country)
            .Include(h => h.Country)
            .Include(h => h.Departments)
                .ThenInclude(d => d.Specialty)
            .Include(h => h.Accreditations)
                .ThenInclude(a => a.AccreditationBody)
            .Include(h => h.Reviews.Take(5))
            .FirstOrDefaultAsync(h => h.Id == hospitalId && h.IsActive == true);

        if (hospital == null) return null;

        return new HospitalProfileDto
        {
            Id = hospital.Id,
            Name = hospital.Name,
            Description = hospital.Description ?? string.Empty,
            Address = hospital.Address,
            City = hospital.City?.Name ?? string.Empty,
            State = hospital.City?.State ?? string.Empty,
            Country = hospital.Country?.Name ?? string.Empty,
            PostalCode = hospital.PostalCode ?? string.Empty,
            Latitude = hospital.Latitude ?? 0,
            Longitude = hospital.Longitude ?? 0,
            Phone = hospital.Phone ?? string.Empty,
            Email = hospital.Email ?? string.Empty,
            Website = hospital.Website ?? string.Empty,
            BedCapacity = hospital.BedCapacity ?? 0,
            YearEstablished = hospital.YearEstablished ?? 0,
            AverageRating = hospital.AverageRating,
            TotalReviews = hospital.TotalReviews,
            IsActive = hospital.IsActive ?? true,
            Specialties = hospital.Departments
                .Select(d => new SpecialtyDto
                {
                    Id = d.Specialty.Id,
                    Name = d.Specialty.Name,
                    Description = d.Specialty.Description ?? string.Empty,
                    Category = d.Specialty.Category ?? string.Empty
                }).ToList(),
            Amenities = new List<string>(),
            Reviews = hospital.Reviews.Select(r => new ReviewDto(
                r.Id, r.HospitalId, r.DoctorId, r.PatientId, r.Rating, 
                r.Title, r.Comment, r.TreatmentDate, r.IsVerified, r.IsApproved, r.CreatedAt
            )).ToList()
        };
    }

    public async Task<PagedResult<DoctorSummaryDto>> GetHospitalDoctorsAsync(
        Guid hospitalId, string? specialty = null, int page = 1, int pageSize = 20)
    {
        var query = _context.Doctors
            .Include(d => d.DoctorSpecialties)
                .ThenInclude(ds => ds.Specialty)
            .Where(d => d.HospitalId == hospitalId && d.IsActive == true);

        if (!string.IsNullOrEmpty(specialty))
        {
            query = query.Where(d => d.DoctorSpecialties.Any(ds => 
                ds.Specialty.Name.Contains(specialty)));
        }

        var totalCount = await query.CountAsync();
        var doctors = await query
            .OrderByDescending(d => d.AverageRating)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var doctorDtos = doctors.Select(d => new DoctorSummaryDto
        {
            Id = d.Id,
            FirstName = d.FirstName,
            LastName = d.LastName,
            Qualification = d.Qualification ?? string.Empty,
            YearsOfExperience = d.YearsOfExperience ?? 0,
            ConsultationFee = d.ConsultationFee ?? 0,
            AverageRating = d.AverageRating,
            TotalReviews = d.TotalReviews,
            IsAcceptingPatients = d.IsAcceptingPatients ?? true,
            ProfileImageUrl = d.ProfileImageUrl,
            Specialties = d.DoctorSpecialties.Select(ds => new SpecialtyDto
            {
                Id = ds.Specialty.Id,
                Name = ds.Specialty.Name,
                Description = ds.Specialty.Description ?? string.Empty,
                Category = ds.Specialty.Category ?? string.Empty
            }).ToList()
        }).ToList();

        return new PagedResult<DoctorSummaryDto>
        {
            Items = doctorDtos,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize
        };
    }

    public async Task<PagedResult<HospitalSummaryDto>> GetHospitalsByCityAsync(
        Guid cityId, string? specialty = null, int page = 1, int pageSize = 20)
    {
        var query = _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Departments)
                .ThenInclude(d => d.Specialty)
            .Where(h => h.CityId == cityId && h.IsActive == true);

        if (!string.IsNullOrEmpty(specialty))
        {
            query = query.Where(h => h.Departments.Any(d => 
                d.Specialty.Name.Contains(specialty)));
        }

        var totalCount = await query.CountAsync();
        var hospitals = await query
            .OrderByDescending(h => h.AverageRating)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var hospitalDtos = hospitals.Select(h => new HospitalSummaryDto
        {
            Id = h.Id,
            Name = h.Name,
            Address = h.Address,
            City = h.City?.Name ?? string.Empty,
            Phone = h.Phone ?? string.Empty,
            AverageRating = h.AverageRating,
            TotalReviews = h.TotalReviews,
            BedCapacity = h.BedCapacity ?? 0,
            Specialties = h.Departments.Select(d => new SpecialtyDto
            {
                Id = d.Specialty.Id,
                Name = d.Specialty.Name,
                Description = d.Specialty.Description ?? string.Empty,
                Category = d.Specialty.Category ?? string.Empty
            }).ToList()
        }).ToList();

        return new PagedResult<HospitalSummaryDto>
        {
            Items = hospitalDtos,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize
        };
    }

    public async Task<PagedResult<HospitalSummaryDto>> GetHospitalsBySpecialtyAsync(
        string specialty, string? city = null, int page = 1, int pageSize = 20)
    {
        var query = _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Departments)
                .ThenInclude(d => d.Specialty)
            .Where(h => h.IsActive == true && 
                   h.Departments.Any(d => d.Specialty.Name.Contains(specialty)));

        if (!string.IsNullOrEmpty(city))
        {
            query = query.Where(h => h.City.Name.Contains(city));
        }

        var totalCount = await query.CountAsync();
        var hospitals = await query
            .OrderByDescending(h => h.AverageRating)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var hospitalDtos = hospitals.Select(h => new HospitalSummaryDto
        {
            Id = h.Id,
            Name = h.Name,
            Address = h.Address,
            City = h.City?.Name ?? string.Empty,
            Phone = h.Phone ?? string.Empty,
            AverageRating = h.AverageRating,
            TotalReviews = h.TotalReviews,
            BedCapacity = h.BedCapacity ?? 0,
            Specialties = h.Departments.Select(d => new SpecialtyDto
            {
                Id = d.Specialty.Id,
                Name = d.Specialty.Name,
                Description = d.Specialty.Description ?? string.Empty,
                Category = d.Specialty.Category ?? string.Empty
            }).ToList()
        }).ToList();

        return new PagedResult<HospitalSummaryDto>
        {
            Items = hospitalDtos,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize
        };
    }

    public async Task<PagedResult<ReviewDto>> GetHospitalReviewsAsync(
        Guid hospitalId, int page = 1, int pageSize = 20)
    {
        var query = _context.Reviews
            .Where(r => r.HospitalId == hospitalId);

        var totalCount = await query.CountAsync();
        var reviews = await query
            .OrderByDescending(r => r.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var reviewDtos = reviews.Select(r => new ReviewDto(
            r.Id, r.HospitalId, r.DoctorId, r.PatientId, r.Rating,
            r.Title, r.Comment, r.TreatmentDate, r.IsVerified, r.IsApproved, r.CreatedAt
        )).ToList();

        return new PagedResult<ReviewDto>
        {
            Items = reviewDtos,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize
        };
    }
}

