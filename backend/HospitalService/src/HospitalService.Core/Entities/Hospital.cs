using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Hospitals", Schema = "Hospital")]
public class Hospital
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(255)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(2000)]
    public string? Description { get; set; }
    
    [Required]
    [MaxLength(500)]
    public string Address { get; set; } = string.Empty;
    
    [Required]
    public Guid CityId { get; set; }
    
    [Required]
    public Guid CountryId { get; set; }
    
    [MaxLength(20)]
    public string? PostalCode { get; set; }
    
    [Column(TypeName = "decimal(10,7)")]
    public decimal? Latitude { get; set; }
    
    [Column(TypeName = "decimal(10,7)")]
    public decimal? Longitude { get; set; }
    
    [MaxLength(20)]
    public string? Phone { get; set; }
    
    [MaxLength(255)]
    public string? Email { get; set; }
    
    [MaxLength(500)]
    public string? Website { get; set; }
    
    public int? BedCapacity { get; set; }
    
    public int? YearEstablished { get; set; }
    
    [Column(TypeName = "decimal(3,2)")]
    public decimal AverageRating { get; set; } = 0;
    
    public int TotalReviews { get; set; } = 0;
    
    public bool? IsActive { get; set; } = true;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }

    // Navigation properties
    [ForeignKey(nameof(CityId))]
    public virtual City City { get; set; } = null!;
    
    [ForeignKey(nameof(CountryId))]
    public virtual Country Country { get; set; } = null!;
    
    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();
    public virtual ICollection<Doctor> Doctors { get; set; } = new List<Doctor>();
    public virtual ICollection<HospitalAccreditation> Accreditations { get; set; } = new List<HospitalAccreditation>();
    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();
    
    // Computed properties for backward compatibility
    [NotMapped]
    public ICollection<HospitalAccreditation> HospitalAccreditations => Accreditations;
}