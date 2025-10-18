using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Credentials", Schema = "Hospital")]
public class Credential
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    [MaxLength(50)]
    public string Type { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(200)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(200)]
    public string? IssuingOrganization { get; set; }
    
    public DateTime? IssueDate { get; set; }
    
    public DateTime? ExpiryDate { get; set; }
    
    [MaxLength(100)]
    public string? CredentialNumber { get; set; }
    
    [MaxLength(500)]
    public string? DocumentUrl { get; set; }
    
    public bool? IsVerified { get; set; } = false;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
}
