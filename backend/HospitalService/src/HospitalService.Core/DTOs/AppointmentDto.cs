using System.ComponentModel.DataAnnotations;

namespace HospitalService.Core.DTOs;

public class AppointmentDto
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public Guid PatientId { get; set; }
    public DateTime ScheduledDate { get; set; }
    public TimeSpan ScheduledTime { get; set; }
    public int DurationMinutes { get; set; }
    public AppointmentStatus Status { get; set; }
    public string ReasonForVisit { get; set; } = string.Empty;
    public string? Notes { get; set; }
    public decimal Fee { get; set; }
    public bool IsPaid { get; set; }
    public DateTime? PaidAt { get; set; }
    public string? CancellationReason { get; set; }
    public DateTime? CancelledAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public string ConfirmationNumber { get; set; } = string.Empty;
}

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

public class PagedResult<T>
{
    public List<T> Items { get; set; } = new();
    public int TotalCount { get; set; }
    public int PageNumber { get; set; }
    public int PageSize { get; set; }
    public int TotalPages => (int)Math.Ceiling((double)TotalCount / PageSize);
}
