using HospitalService.Core.DTOs;
using HospitalService.Core.Entities;
using MedTravel.Shared.Models;

namespace HospitalService.Core.Interfaces;

public interface ISelectionFlowRepository
{
    // Doctor Selection Queries
    Task<Doctor?> GetDoctorWithDetailsAsync(Guid doctorId);
    Task<List<Appointment>> GetDoctorAppointmentsAsync(Guid doctorId, DateTime startDate, DateTime endDate);
    Task<List<DoctorAvailability>> GetDoctorAvailabilityAsync(Guid doctorId);
    Task<List<Review>> GetDoctorReviewsAsync(Guid doctorId, int limit = 5);
    
    // Hospital Selection Queries
    Task<Hospital?> GetHospitalWithDetailsAsync(Guid hospitalId);
    Task<PagedResult<Doctor>> GetHospitalDoctorsAsync(Guid hospitalId, int page, int pageSize, string? specialty = null, string? sortBy = "rating");
    Task<List<Specialty>> GetHospitalSpecialtiesAsync(Guid hospitalId);
    
    // City Selection Queries
    Task<City?> GetCityWithDetailsAsync(Guid cityId);
    Task<PagedResult<Hospital>> GetCityHospitalsAsync(Guid cityId, int page, int pageSize, string? specialty = null, string? sortBy = "rating", decimal? maxDistance = null);
    Task<List<Specialty>> GetCitySpecialtiesAsync(Guid cityId);
    Task<int> GetCityDoctorCountAsync(Guid cityId);
    
    // Disease Selection Queries
    Task<Disease?> GetDiseaseWithDetailsAsync(Guid diseaseId);
    Task<PagedResult<Doctor>> GetDiseaseDoctorsAsync(Guid diseaseId, Guid? cityId, int page, int pageSize, string? specialty = null, string? sortBy = "experience");
    Task<List<Specialty>> GetDiseaseSpecialtiesAsync(Guid diseaseId);
    Task<List<Hospital>> GetDiseaseTopHospitalsAsync(Guid diseaseId, int limit = 5);
    
    // Common Queries
    Task<List<Specialty>> GetAvailableSpecialtiesAsync(Guid? cityId = null, Guid? hospitalId = null);
    Task<bool> CheckDoctorAvailabilityAsync(Guid doctorId, DateTime date, TimeSpan time);
    Task<DateTime?> GetNextAvailableSlotAsync(Guid doctorId);
    Task<List<DoctorDisease>> GetDoctorDiseasesAsync(Guid doctorId);
    Task<List<DoctorDisease>> GetDiseaseDoctorsAsync(Guid diseaseId);
}
