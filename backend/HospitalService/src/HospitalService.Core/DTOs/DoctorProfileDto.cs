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

public class CredentialDto
{
    public string Type { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string IssuingOrganization { get; set; } = string.Empty;
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public bool IsVerified { get; set; }
}

public class ReviewDto
{
    public Guid Id { get; set; }
    public int Rating { get; set; }
    public string Comment { get; set; } = string.Empty;
    public string PatientName { get; set; } = string.Empty;
    public DateTime? TreatmentDate { get; set; }
    public DateTime CreatedAt { get; set; }
}
