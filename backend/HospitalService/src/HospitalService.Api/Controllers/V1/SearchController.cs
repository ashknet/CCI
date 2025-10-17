using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Services;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/search")]
[ApiVersion("1.0")]
public class SearchController : ControllerBase
{
    private readonly IHospitalRepository _hospitalRepository;
    private readonly IDoctorRepository _doctorRepository;
    private readonly ISpecialtyRepository _specialtyRepository;
    private readonly IFastSearchService _fastSearchService;

    public SearchController(
        IHospitalRepository hospitalRepository,
        IDoctorRepository doctorRepository,
        ISpecialtyRepository specialtyRepository,
        IFastSearchService fastSearchService)
    {
        _hospitalRepository = hospitalRepository;
        _doctorRepository = doctorRepository;
        _specialtyRepository = specialtyRepository;
        _fastSearchService = fastSearchService;
    }

    /// <summary>
    /// Universal search endpoint with category filter
    /// </summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> Search(
        [FromQuery] string q,
        [FromQuery] string? category = null,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (string.IsNullOrWhiteSpace(q) || q.Length < 3)
            return BadRequest(ApiResponse<object>.ErrorResponse("Query must be at least 3 characters", null, correlationId));

        var request = new SearchRequest(q, category, null, null, null, null, pageNumber, pageSize, "relevance");

        object results = category?.ToLower() switch
        {
            "hospital" => await SearchHospitals(request),
            "doctor" => await SearchDoctors(request),
            "location" => await SearchLocations(q),
            "disease" => await SearchDiseases(q),
            _ => await SearchAll(request)
        };

        return Ok(ApiResponse<object>.SuccessResponse(results, null, correlationId));
    }

    /// <summary>
    /// Ultra-fast type-ahead suggestions using ADO.NET and caching
    /// Optimized for Google-like instant search experience
    /// Returns results in < 50ms for cached queries
    /// </summary>
    [HttpGet("suggest")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<Infrastructure.Services.SearchSuggestion>>>> GetSuggestions([FromQuery] string term)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        // Allow 2+ characters for better UX
        if (string.IsNullOrWhiteSpace(term) || term.Length < 2)
            return Ok(ApiResponse<List<Infrastructure.Services.SearchSuggestion>>.SuccessResponse(
                new List<Infrastructure.Services.SearchSuggestion>(), null, correlationId));

        // Use high-performance search service with ADO.NET and caching
        var suggestions = await _fastSearchService.GetSuggestionsAsync(term, 10);
        
        return Ok(ApiResponse<List<Infrastructure.Services.SearchSuggestion>>.SuccessResponse(
            suggestions, $"Found {suggestions.Count} suggestions", correlationId));
    }

    private async Task<PagedResult<HospitalDto>> SearchHospitals(SearchRequest request)
    {
        var hospitals = await _hospitalRepository.SearchAsync(request);
        var count = await _hospitalRepository.GetSearchCountAsync(request);

        return new PagedResult<HospitalDto>
        {
            Items = hospitals.Select(h => new HospitalDto(
                h.Id, h.Name, h.Description, h.Address, h.City, h.State, h.Country,
                h.Latitude, h.Longitude, h.Phone, h.Email, h.Website, h.BedCapacity,
                h.AverageRating, h.TotalReviews, new List<string>(), new List<string>()
            )).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };
    }

    private async Task<PagedResult<DoctorDto>> SearchDoctors(SearchRequest request)
    {
        var doctors = await _doctorRepository.SearchAsync(request);
        var count = await _doctorRepository.GetSearchCountAsync(request);

        return new PagedResult<DoctorDto>
        {
            Items = doctors.Select(d => new DoctorDto(
                d.Id, d.HospitalId, d.Hospital?.Name ?? "", d.FirstName, d.LastName,
                d.Email, d.Phone, d.Qualification, d.YearsOfExperience, d.Biography,
                d.ProfileImageUrl, d.ConsultationFee, d.AverageRating, d.TotalReviews,
                d.Specialties.Select(s => s.Specialty.Name).ToList(),
                d.Languages.Select(l => l.Language.Name).ToList(),
                d.Credentials.Select(c => new CredentialDto(c.Type, c.Name, c.IssuingOrganization, c.IssueDate, c.ExpiryDate, c.IsVerified)).ToList()
            )).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };
    }

    private async Task<List<object>> SearchLocations(string query)
    {
        // Mock location search
        return new List<object>
        {
            new { id = Guid.NewGuid(), name = "Hyderabad", type = "city", country = "India" },
            new { id = Guid.NewGuid(), name = "Bangalore", type = "city", country = "India" }
        };
    }

    private async Task<List<object>> SearchDiseases(string query)
    {
        // Mock disease search
        return new List<object>
        {
            new { id = Guid.NewGuid(), name = "Cardiac Disease", category = "Cardiology" },
            new { id = Guid.NewGuid(), name = "Diabetes", category = "Endocrinology" }
        };
    }

    private async Task<object> SearchAll(SearchRequest request)
    {
        var hospitals = await SearchHospitals(request);
        var doctors = await SearchDoctors(request);

        return new
        {
            hospitals = hospitals.Items.Take(5),
            doctors = doctors.Items.Take(5),
            locations = await SearchLocations(request.Query),
            diseases = await SearchDiseases(request.Query)
        };
    }
}
