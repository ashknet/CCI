using HospitalService.Core.DTOs;
using MedTravel.Shared.Models;

namespace HospitalService.Core.Interfaces;

public interface IHospitalService
{
    Task<HospitalProfileDto?> GetHospitalProfileAsync(Guid hospitalId);
    Task<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>> GetHospitalDoctorsAsync(
        Guid hospitalId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>> GetHospitalsByCityAsync(
        Guid cityId, string? specialty = null, int page = 1, int pageSize = 20);
    Task<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>> GetHospitalsBySpecialtyAsync(
        string specialty, string? city = null, int page = 1, int pageSize = 20);
    Task<MedTravel.Shared.Models.PagedResult<ReviewDto>> GetHospitalReviewsAsync(
        Guid hospitalId, int page = 1, int pageSize = 20);
}
