using HospitalService.Core.DTOs;

namespace HospitalService.Core.Interfaces;

public interface IHospitalService
{
    Task<HospitalProfileDto?> GetHospitalProfileAsync(Guid hospitalId);
    Task<PagedResult<DoctorSummaryDto>> GetHospitalDoctorsAsync(
        Guid hospitalId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<PagedResult<HospitalSummaryDto>> GetHospitalsByCityAsync(
        Guid cityId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<PagedResult<HospitalSummaryDto>> GetHospitalsBySpecialtyAsync(
        string specialty, string? city = null, int page = 1, int pageSize = 20);
    Task<PagedResult<ReviewDto>> GetHospitalReviewsAsync(
        Guid hospitalId, int page = 1, int pageSize = 20);
}
