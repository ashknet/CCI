using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MessagingService.Core.DTOs;

namespace MessagingService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MessagesController : ControllerBase
{
    /// <summary>
    /// Get user's message threads
    /// </summary>
    [HttpGet("threads")]
    public async Task<ActionResult<ApiResponse<PagedResult<ThreadDto>>>> GetThreads(
        [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var threads = new List<ThreadDto>
        {
            new(Guid.NewGuid(), userId, Guid.NewGuid(), "doctor", "Dr. Rajesh Kumar",
                "Post-operative questions", "active", null, null, DateTime.UtcNow.AddDays(-2),
                DateTime.UtcNow.AddHours(-3), 2)
        };

        var result = new PagedResult<ThreadDto>
        {
            Items = threads,
            TotalCount = threads.Count,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        return Ok(ApiResponse<PagedResult<ThreadDto>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Get thread messages
    /// </summary>
    [HttpGet("threads/{threadId}")]
    public async Task<ActionResult<ApiResponse<List<MessageDto>>>> GetThreadMessages(Guid threadId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var messages = new List<MessageDto>
        {
            new(Guid.NewGuid(), threadId, Guid.NewGuid(), "patient", "You",
                "Hello doctor, I have some questions", true, DateTime.UtcNow.AddHours(-2),
                DateTime.UtcNow.AddHours(-2), new List<AttachmentDto>()),
            new(Guid.NewGuid(), threadId, Guid.NewGuid(), "provider", "Dr. Rajesh Kumar",
                "Of course, I'm here to help. What would you like to know?", false, null,
                DateTime.UtcNow.AddHours(-1), new List<AttachmentDto>())
        };

        return Ok(ApiResponse<List<MessageDto>>.SuccessResponse(messages, null, correlationId));
    }

    /// <summary>
    /// Create new thread
    /// </summary>
    [HttpPost("threads")]
    public async Task<ActionResult<ApiResponse<ThreadDto>>> CreateThread([FromBody] CreateThreadRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var thread = new ThreadDto(
            Guid.NewGuid(), userId, request.ProviderId, request.ProviderType, "Provider Name",
            request.Subject, "active", request.RelatedBookingId, request.RelatedAppointmentId,
            DateTime.UtcNow, null, 0
        );

        return Ok(ApiResponse<ThreadDto>.SuccessResponse(thread, "Thread created successfully", correlationId));
    }

    /// <summary>
    /// Send message in thread
    /// </summary>
    [HttpPost("threads/{threadId}/messages")]
    public async Task<ActionResult<ApiResponse<MessageDto>>> SendMessage(Guid threadId, [FromBody] SendMessageRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var message = new MessageDto(
            Guid.NewGuid(), threadId, userId, "patient", "You",
            request.Content, true, null, DateTime.UtcNow, new List<AttachmentDto>()
        );

        return Ok(ApiResponse<MessageDto>.SuccessResponse(message, "Message sent successfully", correlationId));
    }

    /// <summary>
    /// Mark message as read
    /// </summary>
    [HttpPatch("threads/{threadId}/messages/{messageId}/read")]
    public async Task<ActionResult<ApiResponse<object>>> MarkAsRead(Guid threadId, Guid messageId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        return Ok(ApiResponse<object>.SuccessResponse(null, "Message marked as read", correlationId));
    }

    /// <summary>
    /// Archive thread
    /// </summary>
    [HttpPatch("threads/{threadId}/archive")]
    public async Task<ActionResult<ApiResponse<object>>> ArchiveThread(Guid threadId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        return Ok(ApiResponse<object>.SuccessResponse(null, "Thread archived successfully", correlationId));
    }
}
