using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Languages", Schema = "Metadata")]
public class Language
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(10)]
    public string Code { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(50)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(50)]
    public string? NativeName { get; set; }
    
    public bool? IsActive { get; set; } = true;
    
    // Navigation properties
    public virtual ICollection<DoctorLanguage> DoctorLanguages { get; set; } = new List<DoctorLanguage>();
}
