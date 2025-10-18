using MedTravel.Shared.Models;

namespace HospitalService.Core.DTOs;

// Doctor Selection Flow DTOs
public class DoctorSelectionDto
{
    public DoctorProfileDto Doctor { get; set; } = new();
    public AppointmentAvailabilityDto Availability { get; set; } = new();
    public List<ReviewDto> RecentReviews { get; set; } = new();
}

// Hospital Selection Flow DTOs
public class HospitalSelectionDto
{
    public HospitalProfileDto Hospital { get; set; } = new();
    public PagedResult<DoctorSummaryDto> Doctors { get; set; } = new();
    public List<SpecialtyDto> AvailableSpecialties { get; set; } = new();
}

// City Selection Flow DTOs
public class CitySelectionDto
{
    public CityDto City { get; set; } = new();
    public PagedResult<HospitalSummaryDto> Hospitals { get; set; } = new();
    public List<SpecialtyDto> AvailableSpecialties { get; set; } = new();
    public int TotalDoctors { get; set; }
}

// Disease Selection Flow DTOs
public class DiseaseSelectionDto
{
    public DiseaseDto Disease { get; set; } = new();
    public PagedResult<DoctorSummaryDto> Doctors { get; set; } = new();
    public List<SpecialtyDto> RelatedSpecialties { get; set; } = new();
    public List<HospitalSummaryDto> TopHospitals { get; set; } = new();
}

// Enhanced Doctor Summary for Selection Flows
public class DoctorSelectionSummaryDto
{
    public Guid Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Qualification { get; set; } = string.Empty;
    public int YearsOfExperience { get; set; }
    public decimal ConsultationFee { get; set; }
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public bool IsAcceptingPatients { get; set; }
    public string? ProfileImageUrl { get; set; }
    public HospitalSummaryDto Hospital { get; set; } = new();
    public List<SpecialtyDto> Specialties { get; set; } = new();
    public List<LanguageDto> Languages { get; set; } = new();
    public bool HasAvailability { get; set; }
    public DateTime? NextAvailableSlot { get; set; }
}

// Enhanced Hospital Summary for Selection Flows
public class HospitalSelectionSummaryDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public int BedCapacity { get; set; }
    public int DoctorCount { get; set; }
    public List<SpecialtyDto> Specialties { get; set; } = new();
    public List<string> Amenities { get; set; } = new();
    public decimal? DistanceFromCityCenter { get; set; }
    public bool IsAcceptingAppointments { get; set; }
}

// Request DTOs for Selection Flows
public class DoctorSelectionRequest
{
    public Guid DoctorId { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public bool IncludeReviews { get; set; } = true;
    public int ReviewLimit { get; set; } = 5;
}

public class HospitalSelectionRequest
{
    public Guid HospitalId { get; set; }
    public string? Specialty { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public string? SortBy { get; set; } = "rating"; // rating, experience, fee
    public bool IncludeAvailability { get; set; } = true;
}

public class CitySelectionRequest
{
    public Guid CityId { get; set; }
    public string? Specialty { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public string? SortBy { get; set; } = "rating"; // rating, distance, capacity
    public decimal? MaxDistance { get; set; }
}

public class DiseaseSelectionRequest
{
    public Guid DiseaseId { get; set; }
    public Guid? CityId { get; set; }
    public string? Specialty { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 20;
    public string? SortBy { get; set; } = "experience"; // experience, rating, fee
    public bool IncludeAvailability { get; set; } = true;
}

// Response DTOs for API consistency
public class SelectionFlowResponse<T>
{
    public T Data { get; set; } = default!;
    public string Message { get; set; } = string.Empty;
    public bool Success { get; set; } = true;
    public string? CorrelationId { get; set; }
    public List<string> Errors { get; set; } = new();
}
