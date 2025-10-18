using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("AppointmentReminders", Schema = "Hospital")]
public class AppointmentReminder
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid AppointmentId { get; set; }
    
    [Required]
    public DateTime ReminderTime { get; set; }
    
    [Required]
    [MaxLength(50)]
    public string ReminderType { get; set; } = string.Empty; // email, sms, push
    
    [MaxLength(1000)]
    public string? Message { get; set; }
    
    [MaxLength(20)]
    public string Status { get; set; } = "pending"; // pending, sent, failed
    
    public DateTime? SentAt { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    [ForeignKey(nameof(AppointmentId))]
    public virtual Appointment Appointment { get; set; } = null!;
}
