using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Appointments", Schema = "Hospital")]
public class Appointment
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    public Guid PatientId { get; set; }
    
    [Required]
    public DateTime ScheduledDate { get; set; }
    
    [Required]
    public TimeSpan ScheduledTime { get; set; }
    
    public int DurationMinutes { get; set; } = 30;
    
    [Required]
    [MaxLength(20)]
    public string Status { get; set; } = "scheduled"; // scheduled, confirmed, cancelled, completed, no_show
    
    [MaxLength(500)]
    public string? ReasonForVisit { get; set; }
    
    [MaxLength(2000)]
    public string? Notes { get; set; }
    
    [Column(TypeName = "decimal(18,2)")]
    public decimal? Fee { get; set; }
    
    public bool IsPaid { get; set; } = false;
    
    public DateTime? PaidAt { get; set; }
    
    [MaxLength(500)]
    public string? CancellationReason { get; set; }
    
    public DateTime? CancelledAt { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? UpdatedAt { get; set; }

    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
}