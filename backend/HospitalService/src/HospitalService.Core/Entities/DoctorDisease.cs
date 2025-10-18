using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DoctorDiseases", Schema = "Hospital")]
public class DoctorDisease
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    public Guid DiseaseId { get; set; }
    
    public bool? IsPrimary { get; set; } = false;
    
    public int? YearsOfExperience { get; set; }
    
    [MaxLength(1000)]
    public string? TreatmentNotes { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
    
    [ForeignKey(nameof(DiseaseId))]
    public virtual Disease Disease { get; set; } = null!;
}
