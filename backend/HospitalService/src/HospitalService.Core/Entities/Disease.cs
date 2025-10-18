using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Diseases", Schema = "Metadata")]
public class Disease
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(100)]
    public string? Category { get; set; }
    
    [MaxLength(2000)]
    public string? Description { get; set; }
    
    public string? Symptoms { get; set; }
    
    [MaxLength(20)]
    public string? ICD10Code { get; set; }
    
    public string? TreatmentOptions { get; set; }
    
    [Column(TypeName = "decimal(18,2)")]
    public decimal? AverageTreatmentCost { get; set; }
    
    // Navigation properties
    public virtual ICollection<DoctorDisease> DoctorDiseases { get; set; } = new List<DoctorDisease>();
    public virtual ICollection<DiseaseSpecialty> DiseaseSpecialties { get; set; } = new List<DiseaseSpecialty>();
}
