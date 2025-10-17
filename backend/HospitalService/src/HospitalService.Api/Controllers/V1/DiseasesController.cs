using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using HospitalService.Core.Models;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/diseases")]
[ApiVersion("1.0")]
[Authorize]
public class DiseasesController : ControllerBase
{
    private readonly IDiseaseService _diseaseService;
    private readonly ILogger<DiseasesController> _logger;

    public DiseasesController(
        IDiseaseService diseaseService,
        ILogger<DiseasesController> logger)
    {
        _diseaseService = diseaseService;
        _logger = logger;
    }

    /// <summary>
    /// Get all doctors that treat a specific disease
    /// </summary>
    [HttpGet("{diseaseId}/doctors")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DiseaseDoctorsDto>>> GetDiseaseDoctors(
        Guid diseaseId,
        [FromQuery] string? city = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var result = await _diseaseService.GetDiseaseDoctorsAsync(
                diseaseId, city, page, pageSize);

            if (result == null)
            {
                return NotFound(ApiResponse<DiseaseDoctorsDto>.ErrorResponse(
                    "DISEASE_NOT_FOUND", 
                    $"Disease with ID {diseaseId} not found", 
                    correlationId));
            }

            return Ok(ApiResponse<DiseaseDoctorsDto>.SuccessResponse(
                result, 
                "Disease doctors retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctors for disease ID {DiseaseId}", diseaseId);
            return StatusCode(500, ApiResponse<DiseaseDoctorsDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving disease doctors", 
                correlationId));
        }
    }

    /// <summary>
    /// Get all available diseases
    /// </summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DiseaseDto>>>> GetDiseases(
        [FromQuery] string? category = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 50;

            var diseases = await _diseaseService.GetDiseasesAsync(category, page, pageSize);

            return Ok(ApiResponse<PagedResult<DiseaseDto>>.SuccessResponse(
                diseases, 
                "Diseases retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving diseases");
            return StatusCode(500, ApiResponse<PagedResult<DiseaseDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving diseases", 
                correlationId));
        }
    }

    /// <summary>
    /// Get disease details by ID
    /// </summary>
    [HttpGet("{diseaseId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DiseaseDto>>> GetDisease(Guid diseaseId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var disease = await _diseaseService.GetDiseaseByIdAsync(diseaseId);
            if (disease == null)
            {
                return NotFound(ApiResponse<DiseaseDto>.ErrorResponse(
                    "DISEASE_NOT_FOUND", 
                    $"Disease with ID {diseaseId} not found", 
                    correlationId));
            }

            return Ok(ApiResponse<DiseaseDto>.SuccessResponse(
                disease, 
                "Disease retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving disease ID {DiseaseId}", diseaseId);
            return StatusCode(500, ApiResponse<DiseaseDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving disease", 
                correlationId));
        }
    }

    /// <summary>
    /// Get diseases by category
    /// </summary>
    [HttpGet("category/{category}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DiseaseDto>>>> GetDiseasesByCategory(
        string category,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 50;

            var diseases = await _diseaseService.GetDiseasesByCategoryAsync(
                category, page, pageSize);

            return Ok(ApiResponse<PagedResult<DiseaseDto>>.SuccessResponse(
                diseases, 
                "Category diseases retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving diseases for category {Category}", category);
            return StatusCode(500, ApiResponse<PagedResult<DiseaseDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving category diseases", 
                correlationId));
        }
    }
}