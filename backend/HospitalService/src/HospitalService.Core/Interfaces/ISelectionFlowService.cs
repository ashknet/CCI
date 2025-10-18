using HospitalService.Core.DTOs;
using MedTravel.Shared.Models;

namespace HospitalService.Core.Interfaces;

public interface ISelectionFlowService
{
    // Doctor Selection Flow
    Task<DoctorSelectionDto?> GetDoctorSelectionAsync(Guid doctorId, DoctorSelectionRequest request);
    Task<AppointmentAvailabilityDto> GetDoctorAvailabilityAsync(Guid doctorId, DateTime? startDate, DateTime? endDate);
    
    // Hospital Selection Flow
    Task<HospitalSelectionDto?> GetHospitalSelectionAsync(Guid hospitalId, HospitalSelectionRequest request);
    Task<PagedResult<DoctorSummaryDto>> GetHospitalDoctorsAsync(Guid hospitalId, HospitalSelectionRequest request);
    
    // City Selection Flow
    Task<CitySelectionDto?> GetCitySelectionAsync(Guid cityId, CitySelectionRequest request);
    Task<PagedResult<HospitalSummaryDto>> GetCityHospitalsAsync(Guid cityId, CitySelectionRequest request);
    
    // Disease Selection Flow
    Task<DiseaseSelectionDto?> GetDiseaseSelectionAsync(Guid diseaseId, DiseaseSelectionRequest request);
    Task<PagedResult<DoctorSelectionSummaryDto>> GetDiseaseDoctorsAsync(Guid diseaseId, DiseaseSelectionRequest request);
    
    // Common helper methods
    Task<List<SpecialtyDto>> GetAvailableSpecialtiesAsync(Guid? cityId = null, Guid? hospitalId = null);
    Task<bool> CheckDoctorAvailabilityAsync(Guid doctorId, DateTime date, TimeSpan time);
    Task<DateTime?> GetNextAvailableSlotAsync(Guid doctorId);
}
