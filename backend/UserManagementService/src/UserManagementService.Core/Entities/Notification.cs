namespace UserManagementService.Core.Entities;

public class Notification
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string Type { get; set; } = string.Empty; // email, sms, push
    public string Channel { get; set; } = string.Empty; // appointment, transport, instruction, reminder
    public string Subject { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string Status { get; set; } = "pending"; // pending, sent, failed, delivered, read
    public DateTime ScheduledFor { get; set; } = DateTime.UtcNow;
    public DateTime? SentAt { get; set; }
    public DateTime? DeliveredAt { get; set; }
    public DateTime? ReadAt { get; set; }
    public int RetryCount { get; set; }
    public string? ErrorMessage { get; set; }
    public string? ExternalId { get; set; }
    public string? Metadata { get; set; } // JSON for additional data
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public class NotificationTemplate
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty; // email, sms, push
    public string Language { get; set; } = "en";
    public string Subject { get; set; } = string.Empty;
    public string BodyTemplate { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}

public class NotificationSchedule
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string EventType { get; set; } = string.Empty; // appointment_reminder, pre_op_checklist, post_op_followup
    public string ReferenceId { get; set; } = string.Empty; // ID of appointment, booking, etc.
    public string ReferenceType { get; set; } = string.Empty; // appointment, booking, treatment
    public DateTime ScheduledFor { get; set; }
    public bool IsSent { get; set; }
    public DateTime? SentAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
