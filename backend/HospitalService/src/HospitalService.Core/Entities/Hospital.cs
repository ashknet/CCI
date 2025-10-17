namespace HospitalService.Core.Entities;

public class Hospital
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public string PostalCode { get; set; } = string.Empty;
    public decimal Latitude { get; set; }
    public decimal Longitude { get; set; }
    public string Phone { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Website { get; set; } = string.Empty;
    public int BedCapacity { get; set; }
    public bool IsActive { get; set; } = true;
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    public ICollection<Department> Departments { get; set; } = new List<Department>();
    public ICollection<Doctor> Doctors { get; set; } = new List<Doctor>();
    public ICollection<HospitalAccreditation> Accreditations { get; set; } = new List<HospitalAccreditation>();
    public ICollection<HospitalImage> Images { get; set; } = new List<HospitalImage>();
    public ICollection<Review> Reviews { get; set; } = new List<Review>();
}

public class Department
{
    public Guid Id { get; set; }
    public Guid HospitalId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string HeadOfDepartment { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public Hospital Hospital { get; set; } = null!;
    public ICollection<Doctor> Doctors { get; set; } = new List<Doctor>();
}

public class Doctor
{
    public Guid Id { get; set; }
    public Guid HospitalId { get; set; }
    public Guid? DepartmentId { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string Qualification { get; set; } = string.Empty;
    public int YearsOfExperience { get; set; }
    public string Biography { get; set; } = string.Empty;
    public string ProfileImageUrl { get; set; } = string.Empty;
    public decimal ConsultationFee { get; set; }
    public bool IsAvailable { get; set; } = true;
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }

    public Hospital Hospital { get; set; } = null!;
    public Department? Department { get; set; }
    public ICollection<DoctorSpecialty> Specialties { get; set; } = new List<DoctorSpecialty>();
    public ICollection<DoctorLanguage> Languages { get; set; } = new List<DoctorLanguage>();
    public ICollection<Credential> Credentials { get; set; } = new List<Credential>();
    public ICollection<DoctorAvailability> Availabilities { get; set; } = new List<DoctorAvailability>();
    public ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
    public ICollection<Review> Reviews { get; set; } = new List<Review>();
}

public class Specialty
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<DoctorSpecialty> DoctorSpecialties { get; set; } = new List<DoctorSpecialty>();
    public ICollection<DiseaseSpecialty> DiseaseSpecialties { get; set; } = new List<DiseaseSpecialty>();
}

public class DoctorSpecialty
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public Guid SpecialtyId { get; set; }
    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;

    public Doctor Doctor { get; set; } = null!;
    public Specialty Specialty { get; set; } = null!;
}

public class Language
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty; // en, hi, te, etc.

    public ICollection<DoctorLanguage> DoctorLanguages { get; set; } = new List<DoctorLanguage>();
}

public class DoctorLanguage
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public Guid LanguageId { get; set; }
    public string Proficiency { get; set; } = "native"; // native, fluent, intermediate

    public Doctor Doctor { get; set; } = null!;
    public Language Language { get; set; } = null!;
}

public class Credential
{
    public Guid Id { get; set; }
    public Guid DoctorId { get; set; }
    public string Type { get; set; } = string.Empty; // degree, certification, license
    public string Name { get; set; } = string.Empty;
    public string IssuingOrganization { get; set; } = string.Empty;
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public string CredentialUrl { get; set; } = string.Empty;
    public bool IsVerified { get; set; }

    public Doctor Doctor { get; set; } = null!;
}

public class HospitalAccreditation
{
    public Guid Id { get; set; }
    public Guid HospitalId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string IssuingBody { get; set; } = string.Empty;
    public DateTime IssueDate { get; set; }
    public DateTime? ExpiryDate { get; set; }
    public string CertificateUrl { get; set; } = string.Empty;

    public Hospital Hospital { get; set; } = null!;
}

public class Disease
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string Symptoms { get; set; } = string.Empty;

    public ICollection<DiseaseSpecialty> DiseaseSpecialties { get; set; } = new List<DiseaseSpecialty>();
}

public class DiseaseSpecialty
{
    public Guid Id { get; set; }
    public Guid DiseaseId { get; set; }
    public Guid SpecialtyId { get; set; }

    public Disease Disease { get; set; } = null!;
    public Specialty Specialty { get; set; } = null!;
}

public class Review
{
    public Guid Id { get; set; }
    public Guid? HospitalId { get; set; }
    public Guid? DoctorId { get; set; }
    public Guid UserId { get; set; }
    public int Rating { get; set; }
    public string Comment { get; set; } = string.Empty;
    public bool IsVerified { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public Hospital? Hospital { get; set; }
    public Doctor? Doctor { get; set; }
}

public class HospitalImage
{
    public Guid Id { get; set; }
    public Guid HospitalId { get; set; }
    public string ImageUrl { get; set; } = string.Empty;
    public string Caption { get; set; } = string.Empty;
    public bool IsPrimary { get; set; }
    public DateTime UploadedAt { get; set; } = DateTime.UtcNow;

    public Hospital Hospital { get; set; } = null!;
}
