using Microsoft.EntityFrameworkCore;
using HospitalService.Core.Entities;
using HospitalService.Core.Interfaces;
using HospitalService.Core.DTOs;
using HospitalService.Infrastructure.Data;
using MedTravel.Shared.Models;

namespace HospitalService.Infrastructure.Repositories;

public class SelectionFlowRepository : ISelectionFlowRepository
{
    private readonly HospitalDbContext _context;

    public SelectionFlowRepository(HospitalDbContext context)
    {
        _context = context;
    }

    // Doctor Selection Queries
    public async Task<Doctor?> GetDoctorWithDetailsAsync(Guid doctorId)
    {
        return await _context.Doctors
            .Include(d => d.Hospital)
            .ThenInclude(h => h.City)
            .ThenInclude(c => c.Country)
            .Include(d => d.DoctorSpecialties)
            .ThenInclude(ds => ds.Specialty)
            .Include(d => d.DoctorLanguages)
            .ThenInclude(dl => dl.Language)
            .Include(d => d.Credentials)
            .FirstOrDefaultAsync(d => d.Id == doctorId && d.IsActive == true);
    }

    public async Task<List<Appointment>> GetDoctorAppointmentsAsync(Guid doctorId, DateTime startDate, DateTime endDate)
    {
        return await _context.Appointments
            .Where(a => a.DoctorId == doctorId && 
                       a.ScheduledDate >= startDate && 
                       a.ScheduledDate <= endDate &&
                       a.Status != "cancelled")
            .ToListAsync();
    }

    public async Task<List<DoctorAvailability>> GetDoctorAvailabilityAsync(Guid doctorId)
    {
        return await _context.DoctorAvailabilities
            .Where(da => da.DoctorId == doctorId && da.IsActive == true)
            .ToListAsync();
    }

    public async Task<List<Review>> GetDoctorReviewsAsync(Guid doctorId, int limit = 5)
    {
        return await _context.Reviews
            .Where(r => r.DoctorId == doctorId)
            .OrderByDescending(r => r.CreatedAt)
            .Take(limit)
            .ToListAsync();
    }

    // Hospital Selection Queries
    public async Task<Hospital?> GetHospitalWithDetailsAsync(Guid hospitalId)
    {
        return await _context.Hospitals
            .Include(h => h.City)
            .ThenInclude(c => c.Country)
            .Include(h => h.Departments)
            .ThenInclude(d => d.Specialty)
            .Include(h => h.HospitalAccreditations)
            .FirstOrDefaultAsync(h => h.Id == hospitalId && h.IsActive == true);
    }

    public async Task<PagedResult<Doctor>> GetHospitalDoctorsAsync(Guid hospitalId, int page, int pageSize, string? specialty = null, string? sortBy = "rating")
    {
        var query = _context.Doctors
            .Include(d => d.Hospital)
            .Include(d => d.DoctorSpecialties)
            .ThenInclude(ds => ds.Specialty)
            .Where(d => d.HospitalId == hospitalId && d.IsActive == true);

        if (!string.IsNullOrEmpty(specialty))
        {
            query = query.Where(d => d.DoctorSpecialties.Any(ds => ds.Specialty.Name.Contains(specialty)));
        }

        query = sortBy.ToLower() switch
        {
            "experience" => query.OrderByDescending(d => d.YearsOfExperience),
            "fee" => query.OrderBy(d => d.ConsultationFee),
            _ => query.OrderByDescending(d => d.AverageRating)
        };

        var totalCount = await query.CountAsync();
        var items = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return new PagedResult<Doctor>
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize,
        };
    }

    public async Task<List<Specialty>> GetHospitalSpecialtiesAsync(Guid hospitalId)
    {
        return await _context.Departments
            .Where(d => d.HospitalId == hospitalId)
            .Select(d => d.Specialty)
            .Distinct()
            .ToListAsync();
    }

    // City Selection Queries
    public async Task<City?> GetCityWithDetailsAsync(Guid cityId)
    {
        return await _context.Cities
            .Include(c => c.Country)
            .FirstOrDefaultAsync(c => c.Id == cityId && c.IsActive == true);
    }

    public async Task<PagedResult<Hospital>> GetCityHospitalsAsync(Guid cityId, int page, int pageSize, string? specialty = null, string? sortBy = "rating", decimal? maxDistance = null)
    {
        var query = _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Departments)
            .ThenInclude(d => d.Specialty)
            .Where(h => h.CityId == cityId && h.IsActive == true);

        if (!string.IsNullOrEmpty(specialty))
        {
            query = query.Where(h => h.Departments.Any(d => d.Specialty.Name.Contains(specialty)));
        }

        query = sortBy.ToLower() switch
        {
            "capacity" => query.OrderByDescending(h => h.BedCapacity),
            "distance" => query.OrderBy(h => h.Latitude), // Simplified distance calculation
            _ => query.OrderByDescending(h => h.AverageRating)
        };

        var totalCount = await query.CountAsync();
        var items = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return new PagedResult<Hospital>
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize,
        };
    }

    public async Task<List<Specialty>> GetCitySpecialtiesAsync(Guid cityId)
    {
        return await _context.Departments
            .Where(d => d.Hospital.CityId == cityId)
            .Select(d => d.Specialty)
            .Distinct()
            .ToListAsync();
    }

    public async Task<int> GetCityDoctorCountAsync(Guid cityId)
    {
        return await _context.Doctors
            .Where(d => d.Hospital.CityId == cityId && d.IsActive == true)
            .CountAsync();
    }

    // Disease Selection Queries
    public async Task<Disease?> GetDiseaseWithDetailsAsync(Guid diseaseId)
    {
        return await _context.Diseases
            .Include(d => d.DiseaseSpecialties)
            .ThenInclude(ds => ds.Specialty)
            .FirstOrDefaultAsync(d => d.Id == diseaseId);
    }

    public async Task<PagedResult<Doctor>> GetDiseaseDoctorsAsync(Guid diseaseId, Guid? cityId, int page, int pageSize, string? specialty = null, string? sortBy = "experience")
    {
        var query = _context.Doctors
            .Include(d => d.Hospital)
            .ThenInclude(h => h.City)
            .Include(d => d.DoctorSpecialties)
            .ThenInclude(ds => ds.Specialty)
            .Include(d => d.DoctorDiseases)
            .Where(d => d.DoctorDiseases.Any(dd => dd.DiseaseId == diseaseId) && d.IsActive == true);

        if (cityId.HasValue)
        {
            query = query.Where(d => d.Hospital.CityId == cityId.Value);
        }

        if (!string.IsNullOrEmpty(specialty))
        {
            query = query.Where(d => d.DoctorSpecialties.Any(ds => ds.Specialty.Name.Contains(specialty)));
        }

        query = sortBy.ToLower() switch
        {
            "rating" => query.OrderByDescending(d => d.AverageRating),
            "fee" => query.OrderBy(d => d.ConsultationFee),
            _ => query.OrderByDescending(d => d.DoctorDiseases.First(dd => dd.DiseaseId == diseaseId).YearsOfExperience)
        };

        var totalCount = await query.CountAsync();
        var items = await query
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return new PagedResult<Doctor>
        {
            Items = items,
            TotalCount = totalCount,
            PageNumber = page,
            PageSize = pageSize,
        };
    }

    public async Task<List<Specialty>> GetDiseaseSpecialtiesAsync(Guid diseaseId)
    {
        return await _context.DiseaseSpecialties
            .Where(ds => ds.DiseaseId == diseaseId)
            .Select(ds => ds.Specialty)
            .ToListAsync();
    }

    public async Task<List<Hospital>> GetDiseaseTopHospitalsAsync(Guid diseaseId, int limit = 5)
    {
        return await _context.Hospitals
            .Include(h => h.City)
            .Where(h => h.Doctors.Any(d => d.DoctorDiseases.Any(dd => dd.DiseaseId == diseaseId)))
            .OrderByDescending(h => h.AverageRating)
            .Take(limit)
            .ToListAsync();
    }

    // Common Queries
    public async Task<List<Specialty>> GetAvailableSpecialtiesAsync(Guid? cityId = null, Guid? hospitalId = null)
    {
        var query = _context.Specialties.AsQueryable();

        if (cityId.HasValue)
        {
            query = query.Where(s => s.Departments.Any(d => d.Hospital.CityId == cityId.Value));
        }
        else if (hospitalId.HasValue)
        {
            query = query.Where(s => s.Departments.Any(d => d.HospitalId == hospitalId.Value));
        }

        return await query.ToListAsync();
    }

    public async Task<bool> CheckDoctorAvailabilityAsync(Guid doctorId, DateTime date, TimeSpan time)
    {
        var dayOfWeek = (int)date.DayOfWeek;
        var hasAvailability = await _context.DoctorAvailabilities
            .AnyAsync(da => da.DoctorId == doctorId && 
                           da.DayOfWeek == dayOfWeek && 
                           da.StartTime <= time && 
                           da.EndTime >= time && 
                           da.IsActive == true);

        if (!hasAvailability) return false;

        var hasAppointment = await _context.Appointments
            .AnyAsync(a => a.DoctorId == doctorId && 
                          a.ScheduledDate.Date == date.Date && 
                          a.ScheduledTime == time && 
                          a.Status != "cancelled");

        return !hasAppointment;
    }

    public async Task<DateTime?> GetNextAvailableSlotAsync(Guid doctorId)
    {
        var availability = await _context.DoctorAvailabilities
            .Where(da => da.DoctorId == doctorId && da.IsActive == true)
            .OrderBy(da => da.DayOfWeek)
            .ThenBy(da => da.StartTime)
            .FirstOrDefaultAsync();

        if (availability == null) return null;

        var today = DateTime.Today;
        var daysUntilNext = ((int)availability.DayOfWeek - (int)today.DayOfWeek + 7) % 7;
        if (daysUntilNext == 0 && DateTime.Now.TimeOfDay >= availability.StartTime)
        {
            daysUntilNext = 7;
        }

        return today.AddDays(daysUntilNext).Date.Add(availability.StartTime);
    }

    public async Task<List<DoctorDisease>> GetDoctorDiseasesAsync(Guid doctorId)
    {
        return await _context.DoctorDiseases
            .Include(dd => dd.Disease)
            .Where(dd => dd.DoctorId == doctorId)
            .ToListAsync();
    }

    public async Task<List<DoctorDisease>> GetDiseaseDoctorsAsync(Guid diseaseId)
    {
        return await _context.DoctorDiseases
            .Include(dd => dd.Doctor)
            .Where(dd => dd.DiseaseId == diseaseId)
            .ToListAsync();
    }
}
