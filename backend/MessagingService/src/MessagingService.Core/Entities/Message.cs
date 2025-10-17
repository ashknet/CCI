namespace MessagingService.Core.Entities;

public class Thread
{
    public Guid Id { get; set; }
    public Guid PatientId { get; set; }
    public Guid ProviderId { get; set; }
    public string ProviderType { get; set; } = string.Empty; // doctor, hospital_admin, support
    public string Subject { get; set; } = string.Empty;
    public string Status { get; set; } = "active"; // active, archived, closed
    public Guid? RelatedBookingId { get; set; }
    public Guid? RelatedAppointmentId { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? LastMessageAt { get; set; }
    public ICollection<Message> Messages { get; set; } = new List<Message>();
}

public class Message
{
    public Guid Id { get; set; }
    public Guid ThreadId { get; set; }
    public Guid SenderId { get; set; }
    public string SenderType { get; set; } = string.Empty; // patient, provider
    public string Content { get; set; } = string.Empty;
    public bool IsRead { get; set; }
    public DateTime? ReadAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public Thread Thread { get; set; } = null!;
    public ICollection<MessageAttachment> Attachments { get; set; } = new List<MessageAttachment>();
}

public class MessageAttachment
{
    public Guid Id { get; set; }
    public Guid MessageId { get; set; }
    public string FileName { get; set; } = string.Empty;
    public string FileUrl { get; set; } = string.Empty;
    public string ContentType { get; set; } = string.Empty;
    public long FileSize { get; set; }
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
    public Message Message { get; set; } = null!;
}

public class MessageAudit
{
    public Guid Id { get; set; }
    public Guid MessageId { get; set; }
    public string Action { get; set; } = string.Empty;
    public Guid PerformedBy { get; set; }
    public string Details { get; set; } = string.Empty;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
