using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("DoctorAvailability", Schema = "Hospital")]
public class DoctorAvailability
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid DoctorId { get; set; }
    
    [Required]
    [Range(0, 6)] // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
    public int DayOfWeek { get; set; }
    
    [Required]
    public TimeSpan StartTime { get; set; }
    
    [Required]
    public TimeSpan EndTime { get; set; }
    
    public int? SlotDurationMinutes { get; set; } = 30;
    
    public bool? IsActive { get; set; } = true;
    
    // Computed properties for backward compatibility
    [NotMapped]
    public bool IsAvailable => IsActive ?? true;
    
    // Navigation properties
    [ForeignKey(nameof(DoctorId))]
    public virtual Doctor Doctor { get; set; } = null!;
}
