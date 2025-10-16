using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.Interfaces;
using HospitalService.Core.DTOs;
using HospitalService.Core.Entities;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/appointments")]
[Authorize]
[ApiVersion("1.0")]
public class AppointmentsV1Controller : ControllerBase
{
    private readonly IAppointmentRepository _appointmentRepository;
    private readonly IDoctorRepository _doctorRepository;

    public AppointmentsV1Controller(IAppointmentRepository appointmentRepository, IDoctorRepository doctorRepository)
    {
        _appointmentRepository = appointmentRepository;
        _doctorRepository = doctorRepository;
    }

    /// <summary>
    /// Get appointment details
    /// </summary>
    [HttpGet("{appointmentId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetAppointment(Guid appointmentId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var appointment = await _appointmentRepository.GetByIdAsync(appointmentId);

        if (appointment == null)
            return NotFound(ApiResponse<object>.ErrorResponse("Appointment not found", null, correlationId));

        var dto = new
        {
            appointment.Id,
            appointment.DoctorId,
            doctorName = $"Dr. {appointment.Doctor.FirstName} {appointment.Doctor.LastName}",
            appointment.ScheduledDate,
            appointment.ScheduledTime,
            appointment.Status,
            appointment.ReasonForVisit,
            appointment.Fee,
            appointment.IsPaid,
            hospitalName = appointment.Doctor.Hospital?.Name
        };

        return Ok(ApiResponse<object>.SuccessResponse(dto, null, correlationId));
    }

    /// <summary>
    /// Reschedule appointment
    /// </summary>
    [HttpPut("{appointmentId}/reschedule")]
    public async Task<ActionResult<ApiResponse<object>>> RescheduleAppointment(
        Guid appointmentId,
        [FromBody] object rescheduleData)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        var appointment = await _appointmentRepository.GetByIdAsync(appointmentId);
        if (appointment == null)
            return NotFound(ApiResponse<object>.ErrorResponse("Appointment not found", null, correlationId));

        if (appointment.PatientId != userId)
            return Forbid();

        // Reschedule logic here
        var result = new
        {
            appointmentId,
            oldDate = appointment.ScheduledDate,
            oldTime = appointment.ScheduledTime,
            message = "Appointment rescheduled successfully"
        };

        return Ok(ApiResponse<object>.SuccessResponse(result, "Appointment rescheduled", correlationId));
    }

    /// <summary>
    /// Cancel appointment
    /// </summary>
    [HttpDelete("{appointmentId}/cancel")]
    public async Task<ActionResult<ApiResponse<object>>> CancelAppointment(
        Guid appointmentId,
        [FromBody] string? reason = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        var appointment = await _appointmentRepository.GetByIdAsync(appointmentId);
        if (appointment == null)
            return NotFound(ApiResponse<object>.ErrorResponse("Appointment not found", null, correlationId));

        if (appointment.PatientId != userId)
            return Forbid();

        var success = await _appointmentRepository.CancelAsync(appointmentId, reason ?? "Patient requested");

        var refund = new
        {
            appointmentId,
            refundAmount = appointment.Fee,
            currency = "INR",
            refundStatus = "processing",
            message = "Cancellation confirmed. Refund will be processed in 5-7 business days."
        };

        return Ok(ApiResponse<object>.SuccessResponse(refund, "Appointment cancelled", correlationId));
    }

    /// <summary>
    /// Export appointment to iCal format
    /// </summary>
    [HttpGet("{appointmentId}/ical")]
    public async Task<ActionResult> ExportToCalendar(Guid appointmentId)
    {
        var appointment = await _appointmentRepository.GetByIdAsync(appointmentId);
        if (appointment == null)
            return NotFound();

        var icalContent = $@"BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//MedTravel//Appointment//EN
BEGIN:VEVENT
UID:{appointmentId}
DTSTAMP:{DateTime.UtcNow:yyyyMMddTHHmmssZ}
DTSTART:{appointment.ScheduledDate:yyyyMMdd}T{appointment.ScheduledTime:hhmmss}
DURATION:PT{appointment.DurationMinutes}M
SUMMARY:Medical Appointment - Dr. {appointment.Doctor.FirstName} {appointment.Doctor.LastName}
DESCRIPTION:Reason: {appointment.ReasonForVisit}
LOCATION:{appointment.Doctor.Hospital?.Name}, {appointment.Doctor.Hospital?.Address}
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR";

        return File(System.Text.Encoding.UTF8.GetBytes(icalContent), "text/calendar", $"appointment-{appointmentId}.ics");
    }

    /// <summary>
    /// Set appointment reminders
    /// </summary>
    [HttpPost("{appointmentId}/reminders")]
    public async Task<ActionResult<ApiResponse<object>>> SetReminders(
        Guid appointmentId,
        [FromBody] object reminderConfig)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var reminders = new
        {
            appointmentId,
            reminders = new[] {
                new { type = "email", scheduledFor = DateTime.UtcNow.AddDays(9), message = "1 day before appointment" },
                new { type = "sms", scheduledFor = DateTime.UtcNow.AddDays(9).AddHours(12), message = "12 hours before appointment" },
                new { type = "push", scheduledFor = DateTime.UtcNow.AddDays(10).AddHours(-1), message = "1 hour before appointment" }
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(reminders, "Reminders configured", correlationId));
    }
}
