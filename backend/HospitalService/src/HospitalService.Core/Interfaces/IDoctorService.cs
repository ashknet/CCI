using HospitalService.Core.DTOs;
using MedTravel.Shared.Models;

namespace HospitalService.Core.Interfaces;

public interface IDoctorService
{
    Task<DoctorProfileDto?> GetDoctorProfileAsync(Guid doctorId);
    Task<DoctorSummaryDto?> GetDoctorByIdAsync(Guid doctorId);
    Task<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>> GetDoctorsByHospitalAsync(
        Guid hospitalId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>> GetDoctorsBySpecialtyAsync(
        string specialty, string? city = null, int page = 1, int pageSize = 20);
    Task<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>> GetDoctorsByDiseaseAsync(
        Guid diseaseId, string? city = null, int page = 1, int pageSize = 20);
}
