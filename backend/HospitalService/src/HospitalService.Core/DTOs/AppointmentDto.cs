using System.ComponentModel.DataAnnotations;

namespace HospitalService.Core.DTOs;

public record AppointmentDto(
    Guid Id,
    Guid DoctorId,
    string DoctorName,
    Guid PatientId,
    DateTime ScheduledDate,
    TimeSpan ScheduledTime,
    int DurationMinutes,
    AppointmentStatus Status,
    string ReasonForVisit,
    decimal Fee,
    bool IsPaid
);

public class CreateAppointmentDto
{
    [Required]
    public DateTime ScheduledDate { get; set; }
    
    [Required]
    public TimeSpan ScheduledTime { get; set; }
    
    [Required]
    [StringLength(500)]
    public string ReasonForVisit { get; set; } = string.Empty;
    
    [StringLength(1000)]
    public string? Notes { get; set; }
    
    [Required]
    public Guid PatientId { get; set; }
}

public class AppointmentAvailabilityDto
{
    public Guid DoctorId { get; set; }
    public List<DateAvailabilityDto> AvailableSlots { get; set; } = new();
    public string TimeZone { get; set; } = string.Empty;
    public Dictionary<string, string> WorkingHours { get; set; } = new();
}

public class DateAvailabilityDto
{
    public DateTime Date { get; set; }
    public List<TimeSlotDto> TimeSlots { get; set; } = new();
}

public class TimeSlotDto
{
    public TimeSpan Time { get; set; }
    public int Duration { get; set; }
    public bool IsAvailable { get; set; }
    public Guid SlotId { get; set; }
}

public enum AppointmentStatus
{
    Scheduled = 1,
    Confirmed = 2,
    Completed = 3,
    Cancelled = 4,
    NoShow = 5
}

