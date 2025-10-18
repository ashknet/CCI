using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Doctors", Schema = "Hospital")]
public class Doctor
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid HospitalId { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(100)]
    public string LastName { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(255)]
    public string Email { get; set; } = string.Empty;
    
    [MaxLength(20)]
    public string? Phone { get; set; }
    
    [MaxLength(200)]
    public string? Qualification { get; set; }
    
    public int? YearsOfExperience { get; set; }
    
    [MaxLength(2000)]
    public string? Biography { get; set; }
    
    [MaxLength(500)]
    public string? ProfileImageUrl { get; set; }
    
    [Column(TypeName = "decimal(18,2)")]
    public decimal? ConsultationFee { get; set; }
    
    [Column(TypeName = "decimal(3,2)")]
    public decimal AverageRating { get; set; } = 0;
    
    public int TotalReviews { get; set; } = 0;
    
    public bool? IsAcceptingPatients { get; set; } = true;
    
    public bool? IsActive { get; set; } = true;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(HospitalId))]
    public virtual Hospital Hospital { get; set; } = null!;
    
    public virtual ICollection<DoctorSpecialty> DoctorSpecialties { get; set; } = new List<DoctorSpecialty>();
    public virtual ICollection<DoctorLanguage> DoctorLanguages { get; set; } = new List<DoctorLanguage>();
    public virtual ICollection<DoctorDisease> DoctorDiseases { get; set; } = new List<DoctorDisease>();
    public virtual ICollection<DoctorAvailability> Availability { get; set; } = new List<DoctorAvailability>();
    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
    public virtual ICollection<Credential> Credentials { get; set; } = new List<Credential>();
    
    // Computed properties for backward compatibility
    [NotMapped]
    public ICollection<Specialty> Specialties => DoctorSpecialties.Select(ds => ds.Specialty).ToList();
    
    [NotMapped]
    public ICollection<Language> Languages => DoctorLanguages.Select(dl => dl.Language).ToList();
}
