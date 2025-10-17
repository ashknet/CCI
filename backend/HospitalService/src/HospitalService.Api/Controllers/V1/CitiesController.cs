using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using HospitalService.Core.Models;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/cities")]
[ApiVersion("1.0")]
[Authorize]
public class CitiesController : ControllerBase
{
    private readonly ICityService _cityService;
    private readonly ILogger<CitiesController> _logger;

    public CitiesController(
        ICityService cityService,
        ILogger<CitiesController> logger)
    {
        _cityService = cityService;
        _logger = logger;
    }

    /// <summary>
    /// Get all hospitals in a specific city
    /// </summary>
    [HttpGet("{cityId}/hospitals")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<CityHospitalsDto>>> GetCityHospitals(
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

            var result = await _cityService.GetCityHospitalsAsync(
                cityId, specialty, page, pageSize);

            if (result == null)
            {
                return NotFound(ApiResponse<CityHospitalsDto>.ErrorResponse(
                    "CITY_NOT_FOUND", 
                    $"City with ID {cityId} not found", 
                    correlationId));
            }

            return Ok(ApiResponse<CityHospitalsDto>.SuccessResponse(
                result, 
                "City hospitals retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving hospitals for city ID {CityId}", cityId);
            return StatusCode(500, ApiResponse<CityHospitalsDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving city hospitals", 
                correlationId));
        }
    }

    /// <summary>
    /// Get all available cities
    /// </summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<CityDto>>>> GetCities(
        [FromQuery] string? country = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 50;

            var cities = await _cityService.GetCitiesAsync(country, page, pageSize);

            return Ok(ApiResponse<PagedResult<CityDto>>.SuccessResponse(
                cities, 
                "Cities retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving cities");
            return StatusCode(500, ApiResponse<PagedResult<CityDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving cities", 
                correlationId));
        }
    }

    /// <summary>
    /// Get city details by ID
    /// </summary>
    [HttpGet("{cityId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<CityDto>>> GetCity(Guid cityId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var city = await _cityService.GetCityByIdAsync(cityId);
            if (city == null)
            {
                return NotFound(ApiResponse<CityDto>.ErrorResponse(
                    "CITY_NOT_FOUND", 
                    $"City with ID {cityId} not found", 
                    correlationId));
            }

            return Ok(ApiResponse<CityDto>.SuccessResponse(
                city, 
                "City retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving city ID {CityId}", cityId);
            return StatusCode(500, ApiResponse<CityDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving city", 
                correlationId));
        }
    }
}