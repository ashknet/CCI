using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Departments", Schema = "Hospital")]
public class Department
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    public Guid HospitalId { get; set; }
    
    [Required]
    public Guid SpecialtyId { get; set; }
    
    [MaxLength(200)]
    public string? HeadOfDepartment { get; set; }
    
    [MaxLength(20)]
    public string? Phone { get; set; }
    
    [MaxLength(255)]
    public string? Email { get; set; }
    
    public int? FloorNumber { get; set; }
    
    public int? BedCount { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    [ForeignKey(nameof(HospitalId))]
    public virtual Hospital Hospital { get; set; } = null!;
    
    [ForeignKey(nameof(SpecialtyId))]
    public virtual Specialty Specialty { get; set; } = null!;
}
