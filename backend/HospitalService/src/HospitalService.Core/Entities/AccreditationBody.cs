using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("AccreditationBodies", Schema = "Metadata")]
public class AccreditationBody
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(20)]
    public string? Acronym { get; set; }
    
    [MaxLength(1000)]
    public string? Description { get; set; }
    
    [MaxLength(500)]
    public string? Website { get; set; }
    
    public bool? IsActive { get; set; } = true;
    
    // Navigation properties
    public virtual ICollection<HospitalAccreditation> HospitalAccreditations { get; set; } = new List<HospitalAccreditation>();
}
