using HospitalService.Core.DTOs;

namespace HospitalService.Core.Interfaces;

public interface IDoctorService
{
    Task<DoctorProfileDto?> GetDoctorProfileAsync(Guid doctorId);
    Task<DoctorSummaryDto?> GetDoctorByIdAsync(Guid doctorId);
    Task<PagedResult<DoctorSummaryDto>> GetDoctorsByHospitalAsync(
        Guid hospitalId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<PagedResult<DoctorSummaryDto>> GetDoctorsBySpecialtyAsync(
        string specialty, string? city = null, int page = 1, int pageSize = 20);
    Task<PagedResult<DoctorSummaryDto>> GetDoctorsByDiseaseAsync(
        Guid diseaseId, string? city = null, int page = 1, int pageSize = 20);
}
