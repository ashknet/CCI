using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DoctorLeaves", Schema = "Hospital")]
public class DoctorLeave
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    public DateTime StartDate { get; set; }
    
    [Required]
    public DateTime EndDate { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string LeaveType { get; set; } = string.Empty; // vacation, sick, personal, etc.
    
    [MaxLength(500)]
    public string? Reason { get; set; }
    
    [MaxLength(20)]
    public string Status { get; set; } = "pending"; // pending, approved, rejected
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
}
