using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HospitalService.Core.Entities;

[Table("Specialties", Schema = "Metadata")]
public class Specialty
{
    [Key]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string Name { get; set; } = string.Empty;
    
    [MaxLength(1000)]
    public string? Description { get; set; }
    
    [MaxLength(500)]
    public string? IconUrl { get; set; }
    
    [MaxLength(50)]
    public string? Category { get; set; }
    
    public int? SortOrder { get; set; } = 0;
    
    // Navigation properties
    public virtual ICollection<DoctorSpecialty> DoctorSpecialties { get; set; } = new List<DoctorSpecialty>();
    public virtual ICollection<DiseaseSpecialty> DiseaseSpecialties { get; set; } = new List<DiseaseSpecialty>();
    public virtual ICollection<Department> Departments { get; set; } = new List<Department>();
}
