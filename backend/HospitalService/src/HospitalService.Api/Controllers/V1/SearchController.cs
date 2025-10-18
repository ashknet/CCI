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
    private readonly ILogger<SearchController> _logger;
    private readonly IHospitalRepository _hospitalRepository;
    private readonly IDoctorRepository _doctorRepository;
    private readonly ISpecialtyRepository _specialtyRepository;
    private readonly IFastSearchService _fastSearchService;

    public SearchController(
        ILogger<SearchController> logger,
        IHospitalRepository hospitalRepository,
        IDoctorRepository doctorRepository,
        ISpecialtyRepository specialtyRepository,
        IFastSearchService fastSearchService)
    {
        _logger = logger;
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
            "hospital" => await SearchHospitalsInternal(request),
            "doctor" => await SearchDoctorsInternal(request),
            "location" => await SearchLocationsInternal(q),
            "disease" => await SearchDiseasesInternal(q),
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

    /// <summary>
    /// Search hospitals specifically
    /// </summary>
    [HttpPost("hospitals")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalDto>>>> SearchHospitals(
        [FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (request == null || string.IsNullOrWhiteSpace(request.Query) || request.Query.Length < 3)
            return BadRequest(ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalDto>>.ErrorResponse(
                "Query must be at least 3 characters", 
                new List<string> { "Query parameter is required and must be at least 3 characters long" }, 
                correlationId));

        try
        {
            // Set category to hospital if not specified
            if (string.IsNullOrEmpty(request.Category))
                request = request with { Category = "hospital" };
            
            var results = await SearchHospitalsInternal(request);
            
            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalDto>>.SuccessResponse(
                results, $"Found {results.TotalCount} hospitals", correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error searching hospitals with query: {Query}", request?.Query);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while searching hospitals" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Search doctors specifically
    /// </summary>
    [HttpPost("doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorDto>>>> SearchDoctors(
        [FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (request == null || string.IsNullOrWhiteSpace(request.Query) || request.Query.Length < 3)
            return BadRequest(ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorDto>>.ErrorResponse(
                "Query must be at least 3 characters", 
                new List<string> { "Query parameter is required and must be at least 3 characters long" }, 
                correlationId));

        try
        {
            // Set category to doctor if not specified
            if (string.IsNullOrEmpty(request.Category))
                request = request with { Category = "doctor" };
            
            var results = await SearchDoctorsInternal(request);
            
            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorDto>>.SuccessResponse(
                results, $"Found {results.TotalCount} doctors", correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error searching doctors with query: {Query}", request?.Query);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while searching doctors" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Search locations (cities, states, countries)
    /// </summary>
    [HttpPost("locations")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<object>>>> SearchLocations(
        [FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (request == null || string.IsNullOrWhiteSpace(request.Query) || request.Query.Length < 2)
            return BadRequest(ApiResponse<List<object>>.ErrorResponse(
                "Query must be at least 2 characters", 
                new List<string> { "Query parameter is required and must be at least 2 characters long" }, 
                correlationId));

        try
        {
            var results = await SearchLocationsInternal(request.Query);
            
            return Ok(ApiResponse<List<object>>.SuccessResponse(
                results, $"Found {results.Count} locations", correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error searching locations with query: {Query}", request?.Query);
            return StatusCode(500, ApiResponse<List<object>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while searching locations" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Search diseases and medical conditions
    /// </summary>
    [HttpPost("diseases")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<object>>>> SearchDiseases(
        [FromBody] SearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (request == null || string.IsNullOrWhiteSpace(request.Query) || request.Query.Length < 2)
            return BadRequest(ApiResponse<List<object>>.ErrorResponse(
                "Query must be at least 2 characters", 
                new List<string> { "Query parameter is required and must be at least 2 characters long" }, 
                correlationId));

        try
        {
            var results = await SearchDiseasesInternal(request.Query);
            
            return Ok(ApiResponse<List<object>>.SuccessResponse(
                results, $"Found {results.Count} diseases", correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error searching diseases with query: {Query}", request?.Query);
            return StatusCode(500, ApiResponse<List<object>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while searching diseases" }, 
                correlationId));
        }
    }

    private async Task<MedTravel.Shared.Models.PagedResult<HospitalDto>> SearchHospitalsInternal(SearchRequest request)
    {
        var hospitals = await _hospitalRepository.SearchAsync(request);
        var count = await _hospitalRepository.GetSearchCountAsync(request);

        return new MedTravel.Shared.Models.PagedResult<HospitalDto>
        {
            Items = hospitals.Select(h => new HospitalDto(
                h.Id, h.Name, h.Description, h.Address, 
                h.City?.Name ?? "", h.City?.State ?? "", h.Country?.Name ?? "",
                h.Latitude, h.Longitude, h.Phone, h.Email, h.Website, h.BedCapacity,
                h.YearEstablished, h.AverageRating, h.TotalReviews, 
                new List<string>(), new List<string>()
            )).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };
    }

    private async Task<MedTravel.Shared.Models.PagedResult<DoctorDto>> SearchDoctorsInternal(SearchRequest request)
    {
        var doctors = await _doctorRepository.SearchAsync(request);
        var count = await _doctorRepository.GetSearchCountAsync(request);

        return new MedTravel.Shared.Models.PagedResult<DoctorDto>
        {
            Items = doctors.Select(d => new DoctorDto(
                d.Id, d.HospitalId, d.Hospital?.Name ?? "", d.FirstName, d.LastName,
                d.Email, d.Phone ?? "", d.Qualification ?? "", d.YearsOfExperience ?? 0, d.Biography ?? "",
                d.ProfileImageUrl ?? "", d.ConsultationFee ?? 0, d.AverageRating, d.TotalReviews,
                d.Specialties.Select(s => s.Name).ToList(),
                d.Languages.Select(l => l.Name).ToList(),
                d.Credentials.Select(c => new CredentialDto(c.Type, c.Name, c.IssuingOrganization ?? "", c.IssueDate ?? DateTime.MinValue, c.ExpiryDate, c.IsVerified ?? false)).ToList()
            )).ToList(),
            TotalCount = count,
            PageNumber = request.PageNumber,
            PageSize = request.PageSize
        };
    }

    private async Task<List<object>> SearchLocationsInternal(string query)
    {
        // Mock location search
        return new List<object>
        {
            new { id = Guid.NewGuid(), name = "Hyderabad", type = "city", country = "India" },
            new { id = Guid.NewGuid(), name = "Bangalore", type = "city", country = "India" }
        };
    }

    private async Task<List<object>> SearchDiseasesInternal(string query)
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
        var hospitals = await SearchHospitalsInternal(request);
        var doctors = await SearchDoctorsInternal(request);

        return new
        {
            hospitals = hospitals.Items.Take(5),
            doctors = doctors.Items.Take(5),
            locations = await SearchLocationsInternal(request.Query),
            diseases = await SearchDiseasesInternal(request.Query)
        };
    }
}
