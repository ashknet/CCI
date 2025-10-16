using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/cities")]
[AllowAnonymous]
[ApiVersion("1.0")]
public class CitiesController : ControllerBase
{
    /// <summary>
    /// Get all cities where services are available
    /// </summary>
    [HttpGet]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetCities()
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var cities = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                name = "Hyderabad",
                state = "Telangana",
                country = "India",
                latitude = 17.3850,
                longitude = 78.4867,
                hospitalCount = 50,
                specialties = new[] { "Cardiology", "Orthopedics", "Oncology" }
            },
            new {
                id = Guid.NewGuid(),
                name = "Bangalore",
                state = "Karnataka",
                country = "India",
                latitude = 12.9716,
                longitude = 77.5946,
                hospitalCount = 45,
                specialties = new[] { "Neurology", "Cardiology", "Oncology" }
            },
            new {
                id = Guid.NewGuid(),
                name = "Mumbai",
                state = "Maharashtra",
                country = "India",
                latitude = 19.0760,
                longitude = 72.8777,
                hospitalCount = 60,
                specialties = new[] { "Cardiology", "Gastroenterology", "Oncology" }
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(cities, null, correlationId));
    }

    /// <summary>
    /// Get city details by ID
    /// </summary>
    [HttpGet("{cityId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetCity(Guid cityId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var city = new
        {
            id = cityId,
            name = "Hyderabad",
            state = "Telangana",
            country = "India",
            latitude = 17.3850,
            longitude = 78.4867,
            hospitalCount = 50,
            airports = new[] { new { code = "HYD", name = "Rajiv Gandhi International Airport" } },
            trainStations = new[] { "Secunderabad Junction", "Hyderabad Deccan" },
            topHospitals = new[] { "Apollo Hospitals", "Yashoda Hospitals", "KIMS Hospitals" },
            specialties = new[] { "Cardiology", "Orthopedics", "Oncology", "Neurology" }
        };

        return Ok(ApiResponse<object>.SuccessResponse(city, null, correlationId));
    }
}
