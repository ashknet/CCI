using Microsoft.EntityFrameworkCore;
using HospitalService.Core.Entities;

namespace HospitalService.Infrastructure.Data;

public class HospitalDbContext : DbContext
{
    public HospitalDbContext(DbContextOptions<HospitalDbContext> options) : base(options) { }

    public DbSet<Hospital> Hospitals => Set<Hospital>();
    public DbSet<Department> Departments => Set<Department>();
    public DbSet<Doctor> Doctors => Set<Doctor>();
    public DbSet<Specialty> Specialties => Set<Specialty>();
    public DbSet<DoctorSpecialty> DoctorSpecialties => Set<DoctorSpecialty>();
    public DbSet<Language> Languages => Set<Language>();
    public DbSet<DoctorLanguage> DoctorLanguages => Set<DoctorLanguage>();
    public DbSet<Credential> Credentials => Set<Credential>();
    public DbSet<HospitalAccreditation> HospitalAccreditations => Set<HospitalAccreditation>();
    public DbSet<Disease> Diseases => Set<Disease>();
    public DbSet<DiseaseSpecialty> DiseaseSpecialties => Set<DiseaseSpecialty>();
    public DbSet<Appointment> Appointments => Set<Appointment>();
    public DbSet<AppointmentStatusHistory> AppointmentStatusHistories => Set<AppointmentStatusHistory>();
    public DbSet<DoctorAvailability> DoctorAvailabilities => Set<DoctorAvailability>();
    public DbSet<DoctorLeave> DoctorLeaves => Set<DoctorLeave>();
    public DbSet<AppointmentReminder> AppointmentReminders => Set<AppointmentReminder>();
    public DbSet<Review> Reviews => Set<Review>();
    public DbSet<HospitalImage> HospitalImages => Set<HospitalImage>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Hospital>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.City);
            entity.HasIndex(e => e.Name);
            entity.Property(e => e.Latitude).HasPrecision(10, 7);
            entity.Property(e => e.Longitude).HasPrecision(10, 7);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
        });

        modelBuilder.Entity<Doctor>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.HospitalId);
            entity.HasIndex(e => new { e.FirstName, e.LastName });
            entity.Property(e => e.ConsultationFee).HasPrecision(18, 2);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
            entity.HasOne(e => e.Hospital).WithMany(h => h.Doctors).HasForeignKey(e => e.HospitalId);
        });

        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            entity.HasIndex(e => e.PatientId);
            entity.HasIndex(e => new { e.ScheduledDate, e.Status });
            entity.Property(e => e.Fee).HasPrecision(18, 2);
            entity.HasOne(e => e.Doctor).WithMany(d => d.Appointments).HasForeignKey(e => e.DoctorId);
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.HospitalId, e.DoctorId });
            entity.HasOne(e => e.Hospital).WithMany(h => h.Reviews).HasForeignKey(e => e.HospitalId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Doctor).WithMany(d => d.Reviews).HasForeignKey(e => e.DoctorId).OnDelete(DeleteBehavior.Restrict);
        });

        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        var specialtyIds = new Dictionary<string, Guid>
        {
            ["Cardiology"] = Guid.NewGuid(),
            ["Orthopedics"] = Guid.NewGuid(),
            ["Neurology"] = Guid.NewGuid(),
            ["Oncology"] = Guid.NewGuid(),
            ["Gastroenterology"] = Guid.NewGuid()
        };

        foreach (var (name, id) in specialtyIds)
        {
            modelBuilder.Entity<Specialty>().HasData(new Specialty
            {
                Id = id,
                Name = name,
                Description = $"{name} specialty"
            });
        }

        var languageIds = new Dictionary<string, Guid>
        {
            ["English"] = Guid.NewGuid(),
            ["Hindi"] = Guid.NewGuid(),
            ["Telugu"] = Guid.NewGuid(),
            ["Tamil"] = Guid.NewGuid(),
            ["Kannada"] = Guid.NewGuid()
        };

        var languageCodes = new Dictionary<string, string>
        {
            ["English"] = "en",
            ["Hindi"] = "hi",
            ["Telugu"] = "te",
            ["Tamil"] = "ta",
            ["Kannada"] = "kn"
        };

        foreach (var (name, id) in languageIds)
        {
            modelBuilder.Entity<Language>().HasData(new Language
            {
                Id = id,
                Name = name,
                Code = languageCodes[name]
            });
        }

        // Seed hospitals
        var hospitals = new[]
        {
            new Hospital
            {
                Id = Guid.NewGuid(),
                Name = "Apollo Hospitals Hyderabad",
                Description = "Leading multi-specialty hospital",
                Address = "Jubilee Hills",
                City = "Hyderabad",
                State = "Telangana",
                Country = "India",
                PostalCode = "500033",
                Latitude = 17.4239m,
                Longitude = 78.4738m,
                Phone = "+91-40-23607777",
                Email = "info@apollohospitals.com",
                Website = "https://www.apollohospitals.com",
                BedCapacity = 550,
                AverageRating = 4.5m,
                TotalReviews = 1250
            },
            new Hospital
            {
                Id = Guid.NewGuid(),
                Name = "Manipal Hospital Bangalore",
                Description = "Premier healthcare provider",
                Address = "HAL Airport Road",
                City = "Bangalore",
                State = "Karnataka",
                Country = "India",
                PostalCode = "560017",
                Latitude = 12.9577m,
                Longitude = 77.6634m,
                Phone = "+91-80-25023344",
                Email = "info@manipalhospitals.com",
                Website = "https://www.manipalhospitals.com",
                BedCapacity = 650,
                AverageRating = 4.6m,
                TotalReviews = 1580
            },
            new Hospital
            {
                Id = Guid.NewGuid(),
                Name = "Lilavati Hospital Mumbai",
                Description = "Advanced multi-specialty hospital",
                Address = "Bandra West",
                City = "Mumbai",
                State = "Maharashtra",
                Country = "India",
                PostalCode = "400050",
                Latitude = 19.0596m,
                Longitude = 72.8295m,
                Phone = "+91-22-26567891",
                Email = "info@lilavatihospital.com",
                Website = "https://www.lilavatihospital.com",
                BedCapacity = 320,
                AverageRating = 4.4m,
                TotalReviews = 980
            }
        };

        modelBuilder.Entity<Hospital>().HasData(hospitals);
    }
}
