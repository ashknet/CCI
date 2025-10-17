using HospitalService.Core.DTOs;

namespace HospitalService.Core.Interfaces;

public interface IAppointmentService
{
    Task<AppointmentDto> CreateAppointmentAsync(Guid doctorId, CreateAppointmentDto request);
    Task<AppointmentAvailabilityDto> GetDoctorAvailabilityAsync(
        Guid doctorId, DateTime startDate, DateTime endDate);
    Task<bool> IsSlotAvailableAsync(Guid doctorId, DateTime scheduledDate, TimeSpan scheduledTime);
    Task<PagedResult<AppointmentDto>> GetPatientAppointmentsAsync(
        Guid patientId, int page = 1, int pageSize = 20);
    Task<AppointmentDto?> GetAppointmentByIdAsync(Guid appointmentId);
    Task<bool> CancelAppointmentAsync(Guid appointmentId, string reason);
}
