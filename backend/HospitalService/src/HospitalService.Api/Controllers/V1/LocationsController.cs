using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/locations")]
[AllowAnonymous]
[ApiVersion("1.0")]
public class LocationsController : ControllerBase
{
    /// <summary>
    /// Find nearby hospitals/clinics by coordinates
    /// </summary>
    [HttpGet("nearby")]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetNearbyLocations(
        [FromQuery] decimal lat,
        [FromQuery] decimal lng,
        [FromQuery] int radius = 10)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        // Mock nearby locations using Haversine formula would be implemented here
        var locations = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                name = "Apollo Hospitals",
                type = "hospital",
                latitude = lat + 0.01m,
                longitude = lng + 0.01m,
                distanceKm = 1.5m,
                address = "Jubilee Hills, Hyderabad"
            },
            new {
                id = Guid.NewGuid(),
                name = "Care Hospitals",
                type = "hospital",
                latitude = lat - 0.02m,
                longitude = lng + 0.02m,
                distanceKm = 3.2m,
                address = "Banjara Hills, Hyderabad"
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(locations, null, correlationId));
    }
}
