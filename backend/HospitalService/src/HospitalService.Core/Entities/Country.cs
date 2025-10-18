using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Countries", Schema = "Metadata")]
public class Country
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(3)]
    public string Code { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(50)]
    public string? Region { get; set; }
    
    public bool? IsActive { get; set; } = true;
    
    // Navigation properties
    public virtual ICollection<City> Cities { get; set; } = new List<City>();
    public virtual ICollection<Hospital> Hospitals { get; set; } = new List<Hospital>();
}
