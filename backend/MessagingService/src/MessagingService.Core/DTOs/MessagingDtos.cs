namespace MessagingService.Core.DTOs;

public record ThreadDto(
    Guid Id,
    Guid PatientId,
    Guid ProviderId,
    string ProviderType,
    string ProviderName,
    string Subject,
    string Status,
    Guid? RelatedBookingId,
    Guid? RelatedAppointmentId,
    DateTime CreatedAt,
    DateTime? LastMessageAt,
    int UnreadCount
);

public record MessageDto(
    Guid Id,
    Guid ThreadId,
    Guid SenderId,
    string SenderType,
    string SenderName,
    string Content,
    bool IsRead,
    DateTime? ReadAt,
    DateTime CreatedAt,
    List<AttachmentDto> Attachments
);

public record AttachmentDto(
    Guid Id,
    string FileName,
    string FileUrl,
    string ContentType,
    long FileSize,
    DateTime UploadedAt
);

public record CreateThreadRequest(
    Guid ProviderId,
    string ProviderType,
    string Subject,
    Guid? RelatedBookingId = null,
    Guid? RelatedAppointmentId = null
);

public record SendMessageRequest(
    string Content,
    List<string>? AttachmentUrls = null
);
