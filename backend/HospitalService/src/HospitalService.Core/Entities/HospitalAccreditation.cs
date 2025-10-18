using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("HospitalAccreditations", Schema = "Hospital")]
public class HospitalAccreditation
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid HospitalId { get; set; }
    
    [Required]
    public Guid AccreditationBodyId { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string AccreditationType { get; set; } = string.Empty;
    
    [MaxLength(100)]
    public string? CertificateNumber { get; set; }
    
    public DateTime? IssuedDate { get; set; }
    
    public DateTime? ExpiryDate { get; set; }
    
    [MaxLength(20)]
    public string Status { get; set; } = "active";
    
    [MaxLength(500)]
    public string? DocumentUrl { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(HospitalId))]
    public virtual Hospital Hospital { get; set; } = null!;
    
    [ForeignKey(nameof(AccreditationBodyId))]
    public virtual AccreditationBody AccreditationBody { get; set; } = null!;
}
