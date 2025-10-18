using Microsoft.EntityFrameworkCore;
using UserManagementService.Core.Entities;

namespace UserManagementService.Infrastructure.Data;

public class UserManagementDbContext : DbContext
{
    public UserManagementDbContext(DbContextOptions<UserManagementDbContext> options) : base(options) { }

    // UserManagement schema entities
    public DbSet<User> Users => Set<User>();
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<Permission> Permissions => Set<Permission>();
    public DbSet<RolePermission> RolePermissions => Set<RolePermission>();
    public DbSet<Session> Sessions => Set<Session>();
    public DbSet<UserPreference> UserPreferences => Set<UserPreference>();
    public DbSet<UserDocument> UserDocuments => Set<UserDocument>();
    public DbSet<InsurancePolicy> InsurancePolicies => Set<InsurancePolicy>();
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();
    public DbSet<Notification> Notifications => Set<Notification>();
    
    // Metadata schema entities
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<Language> Languages => Set<Language>();
    public DbSet<Currency> Currencies => Set<Currency>();
    public DbSet<DocumentType> DocumentTypes => Set<DocumentType>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("UserManagement");
        base.OnModelCreating(modelBuilder);

        // Configure Metadata schema entities
        modelBuilder.Entity<Country>().ToTable("Countries", "Metadata");
        modelBuilder.Entity<City>().ToTable("Cities", "Metadata");
        modelBuilder.Entity<Language>().ToTable("Languages", "Metadata");
        modelBuilder.Entity<Currency>().ToTable("Currencies", "Metadata");
        modelBuilder.Entity<DocumentType>().ToTable("DocumentTypes", "Metadata");

        // User entity configuration
        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
            entity.Property(e => e.FirstName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.LastName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Phone).HasMaxLength(20);
            
            // Foreign key relationships
            entity.HasOne(e => e.Country)
                  .WithMany(c => c.Users)
                  .HasForeignKey(e => e.CountryId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.City)
                  .WithMany(c => c.Users)
                  .HasForeignKey(e => e.CityId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // Role entity configuration
        modelBuilder.Entity<Role>(entity =>
        {
            entity.ToTable("Roles", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Name).IsUnique();
            entity.Property(e => e.Name).IsRequired().HasMaxLength(50);
        });

        // UserRole relationship
        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.ToTable("UserRoles", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(e => e.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(e => e.RoleId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasIndex(e => new { e.UserId, e.RoleId }).IsUnique();
        });

        // Permission entity configuration
        modelBuilder.Entity<Permission>(entity =>
        {
            entity.ToTable("Permissions", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.Resource, e.Action }).IsUnique();
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Resource).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Action).IsRequired().HasMaxLength(50);
        });

        // RolePermission relationship
        modelBuilder.Entity<RolePermission>(entity =>
        {
            entity.ToTable("RolePermissions", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasOne(e => e.Role)
                .WithMany(r => r.RolePermissions)
                .HasForeignKey(e => e.RoleId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasOne(e => e.Permission)
                .WithMany(p => p.RolePermissions)
                .HasForeignKey(e => e.PermissionId)
                .OnDelete(DeleteBehavior.Cascade);
            entity.HasIndex(e => new { e.RoleId, e.PermissionId }).IsUnique();
        });

        // Session entity configuration
        modelBuilder.Entity<Session>(entity =>
        {
            entity.ToTable("Sessions", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.RefreshToken).IsUnique();
            entity.HasIndex(e => e.UserId);
            entity.HasOne(e => e.User)
                .WithMany(u => u.Sessions)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // UserPreference entity configuration
        modelBuilder.Entity<UserPreference>(entity =>
        {
            entity.ToTable("UserPreferences", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId).IsUnique();
            entity.HasOne(e => e.User)
                .WithOne(u => u.UserPreference)
                .HasForeignKey<UserPreference>(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
                
            entity.HasOne(e => e.Language)
                  .WithMany()
                  .HasForeignKey(e => e.LanguageId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.Currency)
                  .WithMany()
                  .HasForeignKey(e => e.CurrencyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // UserDocument entity configuration
        modelBuilder.Entity<UserDocument>(entity =>
        {
            entity.ToTable("UserDocuments", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasOne(e => e.User)
                .WithMany(u => u.UserDocuments)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
                
            entity.HasOne(e => e.DocumentType)
                  .WithMany()
                  .HasForeignKey(e => e.DocumentTypeId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        // InsurancePolicy entity configuration
        modelBuilder.Entity<InsurancePolicy>(entity =>
        {
            entity.ToTable("InsurancePolicies", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.Property(e => e.CoverageAmount).HasPrecision(18, 2);
            entity.HasOne(e => e.User)
                .WithMany(u => u.InsurancePolicies)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // AuditLog entity configuration
        modelBuilder.Entity<AuditLog>(entity =>
        {
            entity.ToTable("AuditLogs", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.Resource, e.ResourceId });
            entity.HasIndex(e => e.Timestamp);
            entity.HasOne(e => e.User)
                .WithMany(u => u.AuditLogs)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.SetNull);
        });

        // Notification entity configuration
        modelBuilder.Entity<Notification>(entity =>
        {
            entity.ToTable("Notifications", "UserManagement");
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.Status, e.ScheduledFor });
        });
    }
}
