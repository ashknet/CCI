using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HospitalService.Core.DTOs;
using HospitalService.Core.Entities;
using HospitalService.Core.Interfaces;

namespace HospitalService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AppointmentsController : ControllerBase
{
    private readonly IAppointmentRepository _appointmentRepository;
    private readonly IDoctorRepository _doctorRepository;

    public AppointmentsController(IAppointmentRepository appointmentRepository, IDoctorRepository doctorRepository)
    {
        _appointmentRepository = appointmentRepository;
        _doctorRepository = doctorRepository;
    }

    [HttpGet("doctor/{doctorId}/available-slots")]
    public async Task<ActionResult<ApiResponse<IEnumerable<AvailableSlotDto>>>> GetAvailableSlots(
        Guid doctorId, [FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var slots = await _appointmentRepository.GetAvailableSlotsAsync(doctorId, startDate, endDate);
        return Ok(ApiResponse<IEnumerable<AvailableSlotDto>>.SuccessResponse(slots, null, correlationId));
    }

    [HttpPost]
    public async Task<ActionResult<ApiResponse<AppointmentDto>>> BookAppointment([FromBody] BookAppointmentRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var doctor = await _doctorRepository.GetByIdAsync(request.DoctorId);
        if (doctor == null)
            return NotFound(ApiResponse<AppointmentDto>.ErrorResponse("Doctor not found", null, correlationId));

        var isAvailable = await _appointmentRepository.IsSlotAvailableAsync(request.DoctorId, request.ScheduledDate, request.ScheduledTime);
        if (!isAvailable)
            return BadRequest(ApiResponse<AppointmentDto>.ErrorResponse("Slot not available", null, correlationId));

        var appointment = new Appointment
        {
            Id = Guid.NewGuid(),
            DoctorId = request.DoctorId,
            PatientId = userId,
            ScheduledDate = request.ScheduledDate,
            ScheduledTime = request.ScheduledTime,
            DurationMinutes = 30,
            Status = "scheduled",
            ReasonForVisit = request.ReasonForVisit,
            Fee = doctor.ConsultationFee,
            IsPaid = false
        };

        var created = await _appointmentRepository.CreateAsync(appointment);
        var dto = MapToDto(created, doctor);

        return Ok(ApiResponse<AppointmentDto>.SuccessResponse(dto, "Appointment booked successfully", correlationId));
    }

    [HttpGet("my-appointments")]
    public async Task<ActionResult<ApiResponse<PagedResult<AppointmentDto>>>> GetMyAppointments(
        [FromQuery] int pageNumber = 1, [FromQuery] int pageSize = 20)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var appointments = await _appointmentRepository.GetByPatientIdAsync(userId, pageNumber, pageSize);
        var result = new PagedResult<AppointmentDto>
        {
            Items = appointments.Select(a => MapToDto(a, a.Doctor)).ToList(),
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = appointments.Count()
        };

        return Ok(ApiResponse<PagedResult<AppointmentDto>>.SuccessResponse(result, null, correlationId));
    }

    [HttpPatch("{id}/cancel")]
    public async Task<ActionResult<ApiResponse<object>>> CancelAppointment(Guid id, [FromBody] string reason)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var success = await _appointmentRepository.CancelAsync(id, reason);
        
        if (!success)
            return NotFound(ApiResponse<object>.ErrorResponse("Appointment not found", null, correlationId));

        return Ok(ApiResponse<object>.SuccessResponse(null, "Appointment cancelled", correlationId));
    }

    private static AppointmentDto MapToDto(Appointment a, Doctor d) => new(
        a.Id, a.DoctorId, $"Dr. {d.FirstName} {d.LastName}", a.PatientId,
        a.ScheduledDate, a.ScheduledTime, a.DurationMinutes, a.Status,
        a.ReasonForVisit, a.Fee, a.IsPaid
    );
}
