using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Reviews", Schema = "Hospital")]
public class Review
{
    [Key]
    public Guid Id { get; set; }
    
    public Guid? HospitalId { get; set; }
    
    public Guid? DoctorId { get; set; }
    
    [Required]
    public Guid PatientId { get; set; }
    
    [Required]
    [Range(1, 5)]
    public int Rating { get; set; }
    
    [MaxLength(200)]
    public string? Title { get; set; }
    
    [MaxLength(2000)]
    public string? Comment { get; set; }
    
    public DateTime? TreatmentDate { get; set; }
    
    public bool? IsVerified { get; set; } = false;
    
    public bool? IsApproved { get; set; } = false;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    [ForeignKey(nameof(HospitalId))]
    public virtual Hospital? Hospital { get; set; }
    
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor? Doctor { get; set; }
}
