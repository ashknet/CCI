namespace HospitalService.Core.DTOs;

public record HospitalDto(
    Guid Id,
    string Name,
    string Description,
    string Address,
    string City,
    string State,
    string Country,
    decimal? Latitude,
    decimal? Longitude,
    string Phone,
    string Email,
    string Website,
    int? BedCapacity,
    int? YearEstablished,
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


public record CreateReviewRequest(
    Guid? HospitalId,
    Guid? DoctorId,
    int Rating,
    string? Title,
    string? Comment
);
