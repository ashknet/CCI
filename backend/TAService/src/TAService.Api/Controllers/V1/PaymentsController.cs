using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TransportationAccommodationService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/payments")]
[Authorize]
[ApiVersion("1.0")]
public class PaymentsController : ControllerBase
{
    /// <summary>
    /// Initiate payment
    /// </summary>
    [HttpPost]
    public async Task<ActionResult<ApiResponse<object>>> InitiatePayment([FromBody] object paymentRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var payment = new
        {
            id = Guid.NewGuid(),
            userId,
            amount = 682000m,
            currency = "INR",
            status = "pending",
            paymentMethod = "card",
            paymentUrl = "https://payments.medtravel.com/checkout/...",
            expiresIn = 900,
            createdAt = DateTime.UtcNow
        };

        return Ok(ApiResponse<object>.SuccessResponse(payment, "Payment initiated", correlationId));
    }

    /// <summary>
    /// Capture payment after authorization
    /// </summary>
    [HttpPost("{paymentId}/capture")]
    public async Task<ActionResult<ApiResponse<object>>> CapturePayment(Guid paymentId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var payment = new
        {
            id = paymentId,
            status = "captured",
            amount = 682000m,
            currency = "INR",
            transactionId = $"TXN{Guid.NewGuid().ToString("N")[..12].ToUpper()}",
            capturedAt = DateTime.UtcNow
        };

        return Ok(ApiResponse<object>.SuccessResponse(payment, "Payment captured successfully", correlationId));
    }

    /// <summary>
    /// Refund payment
    /// </summary>
    [HttpPost("{paymentId}/refund")]
    public async Task<ActionResult<ApiResponse<object>>> RefundPayment(
        Guid paymentId,
        [FromBody] object refundRequest)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var refund = new
        {
            id = Guid.NewGuid(),
            paymentId,
            amount = 682000m,
            currency = "INR",
            status = "processing",
            refundMethod = "original_payment_method",
            estimatedCompletionDate = DateTime.UtcNow.AddDays(7),
            refundReference = $"REF{Guid.NewGuid().ToString("N")[..10].ToUpper()}",
            createdAt = DateTime.UtcNow
        };

        return Ok(ApiResponse<object>.SuccessResponse(refund, "Refund initiated", correlationId));
    }

    /// <summary>
    /// Get payment receipt
    /// </summary>
    [HttpGet("{paymentId}/receipt")]
    public async Task<ActionResult<ApiResponse<object>>> GetReceipt(Guid paymentId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var receipt = new
        {
            id = paymentId,
            receiptNumber = $"RCP{Guid.NewGuid().ToString("N")[..10].ToUpper()}",
            date = DateTime.UtcNow,
            payerName = "John Doe",
            amount = 682000m,
            currency = "INR",
            lineItems = new[]
            {
                new { description = "Medical Consultation", amount = 492000 },
                new { description = "Travel Booking", amount = 90000 },
                new { description = "Accommodation", amount = 100000 }
            },
            paymentMethod = "Credit Card (****1234)",
            transactionId = $"TXN{Guid.NewGuid().ToString("N")[..12].ToUpper()}",
            status = "paid",
            receiptUrl = $"/receipts/{paymentId}.pdf"
        };

        return Ok(ApiResponse<object>.SuccessResponse(receipt, null, correlationId));
    }

    /// <summary>
    /// Get payment ledger for user
    /// </summary>
    [HttpGet("ledger")]
    public async Task<ActionResult<ApiResponse<PagedResult<object>>>> GetPaymentLedger(
        [FromQuery] Guid? userId = null,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        // Only allow users to see their own ledger unless admin
        if (userId.HasValue && userId.Value != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var targetUserId = userId ?? currentUserId;

        var ledgerEntries = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                date = DateTime.UtcNow.AddDays(-5),
                description = "Appointment Booking - Dr. Rajesh Kumar",
                amount = 2000m,
                currency = "INR",
                type = "debit",
                status = "completed",
                paymentMethod = "Credit Card"
            },
            new {
                id = Guid.NewGuid(),
                date = DateTime.UtcNow.AddDays(-10),
                description = "Flight Booking - AI101",
                amount = 85000m,
                currency = "INR",
                type = "debit",
                status = "completed",
                paymentMethod = "UPI"
            }
        };

        var result = new PagedResult<object>
        {
            Items = ledgerEntries,
            TotalCount = ledgerEntries.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<PagedResult<object>>.SuccessResponse(result, null, correlationId));
    }
}
