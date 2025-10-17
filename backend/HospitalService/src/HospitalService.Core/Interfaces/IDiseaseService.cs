using HospitalService.Core.DTOs;

namespace HospitalService.Core.Interfaces;

public interface IDiseaseService
{
    Task<DiseaseDto?> GetDiseaseByIdAsync(Guid diseaseId);
    Task<PagedResult<DiseaseDto>> GetDiseasesAsync(string? category = null, int page = 1, int pageSize = 50);
    Task<PagedResult<DiseaseDto>> GetDiseasesByCategoryAsync(string category, int page = 1, int pageSize = 50);
    Task<DiseaseDoctorsDto?> GetDiseaseDoctorsAsync(
        Guid diseaseId, string? city = null, int page = 1, int pageSize = 20);
}
