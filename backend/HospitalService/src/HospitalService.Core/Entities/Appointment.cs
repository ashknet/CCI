namespace HospitalService.Core.Entities;

public class Appointment
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public Guid PatientId { get; set; }
    public DateTime ScheduledDate { get; set; }
    public TimeSpan ScheduledTime { get; set; }
    public int DurationMinutes { get; set; } = 30;
    public string Status { get; set; } = "scheduled"; // scheduled, confirmed, cancelled, completed, no_show
    public string ReasonForVisit { get; set; } = string.Empty;
    public string Notes { get; set; } = string.Empty;
    public decimal Fee { get; set; }
    public bool IsPaid { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
    public DateTime? CancelledAt { get; set; }
    public string? CancellationReason { get; set; }

    public Doctor Doctor { get; set; } = null!;
    public ICollection<AppointmentStatusHistory> StatusHistory { get; set; } = new List<AppointmentStatusHistory>();
    public ICollection<AppointmentReminder> Reminders { get; set; } = new List<AppointmentReminder>();
}

public class AppointmentStatusHistory
{
    public Guid Id { get; set; }
    public Guid AppointmentId { get; set; }
    public string FromStatus { get; set; } = string.Empty;
    public string ToStatus { get; set; } = string.Empty;
    public string Reason { get; set; } = string.Empty;
    public DateTime ChangedAt { get; set; } = DateTime.UtcNow;
    public Guid ChangedBy { get; set; }

    public Appointment Appointment { get; set; } = null!;
}

public class DoctorAvailability
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public DayOfWeek DayOfWeek { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int SlotDurationMinutes { get; set; } = 30;
    public bool IsAvailable { get; set; } = true;
    public DateTime? EffectiveFrom { get; set; }
    public DateTime? EffectiveTo { get; set; }

    public Doctor Doctor { get; set; } = null!;
}

public class DoctorLeave
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public string Reason { get; set; } = string.Empty;
    public bool IsApproved { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public class AppointmentReminder
{
    public Guid Id { get; set; }
    public Guid AppointmentId { get; set; }
    public string ReminderType { get; set; } = "email"; // email, sms, push
    public DateTime ScheduledFor { get; set; }
    public bool IsSent { get; set; }
    public DateTime? SentAt { get; set; }

    public Appointment Appointment { get; set; } = null!;
}

public class AppointmentSlot
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public DateTime Date { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public bool IsBooked { get; set; }
    public Guid? AppointmentId { get; set; }
}
