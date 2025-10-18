using HospitalService.Core.DTOs;
using MedTravel.Shared.Models;

namespace HospitalService.Core.Interfaces;

public interface ICityService
{
    Task<CityDto?> GetCityByIdAsync(Guid cityId);
    Task<MedTravel.Shared.Models.PagedResult<CityDto>> GetCitiesAsync(string? country = null, int page = 1, int pageSize = 50);
    Task<CityHospitalsDto?> GetCityHospitalsAsync(
        Guid cityId, string? specialty = null, int page = 1, int pageSize = 20);
}
