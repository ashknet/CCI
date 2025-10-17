using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using HospitalService.Core.DTOs;
using HospitalService.Core.Interfaces;
using HospitalService.Core.Models;

namespace HospitalService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/doctors")]
[ApiVersion("1.0")]
[Authorize]
public class DoctorsController : ControllerBase
{
    private readonly IDoctorService _doctorService;
    private readonly IAppointmentService _appointmentService;
    private readonly ILogger<DoctorsController> _logger;

    public DoctorsController(
        IDoctorService doctorService,
        IAppointmentService appointmentService,
        ILogger<DoctorsController> logger)
    {
        _doctorService = doctorService;
        _appointmentService = appointmentService;
        _logger = logger;
    }

    /// <summary>
    /// Get detailed doctor profile with reviews, credentials, and specialties
    /// </summary>
    [HttpGet("{doctorId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<DoctorProfileDto>>> GetDoctorProfile(Guid doctorId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            var doctor = await _doctorService.GetDoctorProfileAsync(doctorId);
            if (doctor == null)
            {
                return NotFound(ApiResponse<DoctorProfileDto>.ErrorResponse(
                    "DOCTOR_NOT_FOUND", 
                    $"Doctor with ID {doctorId} not found", 
                    correlationId));
            }

            return Ok(ApiResponse<DoctorProfileDto>.SuccessResponse(
                doctor, 
                "Doctor profile retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctor profile for ID {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<DoctorProfileDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving doctor profile", 
                correlationId));
        }
    }

    /// <summary>
    /// Get doctor's available appointment slots for a date range
    /// </summary>
    [HttpGet("{doctorId}/availability")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<AppointmentAvailabilityDto>>> GetDoctorAvailability(
        Guid doctorId,
        [FromQuery] DateTime? startDate = null,
        [FromQuery] DateTime? endDate = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            // Default to next 30 days if no dates provided
            startDate ??= DateTime.Today;
            endDate ??= DateTime.Today.AddDays(30);

            if (startDate > endDate)
            {
                return BadRequest(ApiResponse<AppointmentAvailabilityDto>.ErrorResponse(
                    "INVALID_DATE_RANGE", 
                    "Start date cannot be after end date", 
                    correlationId));
            }

            var availability = await _appointmentService.GetDoctorAvailabilityAsync(
                doctorId, startDate.Value, endDate.Value);

            return Ok(ApiResponse<AppointmentAvailabilityDto>.SuccessResponse(
                availability, 
                "Doctor availability retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctor availability for ID {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<AppointmentAvailabilityDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving doctor availability", 
                correlationId));
        }
    }

    /// <summary>
    /// Book an appointment with a doctor
    /// </summary>
    [HttpPost("{doctorId}/appointments")]
    public async Task<ActionResult<ApiResponse<AppointmentDto>>> BookAppointment(
        Guid doctorId,
        [FromBody] CreateAppointmentDto request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ApiResponse<AppointmentDto>.ErrorResponse(
                    "VALIDATION_ERROR", 
                    "Invalid request data", 
                    correlationId));
            }

            // Verify doctor exists and is accepting patients
            var doctor = await _doctorService.GetDoctorByIdAsync(doctorId);
            if (doctor == null)
            {
                return NotFound(ApiResponse<AppointmentDto>.ErrorResponse(
                    "DOCTOR_NOT_FOUND", 
                    $"Doctor with ID {doctorId} not found", 
                    correlationId));
            }

            if (!doctor.IsAcceptingPatients)
            {
                return BadRequest(ApiResponse<AppointmentDto>.ErrorResponse(
                    "DOCTOR_NOT_ACCEPTING", 
                    "Doctor is not currently accepting new patients", 
                    correlationId));
            }

            // Check if slot is available
            var isAvailable = await _appointmentService.IsSlotAvailableAsync(
                doctorId, request.ScheduledDate, request.ScheduledTime);
            
            if (!isAvailable)
            {
                return BadRequest(ApiResponse<AppointmentDto>.ErrorResponse(
                    "SLOT_NOT_AVAILABLE", 
                    "The selected time slot is no longer available", 
                    correlationId));
            }

            var appointment = await _appointmentService.CreateAppointmentAsync(
                doctorId, request);

            return CreatedAtAction(
                nameof(GetDoctorProfile), 
                new { doctorId }, 
                ApiResponse<AppointmentDto>.SuccessResponse(
                    appointment, 
                    "Appointment booked successfully", 
                    correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error booking appointment for doctor ID {DoctorId}", doctorId);
            return StatusCode(500, ApiResponse<AppointmentDto>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while booking appointment", 
                correlationId));
        }
    }

    /// <summary>
    /// Get doctors by hospital
    /// </summary>
    [HttpGet("hospital/{hospitalId}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DoctorSummaryDto>>>> GetDoctorsByHospital(
        Guid hospitalId,
        [FromQuery] string? specialty = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var doctors = await _doctorService.GetDoctorsByHospitalAsync(
                hospitalId, specialty, page, pageSize);

            return Ok(ApiResponse<PagedResult<DoctorSummaryDto>>.SuccessResponse(
                doctors, 
                "Doctors retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctors for hospital ID {HospitalId}", hospitalId);
            return StatusCode(500, ApiResponse<PagedResult<DoctorSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving doctors", 
                correlationId));
        }
    }

    /// <summary>
    /// Get doctors by specialty
    /// </summary>
    [HttpGet("specialty/{specialty}")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<PagedResult<DoctorSummaryDto>>>> GetDoctorsBySpecialty(
        string specialty,
        [FromQuery] string? city = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        try
        {
            if (page < 1) page = 1;
            if (pageSize < 1 || pageSize > 100) pageSize = 20;

            var doctors = await _doctorService.GetDoctorsBySpecialtyAsync(
                specialty, city, page, pageSize);

            return Ok(ApiResponse<PagedResult<DoctorSummaryDto>>.SuccessResponse(
                doctors, 
                "Doctors retrieved successfully", 
                correlationId));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving doctors for specialty {Specialty}", specialty);
            return StatusCode(500, ApiResponse<PagedResult<DoctorSummaryDto>>.ErrorResponse(
                "INTERNAL_ERROR", 
                "An error occurred while retrieving doctors", 
                correlationId));
        }
    }
}
