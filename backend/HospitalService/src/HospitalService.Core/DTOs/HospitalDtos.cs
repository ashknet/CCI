namespace HospitalService.Core.DTOs;

public record HospitalDto(
    Guid Id,
    string Name,
    string Description,
    string Address,
    string City,
    string State,
    string Country,
    decimal Latitude,
    decimal Longitude,
    string Phone,
    string Email,
    string Website,
    int BedCapacity,
    decimal AverageRating,
    int TotalReviews,
    List<string> Specialties,
    List<string> Accreditations
);

public record DoctorDto(
    Guid Id,
    Guid HospitalId,
    string HospitalName,
    string FirstName,
    string LastName,
    string Email,
    string Phone,
    string Qualification,
    int YearsOfExperience,
    string Biography,
    string ProfileImageUrl,
    decimal ConsultationFee,
    decimal AverageRating,
    int TotalReviews,
    List<string> Specialties,
    List<string> Languages,
    List<CredentialDto> Credentials
);

public record CredentialDto(
    string Type,
    string Name,
    string IssuingOrganization,
    DateTime IssueDate,
    DateTime? ExpiryDate,
    bool IsVerified
);

public record SearchRequest(
    string Query,
    string? Category = null, // hospital, doctor, specialty, disease, location
    string? City = null,
    decimal? Latitude = null,
    decimal? Longitude = null,
    int? MaxDistance = null,
    int PageNumber = 1,
    int PageSize = 20,
    string? SortBy = "relevance" // relevance, rating, distance, price
);

public record SearchSuggestion(
    string Text,
    string Category,
    Guid? Id = null
);

public record AppointmentDto(
    Guid Id,
    Guid DoctorId,
    string DoctorName,
    Guid PatientId,
    DateTime ScheduledDate,
    TimeSpan ScheduledTime,
    int DurationMinutes,
    string Status,
    string ReasonForVisit,
    decimal Fee,
    bool IsPaid
);

public record BookAppointmentRequest(
    Guid DoctorId,
    DateTime ScheduledDate,
    TimeSpan ScheduledTime,
    string ReasonForVisit
);

public record AvailableSlotDto(
    DateTime Date,
    TimeSpan StartTime,
    TimeSpan EndTime,
    bool IsAvailable
);

public record ReviewDto(
    Guid Id,
    string EntityType,
    Guid EntityId,
    Guid UserId,
    int Rating,
    string Comment,
    bool IsVerified,
    DateTime CreatedAt
);

public record CreateReviewRequest(
    string EntityType, // hospital or doctor
    Guid EntityId,
    int Rating,
    string Comment
);
