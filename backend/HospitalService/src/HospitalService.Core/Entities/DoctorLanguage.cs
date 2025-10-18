using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DoctorLanguages", Schema = "Hospital")]
public class DoctorLanguage
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    public Guid LanguageId { get; set; }
    
    [MaxLength(20)]
    public string? ProficiencyLevel { get; set; } = "Fluent";
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
    
    [ForeignKey(nameof(LanguageId))]
    public virtual Language Language { get; set; } = null!;
}
