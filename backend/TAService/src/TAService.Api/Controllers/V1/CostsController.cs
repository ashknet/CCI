using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportationAccommodationService.Core.DTOs;

namespace TransportationAccommodationService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/costs")]
[Authorize]
[ApiVersion("1.0")]
public class CostsController : ControllerBase
{
    /// <summary>
    /// Create cost estimate for treatment, travel, and stay
    /// </summary>
    [HttpPost("estimate")]
    public async Task<ActionResult<ApiResponse<object>>> CreateEstimate([FromBody] object estimateRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var estimate = new
        {
            id = Guid.NewGuid(),
            userId,
            treatment = new {
                procedure = "Cardiac Surgery",
                hospitalFee = 450000,
                consultationFee = 2000,
                diagnosticTests = 25000,
                medications = 15000,
                subtotal = 492000
            },
            travel = new {
                flightCost = 85000,
                localTransport = 5000,
                subtotal = 90000
            },
            stay = new {
                hotelCost = 85000,
                meals = 15000,
                subtotal = 100000
            },
            totalEstimate = 682000,
            currency = "INR",
            validUntil = DateTime.UtcNow.AddDays(30),
            createdAt = DateTime.UtcNow
        };

        return Ok(ApiResponse<object>.SuccessResponse(estimate, "Estimate created", correlationId));
    }

    /// <summary>
    /// Get cost estimate by ID
    /// </summary>
    [HttpGet("estimates/{estimateId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetEstimate(Guid estimateId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var estimate = new
        {
            id = estimateId,
            totalEstimate = 682000,
            currency = "INR",
            breakdown = new {
                medical = 492000,
                travel = 90000,
                accommodation = 100000
            },
            validUntil = DateTime.UtcNow.AddDays(30)
        };

        return Ok(ApiResponse<object>.SuccessResponse(estimate, null, correlationId));
    }

    /// <summary>
    /// Get itemized line items for estimate
    /// </summary>
    [HttpGet("estimates/{estimateId}/line-items")]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetEstimateLineItems(Guid estimateId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var lineItems = new List<object>
        {
            new { category = "Medical", item = "Hospital Fee", amount = 450000, currency = "INR" },
            new { category = "Medical", item = "Consultation", amount = 2000, currency = "INR" },
            new { category = "Medical", item = "Diagnostic Tests", amount = 25000, currency = "INR" },
            new { category = "Travel", item = "Flight Tickets", amount = 85000, currency = "INR" },
            new { category = "Travel", item = "Local Transport", amount = 5000, currency = "INR" },
            new { category = "Accommodation", item = "Hotel (10 nights)", amount = 85000, currency = "INR" },
            new { category = "Accommodation", item = "Meals", amount = 15000, currency = "INR" }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(lineItems, null, correlationId));
    }
}
