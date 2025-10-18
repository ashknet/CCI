using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Cities", Schema = "Metadata")]
public class City
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid CountryId { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(100)]
    public string? State { get; set; }
    
    [Column(TypeName = "decimal(10,7)")]
    public decimal? Latitude { get; set; }
    
    [Column(TypeName = "decimal(10,7)")]
    public decimal? Longitude { get; set; }
    
    public bool? IsActive { get; set; } = true;
    
    // Navigation properties
    [ForeignKey(nameof(CountryId))]
    public virtual Country Country { get; set; } = null!;
    
    public virtual ICollection<Hospital> Hospitals { get; set; } = new List<Hospital>();
}
