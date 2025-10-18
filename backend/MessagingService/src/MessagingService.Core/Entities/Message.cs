namespace MessagingService.Core.Entities;

public class Thread
{
    public Guid Id { get; set; }
    public string? Subject { get; set; }
    public string ParticipantIds { get; set; } = string.Empty; // JSON array of participant IDs
    public string ThreadType { get; set; } = "patient_doctor";
    public bool IsActive { get; set; } = true;
    public bool IsArchived { get; set; }
    public DateTime? LastMessageAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public Guid CreatedBy { get; set; }
    
    public ICollection<Message> Messages { get; set; } = new List<Message>();
}

public class Message
{
    public Guid Id { get; set; }
    public Guid ThreadId { get; set; }
    public Guid SenderId { get; set; }
    public string Content { get; set; } = string.Empty;
    public string MessageType { get; set; } = "text";
    public bool IsEncrypted { get; set; } = true;
    public bool IsDelivered { get; set; }
    public bool IsRead { get; set; }
    public DateTime? DeliveredAt { get; set; }
    public DateTime? ReadAt { get; set; }
    public string? ReadBy { get; set; } // JSON array of user IDs who read the message
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
    public long? FileSize { get; set; }
    public string? MimeType { get; set; }
    public bool IsEncrypted { get; set; } = true;
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;
    
    public Message Message { get; set; } = null!;
}

