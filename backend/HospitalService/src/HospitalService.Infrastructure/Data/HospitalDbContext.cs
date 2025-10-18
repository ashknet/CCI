using Microsoft.EntityFrameworkCore;
using HospitalService.Core.Entities;

namespace HospitalService.Infrastructure.Data;

public class HospitalDbContext : DbContext
{
    public HospitalDbContext(DbContextOptions<HospitalDbContext> options) : base(options) { }

    // Hospital schema entities
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
    public DbSet<DoctorDisease> DoctorDiseases => Set<DoctorDisease>();
    public DbSet<Appointment> Appointments => Set<Appointment>();
    public DbSet<DoctorAvailability> DoctorAvailabilities => Set<DoctorAvailability>();
    public DbSet<Review> Reviews => Set<Review>();
    
    // Metadata schema entities
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<AccreditationBody> AccreditationBodies => Set<AccreditationBody>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("Hospital");
        base.OnModelCreating(modelBuilder);

        // Configure Metadata schema entities
        modelBuilder.Entity<Country>().ToTable("Countries", "Metadata");
        modelBuilder.Entity<City>(entity =>
        {
            entity.ToTable("Cities", "Metadata");
            entity.Property(e => e.Latitude).HasPrecision(10, 7);
            entity.Property(e => e.Longitude).HasPrecision(10, 7);
        });
        modelBuilder.Entity<AccreditationBody>().ToTable("AccreditationBodies", "Metadata");
        
        // Configure Hospital schema entities
        modelBuilder.Entity<Specialty>().ToTable("Specialties", "Metadata");
        modelBuilder.Entity<Language>().ToTable("Languages", "Metadata");
        modelBuilder.Entity<Disease>().ToTable("Diseases", "Metadata");
        modelBuilder.Entity<DiseaseSpecialty>().ToTable("DiseaseSpecialties", "Metadata");
        modelBuilder.Entity<DoctorDisease>().ToTable("DoctorDiseases", "Hospital");

        modelBuilder.Entity<Hospital>(entity =>
        {
            entity.ToTable("Hospitals", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.CityId);
            entity.HasIndex(e => e.Name);
            entity.Property(e => e.Latitude).HasPrecision(10, 7);
            entity.Property(e => e.Longitude).HasPrecision(10, 7);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
            
            // Foreign key relationships
            entity.HasOne(e => e.City)
                  .WithMany(c => c.Hospitals)
                  .HasForeignKey(e => e.CityId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.Country)
                  .WithMany(c => c.Hospitals)
                  .HasForeignKey(e => e.CountryId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.ToTable("Departments", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.HospitalId);
            entity.HasIndex(e => e.SpecialtyId);
            
            entity.HasOne(e => e.Hospital)
                  .WithMany(h => h.Departments)
                  .HasForeignKey(e => e.HospitalId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.Specialty)
                  .WithMany(s => s.Departments)
                  .HasForeignKey(e => e.SpecialtyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<HospitalAccreditation>(entity =>
        {
            entity.ToTable("HospitalAccreditations", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.HospitalId);
            entity.HasIndex(e => e.AccreditationBodyId);
            
            entity.HasOne(e => e.Hospital)
                  .WithMany(h => h.Accreditations)
                  .HasForeignKey(e => e.HospitalId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.AccreditationBody)
                  .WithMany(ab => ab.HospitalAccreditations)
                  .HasForeignKey(e => e.AccreditationBodyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<Doctor>(entity =>
        {
            entity.ToTable("Doctors", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.HospitalId);
            entity.HasIndex(e => new { e.FirstName, e.LastName });
            entity.Property(e => e.ConsultationFee).HasPrecision(18, 2);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
            entity.HasOne(e => e.Hospital).WithMany(h => h.Doctors).HasForeignKey(e => e.HospitalId);
        });

        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.ToTable("Appointments", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            entity.HasIndex(e => e.PatientId);
            entity.HasIndex(e => new { e.ScheduledDate, e.Status });
            entity.Property(e => e.Fee).HasPrecision(18, 2);
            entity.HasOne(e => e.Doctor).WithMany(d => d.Appointments).HasForeignKey(e => e.DoctorId);
        });

        modelBuilder.Entity<Review>(entity =>
        {
            entity.ToTable("Reviews", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.HospitalId, e.DoctorId });
            entity.HasOne(e => e.Hospital).WithMany(h => h.Reviews).HasForeignKey(e => e.HospitalId).OnDelete(DeleteBehavior.Restrict);
            entity.HasOne(e => e.Doctor).WithMany(d => d.Reviews).HasForeignKey(e => e.DoctorId).OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<DoctorDisease>(entity =>
        {
            entity.ToTable("DoctorDiseases", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            entity.HasIndex(e => e.DiseaseId);
            entity.HasIndex(e => new { e.DoctorId, e.DiseaseId }).IsUnique();
            
            entity.HasOne(e => e.Doctor)
                  .WithMany(d => d.DoctorDiseases)
                  .HasForeignKey(e => e.DoctorId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.Disease)
                  .WithMany(d => d.DoctorDiseases)
                  .HasForeignKey(e => e.DiseaseId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<DoctorAvailability>(entity =>
        {
            entity.ToTable("DoctorAvailability", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            
            entity.HasOne(e => e.Doctor)
                  .WithMany(d => d.Availability)
                  .HasForeignKey(e => e.DoctorId)
                  .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<DoctorLanguage>(entity =>
        {
            entity.ToTable("DoctorLanguages", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            entity.HasIndex(e => e.LanguageId);
            entity.HasIndex(e => new { e.DoctorId, e.LanguageId }).IsUnique();
            
            entity.HasOne(e => e.Doctor)
                  .WithMany(d => d.DoctorLanguages)
                  .HasForeignKey(e => e.DoctorId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.Language)
                  .WithMany(l => l.DoctorLanguages)
                  .HasForeignKey(e => e.LanguageId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<DoctorSpecialty>(entity =>
        {
            entity.ToTable("DoctorSpecialties", "Hospital");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.DoctorId);
            entity.HasIndex(e => e.SpecialtyId);
            entity.HasIndex(e => new { e.DoctorId, e.SpecialtyId }).IsUnique();
            
            entity.HasOne(e => e.Doctor)
                  .WithMany(d => d.DoctorSpecialties)
                  .HasForeignKey(e => e.DoctorId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.Specialty)
                  .WithMany(s => s.DoctorSpecialties)
                  .HasForeignKey(e => e.SpecialtyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

    }
}
