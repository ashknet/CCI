using Microsoft.EntityFrameworkCore;
using HospitalService.Core.DTOs;
using HospitalService.Core.Entities;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Data;

namespace HospitalService.Infrastructure.Repositories;

public class HospitalRepository : IHospitalRepository
{
    private readonly HospitalDbContext _context;

    public HospitalRepository(HospitalDbContext context) => _context = context;

    public async Task<Hospital?> GetByIdAsync(Guid id) =>
        await _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Country)
            .Include(h => h.Departments)
                .ThenInclude(d => d.Specialty)
            .Include(h => h.Accreditations)
                .ThenInclude(a => a.AccreditationBody)
            .Include(h => h.Reviews)
            .FirstOrDefaultAsync(h => h.Id == id);

    public async Task<IEnumerable<Hospital>> SearchAsync(SearchRequest request)
    {
        var query = _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Country)
            .AsQueryable();

        if (!string.IsNullOrEmpty(request.Query))
        {
            query = query.Where(h => EF.Functions.Like(h.Name, $"%{request.Query}%") ||
                                    EF.Functions.Like(h.City.Name, $"%{request.Query}%") ||
                                    EF.Functions.Like(h.Country.Name, $"%{request.Query}%"));
        }

        if (!string.IsNullOrEmpty(request.City))
            query = query.Where(h => h.City.Name == request.City);

        return await query
            .OrderByDescending(h => h.AverageRating)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .ToListAsync();
    }

    public async Task<int> GetSearchCountAsync(SearchRequest request)
    {
        var query = _context.Hospitals
            .Include(h => h.City)
            .Include(h => h.Country)
            .AsQueryable();
        if (!string.IsNullOrEmpty(request.Query))
        {
            query = query.Where(h => EF.Functions.Like(h.Name, $"%{request.Query}%") ||
                                    EF.Functions.Like(h.City.Name, $"%{request.Query}%") ||
                                    EF.Functions.Like(h.Country.Name, $"%{request.Query}%"));
        }
        return await query.CountAsync();
    }

    public async Task<IEnumerable<SearchSuggestion>> GetSuggestionsAsync(string query, int limit = 10)
    {
        if (query.Length < 3) return Enumerable.Empty<SearchSuggestion>();

        var hospitals = await _context.Hospitals
            .Where(h => EF.Functions.Like(h.Name, $"%{query}%"))
            .Take(limit / 2)
            .Select(h => new SearchSuggestion(h.Name, "hospital", h.Id))
            .ToListAsync();

        var cities = await _context.Hospitals
            .Include(h => h.City)
            .Where(h => EF.Functions.Like(h.City.Name, $"{query}%"))
            .Select(h => h.City.Name)
            .Distinct()
            .Take(limit / 2)
            .Select(c => new SearchSuggestion(c, "location", null))
            .ToListAsync();

        return hospitals.Concat(cities);
    }
}

public class DoctorRepository : IDoctorRepository
{
    private readonly HospitalDbContext _context;

    public DoctorRepository(HospitalDbContext context) => _context = context;

    public async Task<Doctor?> GetByIdAsync(Guid id) =>
        await _context.Doctors
            .Include(d => d.Hospital)
            .Include(d => d.DoctorSpecialties).ThenInclude(ds => ds.Specialty)
            .Include(d => d.DoctorLanguages).ThenInclude(dl => dl.Language)
            .Include(d => d.Credentials)
            .Include(d => d.Availability)
            .FirstOrDefaultAsync(d => d.Id == id);

    public async Task<IEnumerable<Doctor>> SearchAsync(SearchRequest request)
    {
        var query = _context.Doctors.Include(d => d.Hospital).AsQueryable();

        if (!string.IsNullOrEmpty(request.Query))
        {
            query = query.Where(d => EF.Functions.Like(d.FirstName + " " + d.LastName, $"%{request.Query}%"));
        }

        return await query
            .OrderByDescending(d => d.AverageRating)
            .Skip((request.PageNumber - 1) * request.PageSize)
            .Take(request.PageSize)
            .ToListAsync();
    }

    public async Task<int> GetSearchCountAsync(SearchRequest request)
    {
        var query = _context.Doctors.AsQueryable();
        if (!string.IsNullOrEmpty(request.Query))
        {
            query = query.Where(d => EF.Functions.Like(d.FirstName + " " + d.LastName, $"%{request.Query}%"));
        }
        return await query.CountAsync();
    }

    public async Task<IEnumerable<Doctor>> GetByHospitalIdAsync(Guid hospitalId) =>
        await _context.Doctors.Where(d => d.HospitalId == hospitalId).ToListAsync();

    public async Task<IEnumerable<Doctor>> GetBySpecialtyAsync(string specialty) =>
        await _context.Doctors
            .Include(d => d.DoctorSpecialties).ThenInclude(ds => ds.Specialty)
            .Where(d => d.DoctorSpecialties.Any(s => s.Specialty.Name == specialty))
            .ToListAsync();
}

public class AppointmentRepository : IAppointmentRepository
{
    private readonly HospitalDbContext _context;

    public AppointmentRepository(HospitalDbContext context) => _context = context;

    public async Task<Appointment?> GetByIdAsync(Guid id) =>
        await _context.Appointments.Include(a => a.Doctor).FirstOrDefaultAsync(a => a.Id == id);

    public async Task<IEnumerable<Appointment>> GetByPatientIdAsync(Guid patientId, int pageNumber, int pageSize) =>
        await _context.Appointments
            .Include(a => a.Doctor)
            .Where(a => a.PatientId == patientId)
            .OrderByDescending(a => a.ScheduledDate)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

    public async Task<IEnumerable<Appointment>> GetByDoctorIdAsync(Guid doctorId, DateTime startDate, DateTime endDate) =>
        await _context.Appointments
            .Where(a => a.DoctorId == doctorId && a.ScheduledDate >= startDate && a.ScheduledDate <= endDate)
            .ToListAsync();

    public async Task<Appointment> CreateAsync(Appointment appointment)
    {
        _context.Appointments.Add(appointment);
        await _context.SaveChangesAsync();
        return appointment;
    }

    public async Task<Appointment> UpdateAsync(Appointment appointment)
    {
        _context.Appointments.Update(appointment);
        await _context.SaveChangesAsync();
        return appointment;
    }

    public async Task<bool> CancelAsync(Guid id, string reason)
    {
        var appointment = await _context.Appointments.FindAsync(id);
        if (appointment == null) return false;

        appointment.Status = "cancelled";
        appointment.CancelledAt = DateTime.UtcNow;
        appointment.CancellationReason = reason;
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<IEnumerable<AvailableSlotDto>> GetAvailableSlotsAsync(Guid doctorId, DateTime startDate, DateTime endDate)
    {
        var availabilities = await _context.DoctorAvailabilities
            .Where(a => a.DoctorId == doctorId && a.IsAvailable)
            .ToListAsync();

        var bookedSlots = await _context.Appointments
            .Where(a => a.DoctorId == doctorId && a.ScheduledDate >= startDate && a.ScheduledDate <= endDate &&
                       (a.Status == "scheduled" || a.Status == "confirmed"))
            .Select(a => new { a.ScheduledDate, a.ScheduledTime })
            .ToListAsync();

        var slots = new List<AvailableSlotDto>();
        for (var date = startDate; date <= endDate; date = date.AddDays(1))
        {
            var dayAvailability = availabilities.FirstOrDefault(a => a.DayOfWeek == (int)date.DayOfWeek);
            if (dayAvailability != null)
            {
                var slotDuration = dayAvailability.SlotDurationMinutes ?? 30;
                var currentTime = dayAvailability.StartTime;
                while (currentTime < dayAvailability.EndTime)
                {
                    var isBooked = bookedSlots.Any(s => s.ScheduledDate.Date == date.Date && s.ScheduledTime == currentTime);
                    slots.Add(new AvailableSlotDto(date, currentTime, currentTime.Add(TimeSpan.FromMinutes(slotDuration)), !isBooked));
                    currentTime = currentTime.Add(TimeSpan.FromMinutes(slotDuration));
                }
            }
        }
        return slots;
    }

    public async Task<bool> IsSlotAvailableAsync(Guid doctorId, DateTime date, TimeSpan time)
    {
        return !await _context.Appointments.AnyAsync(a =>
            a.DoctorId == doctorId && a.ScheduledDate.Date == date.Date && a.ScheduledTime == time &&
            (a.Status == "scheduled" || a.Status == "confirmed"));
    }
}

public class ReviewRepository : IReviewRepository
{
    private readonly HospitalDbContext _context;

    public ReviewRepository(HospitalDbContext context) => _context = context;

    public async Task<Review?> GetByIdAsync(Guid id) => await _context.Reviews.FindAsync(id);

    public async Task<IEnumerable<Review>> GetByEntityAsync(string entityType, Guid entityId, int pageNumber, int pageSize)
    {
        var query = entityType.ToLower() == "hospital"
            ? _context.Reviews.Where(r => r.HospitalId == entityId)
            : _context.Reviews.Where(r => r.DoctorId == entityId);

        return await query
            .OrderByDescending(r => r.CreatedAt)
            .Skip((pageNumber - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<Review> CreateAsync(Review review)
    {
        _context.Reviews.Add(review);
        await _context.SaveChangesAsync();
        return review;
    }

    public async Task<(decimal AverageRating, int TotalReviews)> GetRatingStatsAsync(string entityType, Guid entityId)
    {
        var query = entityType.ToLower() == "hospital"
            ? _context.Reviews.Where(r => r.HospitalId == entityId)
            : _context.Reviews.Where(r => r.DoctorId == entityId);

        var reviews = await query.ToListAsync();
        return reviews.Any()
            ? ((decimal)reviews.Average(r => r.Rating), reviews.Count)
            : (0m, 0);
    }
}

public class SpecialtyRepository : ISpecialtyRepository
{
    private readonly HospitalDbContext _context;

    public SpecialtyRepository(HospitalDbContext context) => _context = context;

    public async Task<IEnumerable<Specialty>> GetAllAsync() => await _context.Specialties.ToListAsync();

    public async Task<Specialty?> GetByNameAsync(string name) =>
        await _context.Specialties.FirstOrDefaultAsync(s => s.Name == name);
}
