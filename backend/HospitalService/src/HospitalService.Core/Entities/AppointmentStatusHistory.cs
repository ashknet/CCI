using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("AppointmentStatusHistories", Schema = "Hospital")]
public class AppointmentStatusHistory
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid AppointmentId { get; set; }
    
    [Required]
    [MaxLength(20)]
    public string Status { get; set; } = string.Empty;
    
    [MaxLength(500)]
    public string? Notes { get; set; }
    
    public DateTime ChangedAt { get; set; } = DateTime.UtcNow;
    
    public Guid? ChangedBy { get; set; }
    
    // Navigation properties
    [ForeignKey(nameof(AppointmentId))]
    public virtual Appointment Appointment { get; set; } = null!;
}
