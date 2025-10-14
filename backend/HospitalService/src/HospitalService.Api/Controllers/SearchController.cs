using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;

namespace HospitalService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SearchController : ControllerBase
{
    private readonly IHospitalRepository _hospitalRepository;
    private readonly IDoctorRepository _doctorRepository;

    public SearchController(IHospitalRepository hospitalRepository, IDoctorRepository doctorRepository)
    {
        _hospitalRepository = hospitalRepository;
        _doctorRepository = doctorRepository;
    }

    [HttpGet("suggestions")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<IEnumerable<SearchSuggestion>>>> GetSuggestions([FromQuery] string query)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var suggestions = await _hospitalRepository.GetSuggestionsAsync(query);
        return Ok(ApiResponse<IEnumerable<SearchSuggestion>>.SuccessResponse(suggestions, null, correlationId));
    }

    [HttpPost("hospitals")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<HospitalDto>>>> SearchHospitals([FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var hospitals = await _hospitalRepository.SearchAsync(request);
        var count = await _hospitalRepository.GetSearchCountAsync(request);

        var result = new PagedResult<HospitalDto>
        {
            Items = hospitals.Select(MapHospitalToDto).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };

        return Ok(ApiResponse<PagedResult<HospitalDto>>.SuccessResponse(result, null, correlationId));
    }

    [HttpPost("doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DoctorDto>>>> SearchDoctors([FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var doctors = await _doctorRepository.SearchAsync(request);
        var count = await _doctorRepository.GetSearchCountAsync(request);

        var result = new PagedResult<DoctorDto>
        {
            Items = doctors.Select(MapDoctorToDto).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };

        return Ok(ApiResponse<PagedResult<DoctorDto>>.SuccessResponse(result, null, correlationId));
    }

    private static HospitalDto MapHospitalToDto(Core.Entities.Hospital h) => new(
        h.Id, h.Name, h.Description, h.Address, h.City, h.State, h.Country,
        h.Latitude, h.Longitude, h.Phone, h.Email, h.Website, h.BedCapacity,
        h.AverageRating, h.TotalReviews, new List<string>(), new List<string>()
    );

    private static DoctorDto MapDoctorToDto(Core.Entities.Doctor d) => new(
        d.Id, d.HospitalId, d.Hospital?.Name ?? "", d.FirstName, d.LastName,
        d.Email, d.Phone, d.Qualification, d.YearsOfExperience, d.Biography,
        d.ProfileImageUrl, d.ConsultationFee, d.AverageRating, d.TotalReviews,
        d.Specialties.Select(s => s.Specialty.Name).ToList(),
        d.Languages.Select(l => l.Language.Name).ToList(),
        d.Credentials.Select(c => new CredentialDto(c.Type, c.Name, c.IssuingOrganization, c.IssueDate, c.ExpiryDate, c.IsVerified)).ToList()
    );
}
