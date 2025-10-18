using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using MedTravel.Shared.Models;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/selection")]
[ApiVersion("1.0")]
[Authorize]
public class SelectionFlowController : ControllerBase
{
    private readonly ISelectionFlowService _selectionFlowService;
    private readonly ILogger<SelectionFlowController> _logger;

    public SelectionFlowController(
        ISelectionFlowService selectionFlowService,
        ILogger<SelectionFlowController> logger)
    {
        _selectionFlowService = selectionFlowService;
        _logger = logger;
    }

    /// <summary>
    /// Get doctor selection with profile and availability
    /// </summary>
    [HttpGet("doctors/{doctorId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DoctorSelectionDto>>> GetDoctorSelection(
        Guid doctorId,
        [FromQuery] DateTime? startDate = null,
        [FromQuery] DateTime? endDate = null,
        [FromQuery] bool includeReviews = true,
        [FromQuery] int reviewLimit = 5)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new DoctorSelectionRequest
            {
                DoctorId = doctorId,
                StartDate = startDate,
                EndDate = endDate,
                IncludeReviews = includeReviews,
                ReviewLimit = reviewLimit
            };

            var result = await _selectionFlowService.GetDoctorSelectionAsync(doctorId, request);
            
            if (result == null)
            {
                return NotFound(ApiResponse<DoctorSelectionDto>.ErrorResponse(
                    "DOCTOR_NOT_FOUND",
                    new List<string> { $"Doctor with ID {doctorId} not found" },
                    correlationId));
            }

            return Ok(ApiResponse<DoctorSelectionDto>.SuccessResponse(
                result,
                "Doctor selection retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting doctor selection for doctor {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<DoctorSelectionDto>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving doctor selection" },
                correlationId));
        }
    }

    /// <summary>
    /// Get doctor availability for appointment booking
    /// </summary>
    [HttpGet("doctors/{doctorId}/availability")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<AppointmentAvailabilityDto>>> GetDoctorAvailability(
        Guid doctorId,
        [FromQuery] DateTime? startDate = null,
        [FromQuery] DateTime? endDate = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var result = await _selectionFlowService.GetDoctorAvailabilityAsync(doctorId, startDate, endDate);
            
            return Ok(ApiResponse<AppointmentAvailabilityDto>.SuccessResponse(
                result,
                "Doctor availability retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting doctor availability for doctor {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<AppointmentAvailabilityDto>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving doctor availability" },
                correlationId));
        }
    }

    /// <summary>
    /// Get hospital selection with doctors and specialties
    /// </summary>
    [HttpGet("hospitals/{hospitalId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<HospitalSelectionDto>>> GetHospitalSelection(
        Guid hospitalId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "rating",
        [FromQuery] bool includeAvailability = true)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new HospitalSelectionRequest
            {
                HospitalId = hospitalId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                IncludeAvailability = includeAvailability
            };

            var result = await _selectionFlowService.GetHospitalSelectionAsync(hospitalId, request);
            
            if (result == null)
            {
                return NotFound(ApiResponse<HospitalSelectionDto>.ErrorResponse(
                    "HOSPITAL_NOT_FOUND",
                    new List<string> { $"Hospital with ID {hospitalId} not found" },
                    correlationId));
            }

            return Ok(ApiResponse<HospitalSelectionDto>.SuccessResponse(
                result,
                "Hospital selection retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting hospital selection for hospital {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<HospitalSelectionDto>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving hospital selection" },
                correlationId));
        }
    }

    /// <summary>
    /// Get doctors at a specific hospital
    /// </summary>
    [HttpGet("hospitals/{hospitalId}/doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DoctorSummaryDto>>>> GetHospitalDoctors(
        Guid hospitalId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "rating",
        [FromQuery] bool includeAvailability = true)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new HospitalSelectionRequest
            {
                HospitalId = hospitalId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                IncludeAvailability = includeAvailability
            };

            var result = await _selectionFlowService.GetHospitalDoctorsAsync(hospitalId, request);
            
            return Ok(ApiResponse<PagedResult<DoctorSummaryDto>>.SuccessResponse(
                result,
                "Hospital doctors retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting hospital doctors for hospital {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<PagedResult<DoctorSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving hospital doctors" },
                correlationId));
        }
    }

    /// <summary>
    /// Get city selection with hospitals and specialties
    /// </summary>
    [HttpGet("cities/{cityId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<CitySelectionDto>>> GetCitySelection(
        Guid cityId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "rating",
        [FromQuery] decimal? maxDistance = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new CitySelectionRequest
            {
                CityId = cityId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                MaxDistance = maxDistance
            };

            var result = await _selectionFlowService.GetCitySelectionAsync(cityId, request);
            
            if (result == null)
            {
                return NotFound(ApiResponse<CitySelectionDto>.ErrorResponse(
                    "CITY_NOT_FOUND",
                    new List<string> { $"City with ID {cityId} not found" },
                    correlationId));
            }

            return Ok(ApiResponse<CitySelectionDto>.SuccessResponse(
                result,
                "City selection retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting city selection for city {CityId}", cityId);
            return StatusCode(500, ApiResponse<CitySelectionDto>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving city selection" },
                correlationId));
        }
    }

    /// <summary>
    /// Get hospitals in a specific city
    /// </summary>
    [HttpGet("cities/{cityId}/hospitals")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<HospitalSummaryDto>>>> GetCityHospitals(
        Guid cityId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "rating",
        [FromQuery] decimal? maxDistance = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new CitySelectionRequest
            {
                CityId = cityId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                MaxDistance = maxDistance
            };

            var result = await _selectionFlowService.GetCityHospitalsAsync(cityId, request);
            
            return Ok(ApiResponse<PagedResult<HospitalSummaryDto>>.SuccessResponse(
                result,
                "City hospitals retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting city hospitals for city {CityId}", cityId);
            return StatusCode(500, ApiResponse<PagedResult<HospitalSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving city hospitals" },
                correlationId));
        }
    }

    /// <summary>
    /// Get disease selection with doctors and specialties
    /// </summary>
    [HttpGet("diseases/{diseaseId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DiseaseSelectionDto>>> GetDiseaseSelection(
        Guid diseaseId,
        [FromQuery] Guid? cityId = null,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "experience",
        [FromQuery] bool includeAvailability = true)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new DiseaseSelectionRequest
            {
                DiseaseId = diseaseId,
                CityId = cityId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                IncludeAvailability = includeAvailability
            };

            var result = await _selectionFlowService.GetDiseaseSelectionAsync(diseaseId, request);
            
            if (result == null)
            {
                return NotFound(ApiResponse<DiseaseSelectionDto>.ErrorResponse(
                    "DISEASE_NOT_FOUND",
                    new List<string> { $"Disease with ID {diseaseId} not found" },
                    correlationId));
            }

            return Ok(ApiResponse<DiseaseSelectionDto>.SuccessResponse(
                result,
                "Disease selection retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting disease selection for disease {DiseaseId}", diseaseId);
            return StatusCode(500, ApiResponse<DiseaseSelectionDto>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving disease selection" },
                correlationId));
        }
    }

    /// <summary>
    /// Get doctors who treat a specific disease
    /// </summary>
    [HttpGet("diseases/{diseaseId}/doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DoctorSelectionSummaryDto>>>> GetDiseaseDoctors(
        Guid diseaseId,
        [FromQuery] Guid? cityId = null,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? sortBy = "experience",
        [FromQuery] bool includeAvailability = true)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var request = new DiseaseSelectionRequest
            {
                DiseaseId = diseaseId,
                CityId = cityId,
                Specialty = specialty,
                Page = page,
                PageSize = pageSize,
                SortBy = sortBy,
                IncludeAvailability = includeAvailability
            };

            var result = await _selectionFlowService.GetDiseaseDoctorsAsync(diseaseId, request);
            
            return Ok(ApiResponse<PagedResult<DoctorSelectionSummaryDto>>.SuccessResponse(
                result,
                "Disease doctors retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting disease doctors for disease {DiseaseId}", diseaseId);
            return StatusCode(500, ApiResponse<PagedResult<DoctorSelectionSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving disease doctors" },
                correlationId));
        }
    }

    /// <summary>
    /// Get available specialties for filtering
    /// </summary>
    [HttpGet("specialties")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<SpecialtyDto>>>> GetAvailableSpecialties(
        [FromQuery] Guid? cityId = null,
        [FromQuery] Guid? hospitalId = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var result = await _selectionFlowService.GetAvailableSpecialtiesAsync(cityId, hospitalId);
            
            return Ok(ApiResponse<List<SpecialtyDto>>.SuccessResponse(
                result,
                "Available specialties retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting available specialties");
            return StatusCode(500, ApiResponse<List<SpecialtyDto>>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving available specialties" },
                correlationId));
        }
    }

    /// <summary>
    /// Check if a doctor is available at a specific time
    /// </summary>
    [HttpGet("doctors/{doctorId}/check-availability")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<bool>>> CheckDoctorAvailability(
        Guid doctorId,
        [FromQuery] DateTime date,
        [FromQuery] TimeSpan time)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var result = await _selectionFlowService.CheckDoctorAvailabilityAsync(doctorId, date, time);
            
            return Ok(ApiResponse<bool>.SuccessResponse(
                result,
                "Doctor availability checked successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking doctor availability for doctor {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<bool>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while checking doctor availability" },
                correlationId));
        }
    }

    /// <summary>
    /// Get next available appointment slot for a doctor
    /// </summary>
    [HttpGet("doctors/{doctorId}/next-available")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DateTime?>>> GetNextAvailableSlot(Guid doctorId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var result = await _selectionFlowService.GetNextAvailableSlotAsync(doctorId);
            
            return Ok(ApiResponse<DateTime?>.SuccessResponse(
                result,
                "Next available slot retrieved successfully",
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting next available slot for doctor {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<DateTime?>.ErrorResponse(
                "INTERNAL_ERROR",
                new List<string> { "An error occurred while retrieving next available slot" },
                correlationId));
        }
    }
}
