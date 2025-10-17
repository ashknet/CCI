using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TransportationAccommodationService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/integrations")]
[Authorize]
[ApiVersion("1.0")]
public class IntegrationsController : ControllerBase
{
    /// <summary>
    /// Generate redirect token for partner booking platforms
    /// </summary>
    [HttpPost("redirect-token")]
    public async Task<ActionResult<ApiResponse<object>>> GenerateRedirectToken([FromBody] object redirectRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var token = new
        {
            redirectToken = Guid.NewGuid().ToString("N"),
            partnerId = "IRCTC",
            expiresIn = 300,
            expiresAt = DateTime.UtcNow.AddMinutes(5),
            redirectUrl = "https://www.irctc.co.in/nget/booking",
            payload = new {
                from = "DEL",
                to = "HYD",
                date = DateTime.UtcNow.AddDays(10),
                passengers = 1,
                classType = "AC_2TIER"
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(token, "Redirect token generated", correlationId));
    }

    /// <summary>
    /// Get list of configured integration providers
    /// </summary>
    [HttpGet("providers")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetProviders()
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var providers = new List<object>
        {
            new {
                id = "IRCTC",
                name = "Indian Railway Catering and Tourism Corporation",
                type = "train_booking",
                isActive = true,
                supportedRoutes = "All India",
                integrationMethod = "redirect"
            },
            new {
                id = "REDBUS",
                name = "RedBus",
                type = "bus_booking",
                isActive = true,
                supportedRoutes = "Major cities",
                integrationMethod = "redirect"
            },
            new {
                id = "MAKEMYTRIP",
                name = "MakeMyTrip",
                type = "flight_hotel_booking",
                isActive = true,
                supportedRoutes = "International and Domestic",
                integrationMethod = "api"
            },
            new {
                id = "RAZORPAY",
                name = "Razorpay",
                type = "payment_gateway",
                isActive = true,
                supportedMethods = new[] { "Card", "UPI", "NetBanking", "Wallet" },
                integrationMethod = "api"
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(providers, null, correlationId));
    }
}
