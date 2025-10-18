using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using MedTravel.Shared.Models;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/hospitals")]
[ApiVersion("1.0")]
[Authorize]
public class HospitalsController : ControllerBase
{
    private readonly IHospitalService _hospitalService;
    private readonly ILogger<HospitalsController> _logger;

    public HospitalsController(
        IHospitalService hospitalService,
        ILogger<HospitalsController> logger)
    {
        _hospitalService = hospitalService;
        _logger = logger;
    }

    /// <summary>
    /// Get detailed hospital profile with specialties, amenities, and reviews
    /// </summary>
    [HttpGet("{hospitalId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<HospitalProfileDto>>> GetHospitalProfile(Guid hospitalId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var hospital = await _hospitalService.GetHospitalProfileAsync(hospitalId);
            if (hospital == null)
            {
                return NotFound(ApiResponse<HospitalProfileDto>.ErrorResponse(
                    "HOSPITAL_NOT_FOUND", 
                    new List<string> { $"Hospital with ID {hospitalId} not found" }, 
                    correlationId));
            }

            return Ok(ApiResponse<HospitalProfileDto>.SuccessResponse(
                hospital, 
                "Hospital profile retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving hospital profile for ID {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<HospitalProfileDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while retrieving hospital profile" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Get all doctors at a specific hospital
    /// </summary>
    [HttpGet("{hospitalId}/doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>>>> GetHospitalDoctors(
        Guid hospitalId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var doctors = await _hospitalService.GetHospitalDoctorsAsync(
                hospitalId, specialty, page, pageSize);

            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>>.SuccessResponse(
                doctors, 
                "Hospital doctors retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctors for hospital ID {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<DoctorSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while retrieving hospital doctors" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Get hospitals by city
    /// </summary>
    [HttpGet("city/{cityId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>>> GetHospitalsByCity(
        Guid cityId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var hospitals = await _hospitalService.GetHospitalsByCityAsync(
                cityId, specialty, page, pageSize);

            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>.SuccessResponse(
                hospitals, 
                "City hospitals retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving hospitals for city ID {CityId}", cityId);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while retrieving city hospitals" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Get hospitals by specialty
    /// </summary>
    [HttpGet("specialty/{specialty}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>>> GetHospitalsBySpecialty(
        string specialty,
        [FromQuery] string? city = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var hospitals = await _hospitalService.GetHospitalsBySpecialtyAsync(
                specialty, city, page, pageSize);

            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>.SuccessResponse(
                hospitals, 
                "Specialty hospitals retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving hospitals for specialty {Specialty}", specialty);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<HospitalSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while retrieving specialty hospitals" }, 
                correlationId));
        }
    }

    /// <summary>
    /// Get hospital reviews
    /// </summary>
    [HttpGet("{hospitalId}/reviews")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<MedTravel.Shared.Models.PagedResult<ReviewDto>>>> GetHospitalReviews(
        Guid hospitalId,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var reviews = await _hospitalService.GetHospitalReviewsAsync(
                hospitalId, page, pageSize);

            return Ok(ApiResponse<MedTravel.Shared.Models.PagedResult<ReviewDto>>.SuccessResponse(
                reviews, 
                "Hospital reviews retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving reviews for hospital ID {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<MedTravel.Shared.Models.PagedResult<ReviewDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                new List<string> { "An error occurred while retrieving hospital reviews" }, 
                correlationId));
        }
    }
}
