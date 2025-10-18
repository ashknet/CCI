using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DiseaseSpecialties", Schema = "Metadata")]
public class DiseaseSpecialty
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DiseaseId { get; set; }
    
    [Required]
    public Guid SpecialtyId { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(DiseaseId))]
    public virtual Disease Disease { get; set; } = null!;
    
    [ForeignKey(nameof(SpecialtyId))]
    public virtual Specialty Specialty { get; set; } = null!;
}
