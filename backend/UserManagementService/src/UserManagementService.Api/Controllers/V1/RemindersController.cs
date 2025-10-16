using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/reminders")]
[Authorize]
[ApiVersion("1.0")]
public class RemindersController : ControllerBase
{
    /// <summary>
    /// Schedule appointment reminder
    /// </summary>
    [HttpPost("appointments")]
    public async Task<ActionResult<ApiResponse<object>>> ScheduleAppointmentReminder([FromBody] object reminderRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var reminder = new
        {
            id = Guid.NewGuid(),
            type = "appointment",
            scheduledFor = DateTime.UtcNow.AddDays(9).AddHours(8),
            message = "Reminder: You have an appointment tomorrow at 10:00 AM with Dr. Rajesh Kumar",
            channels = new[] { "email", "sms", "push" }
        };

        return Ok(ApiResponse<object>.SuccessResponse(reminder, "Appointment reminder scheduled", correlationId));
    }

    /// <summary>
    /// Schedule travel reminder
    /// </summary>
    [HttpPost("travel")]
    public async Task<ActionResult<ApiResponse<object>>> ScheduleTravelReminder([FromBody] object reminderRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var reminder = new
        {
            id = Guid.NewGuid(),
            type = "travel",
            scheduledFor = DateTime.UtcNow.AddDays(8).AddHours(8),
            message = "Reminder: Your flight AI101 departs in 48 hours. Check-in opens 24 hours before departure.",
            channels = new[] { "email", "sms" }
        };

        return Ok(ApiResponse<object>.SuccessResponse(reminder, "Travel reminder scheduled", correlationId));
    }

    /// <summary>
    /// Schedule pre-operative instructions reminder
    /// </summary>
    [HttpPost("instructions")]
    public async Task<ActionResult<ApiResponse<object>>> ScheduleInstructionsReminder([FromBody] object reminderRequest)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var reminder = new
        {
            id = Guid.NewGuid(),
            type = "instructions",
            scheduledFor = DateTime.UtcNow.AddDays(3),
            message = "Important: Stop taking blood thinners 7 days before your surgery. Begin fasting 8 hours before the procedure.",
            channels = new[] { "email", "sms", "push" },
            attachments = new[] {
                new { name = "Pre-Op Instructions.pdf", url = "/documents/pre-op-instructions.pdf" },
                new { name = "What to Bring Checklist.pdf", url = "/documents/checklist.pdf" }
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(reminder, "Instructions reminder scheduled", correlationId));
    }
}
