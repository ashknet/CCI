using System.ComponentModel.DataAnnotations;
using MedTravel.Shared.Models;

namespace HospitalService.Core.DTOs;

public class HospitalProfileDto
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
    public int YearEstablished { get; set; }
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public bool IsActive { get; set; }
    public List<SpecialtyDto> Specialties { get; set; } = new();
    public List<string> Amenities { get; set; } = new();
    public List<ReviewDto> Reviews { get; set; } = new();
}


public class DoctorSummaryDto
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
    public List<SpecialtyDto> Specialties { get; set; } = new();
}

public class CityHospitalsDto
{
    public CityDto City { get; set; } = new();
    public MedTravel.Shared.Models.PagedResult<HospitalSummaryDto> Hospitals { get; set; } = new();
}

public class CityDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
}


public class DiseaseDoctorsDto
{
    public DiseaseDto Disease { get; set; } = new();
    public MedTravel.Shared.Models.PagedResult<DoctorSummaryDto> Doctors { get; set; } = new();
}

public class DiseaseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Symptoms { get; set; } = string.Empty;
    public string TreatmentOptions { get; set; } = string.Empty;
}
