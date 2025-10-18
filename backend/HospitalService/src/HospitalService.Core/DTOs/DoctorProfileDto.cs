using System.ComponentModel.DataAnnotations;

namespace HospitalService.Core.DTOs;

public class DoctorProfileDto
{
    public Guid Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string Qualification { get; set; } = string.Empty;
    public int YearsOfExperience { get; set; }
    public string Biography { get; set; } = string.Empty;
    public string? ProfileImageUrl { get; set; }
    public decimal ConsultationFee { get; set; }
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public bool IsAcceptingPatients { get; set; }
    public HospitalSummaryDto Hospital { get; set; } = new();
    public List<DoctorSpecialtyDto> Specialties { get; set; } = new();
    public List<LanguageDto> Languages { get; set; } = new();
    public List<CredentialDto> Credentials { get; set; } = new();
    public List<ReviewDto> Reviews { get; set; } = new();
}

public class HospitalSummaryDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public int BedCapacity { get; set; }
    public List<SpecialtyDto> Specialties { get; set; } = new();
    public decimal? DistanceFromCityCenter { get; set; }
}

public class SpecialtyDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
}

public class DoctorSpecialtyDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public bool IsPrimary { get; set; }
    public int YearsOfExperience { get; set; }
}

public class LanguageDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
}

public record CredentialDto(
    string Type,
    string Name,
    string IssuingOrganization,
    DateTime IssueDate,
    DateTime? ExpiryDate,
    bool IsVerified
);

public record ReviewDto(
    Guid Id,
    Guid? HospitalId,
    Guid? DoctorId,
    Guid PatientId,
    int Rating,
    string? Title,
    string? Comment,
    DateTime? TreatmentDate,
    bool? IsVerified,
    bool? IsApproved,
    DateTime CreatedAt
);
