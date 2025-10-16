using HospitalService.Core.DTOs;
using HospitalService.Core.Entities;

namespace HospitalService.Core.Interfaces;

public interface IHospitalRepository
{
    Task<Hospital?> GetByIdAsync(Guid id);
    Task<IEnumerable<Hospital>> SearchAsync(SearchRequest request);
    Task<int> GetSearchCountAsync(SearchRequest request);
    Task<IEnumerable<SearchSuggestion>> GetSuggestionsAsync(string query, int limit = 10);
}

public interface IDoctorRepository
{
    Task<Doctor?> GetByIdAsync(Guid id);
    Task<IEnumerable<Doctor>> SearchAsync(SearchRequest request);
    Task<int> GetSearchCountAsync(SearchRequest request);
    Task<IEnumerable<Doctor>> GetByHospitalIdAsync(Guid hospitalId);
    Task<IEnumerable<Doctor>> GetBySpecialtyAsync(string specialty);
}

public interface IAppointmentRepository
{
    Task<Appointment?> GetByIdAsync(Guid id);
    Task<IEnumerable<Appointment>> GetByPatientIdAsync(Guid patientId, int pageNumber, int pageSize);
    Task<IEnumerable<Appointment>> GetByDoctorIdAsync(Guid doctorId, DateTime startDate, DateTime endDate);
    Task<Appointment> CreateAsync(Appointment appointment);
    Task<Appointment> UpdateAsync(Appointment appointment);
    Task<bool> CancelAsync(Guid id, string reason);
    Task<IEnumerable<AvailableSlotDto>> GetAvailableSlotsAsync(Guid doctorId, DateTime startDate, DateTime endDate);
    Task<bool> IsSlotAvailableAsync(Guid doctorId, DateTime date, TimeSpan time);
}

public interface IReviewRepository
{
    Task<Review?> GetByIdAsync(Guid id);
    Task<IEnumerable<Review>> GetByEntityAsync(string entityType, Guid entityId, int pageNumber, int pageSize);
    Task<Review> CreateAsync(Review review);
    Task<(decimal AverageRating, int TotalReviews)> GetRatingStatsAsync(string entityType, Guid entityId);
}

public interface ISpecialtyRepository
{
    Task<IEnumerable<Specialty>> GetAllAsync();
    Task<Specialty?> GetByNameAsync(string name);
}
