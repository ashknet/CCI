using Microsoft.EntityFrameworkCore;
using UserManagementService.Core.Entities;

namespace UserManagementService.Infrastructure.Data;

public class UserManagementDbContext : DbContext
{
    public UserManagementDbContext(DbContextOptions<UserManagementDbContext> options) : base(options) { }

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
    public DbSet<NotificationTemplate> NotificationTemplates => Set<NotificationTemplate>();
    public DbSet<NotificationSchedule> NotificationSchedules => Set<NotificationSchedule>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // User entity configuration
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
            entity.Property(e => e.FirstName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.LastName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Phone).HasMaxLength(20);
            entity.Property(e => e.Country).HasMaxLength(100);
            entity.Property(e => e.City).HasMaxLength(100);
        });

        // Role entity configuration
        modelBuilder.Entity<Role>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Name).IsUnique();
            entity.Property(e => e.Name).IsRequired().HasMaxLength(50);
        });

        // UserRole relationship
        modelBuilder.Entity<UserRole>(entity =>
        {
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
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.Resource, e.Action }).IsUnique();
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Resource).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Action).IsRequired().HasMaxLength(50);
        });

        // RolePermission relationship
        modelBuilder.Entity<RolePermission>(entity =>
        {
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
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId).IsUnique();
            entity.HasOne(e => e.User)
                .WithMany(u => u.UserPreferences)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // UserDocument entity configuration
        modelBuilder.Entity<UserDocument>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasOne(e => e.User)
                .WithMany(u => u.UserDocuments)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // InsurancePolicy entity configuration
        modelBuilder.Entity<InsurancePolicy>(entity =>
        {
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
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.Status, e.ScheduledFor });
        });

        // NotificationTemplate entity configuration
        modelBuilder.Entity<NotificationTemplate>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.Name, e.Language }).IsUnique();
        });

        // NotificationSchedule entity configuration
        modelBuilder.Entity<NotificationSchedule>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.IsSent, e.ScheduledFor });
        });

        // Seed initial data
        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        // Seed Roles
        var patientRoleId = Guid.Parse("00000000-0000-0000-0000-000000000001");
        var doctorRoleId = Guid.Parse("00000000-0000-0000-0000-000000000002");
        var hospitalAdminRoleId = Guid.Parse("00000000-0000-0000-0000-000000000003");
        var supportRoleId = Guid.Parse("00000000-0000-0000-0000-000000000004");

        modelBuilder.Entity<Role>().HasData(
            new Role { Id = patientRoleId, Name = "patient", Description = "Patient user role" },
            new Role { Id = doctorRoleId, Name = "doctor", Description = "Doctor user role" },
            new Role { Id = hospitalAdminRoleId, Name = "hospital_admin", Description = "Hospital administrator role" },
            new Role { Id = supportRoleId, Name = "support", Description = "Support staff role" }
        );

        // Seed Permissions
        var permissions = new List<Permission>
        {
            new() { Id = Guid.NewGuid(), Name = "View Profile", Resource = "profile", Action = "read" },
            new() { Id = Guid.NewGuid(), Name = "Edit Profile", Resource = "profile", Action = "update" },
            new() { Id = Guid.NewGuid(), Name = "Book Appointment", Resource = "appointment", Action = "create" },
            new() { Id = Guid.NewGuid(), Name = "View Appointments", Resource = "appointment", Action = "read" },
            new() { Id = Guid.NewGuid(), Name = "Cancel Appointment", Resource = "appointment", Action = "delete" },
            new() { Id = Guid.NewGuid(), Name = "Send Message", Resource = "message", Action = "create" },
            new() { Id = Guid.NewGuid(), Name = "View Messages", Resource = "message", Action = "read" }
        };

        modelBuilder.Entity<Permission>().HasData(permissions);
    }
}
