using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DoctorSpecialties", Schema = "Hospital")]
public class DoctorSpecialty
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    public Guid SpecialtyId { get; set; }
    
    public bool? IsPrimary { get; set; } = false;
    
    public int? YearsOfExperience { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
    
    [ForeignKey(nameof(SpecialtyId))]
    public virtual Specialty Specialty { get; set; } = null!;
}
