using Microsoft.EntityFrameworkCore;
using UserService.Models;

namespace UserService.Data;

public class UserDbContext : DbContext
{
    public UserDbContext(DbContextOptions<UserDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<UserRole> UserRoles { get; set; }
    public DbSet<UserAddress> UserAddresses { get; set; }
    public DbSet<UserPreference> UserPreferences { get; set; }
    public DbSet<RefreshToken> RefreshTokens { get; set; }
    public DbSet<AuthenticationLog> AuthenticationLogs { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // User Configuration
        modelBuilder.Entity<User>(entity =>
        {
            entity.ToTable("Users");
            entity.HasKey(e => e.UserId);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.Property(e => e.CreatedAt).HasDefaultValueSql("GETUTCDATE()");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("GETUTCDATE()");
        });

        // Role Configuration
        modelBuilder.Entity<Role>(entity =>
        {
            entity.ToTable("UserRoles");
            entity.HasKey(e => e.RoleId);
            entity.HasIndex(e => e.RoleName).IsUnique();
        });

        // UserRole (Mapping) Configuration
        modelBuilder.Entity<UserRole>(entity =>
        {
            entity.ToTable("UserRoleMapping");
            entity.HasKey(e => e.UserRoleMappingId);
            
            entity.HasOne(e => e.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
            
            entity.HasOne(e => e.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(e => e.RoleId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // UserAddress Configuration
        modelBuilder.Entity<UserAddress>(entity =>
        {
            entity.ToTable("UserAddresses");
            entity.HasKey(e => e.AddressId);
            
            entity.HasOne(e => e.User)
                .WithMany(u => u.Addresses)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // UserPreference Configuration
        modelBuilder.Entity<UserPreference>(entity =>
        {
            entity.ToTable("UserPreferences");
            entity.HasKey(e => e.PreferenceId);
            
            entity.HasOne(e => e.User)
                .WithOne(u => u.Preference)
                .HasForeignKey<UserPreference>(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // RefreshToken Configuration
        modelBuilder.Entity<RefreshToken>(entity =>
        {
            entity.ToTable("RefreshTokens");
            entity.HasKey(e => e.TokenId);
            entity.HasIndex(e => e.Token).IsUnique();
            
            entity.HasOne(e => e.User)
                .WithMany(u => u.RefreshTokens)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // AuthenticationLog Configuration
        modelBuilder.Entity<AuthenticationLog>(entity =>
        {
            entity.ToTable("AuthenticationLogs");
            entity.HasKey(e => e.LogId);
        });

        // Seed default roles
        modelBuilder.Entity<Role>().HasData(
            new Role { RoleId = Guid.Parse("11111111-1111-1111-1111-111111111111"), RoleName = "Patient", Description = "Regular patient user" },
            new Role { RoleId = Guid.Parse("22222222-2222-2222-2222-222222222222"), RoleName = "Doctor", Description = "Medical doctor/provider" },
            new Role { RoleId = Guid.Parse("33333333-3333-3333-3333-333333333333"), RoleName = "HospitalAdmin", Description = "Hospital administrator" },
            new Role { RoleId = Guid.Parse("44444444-4444-4444-4444-444444444444"), RoleName = "SystemAdmin", Description = "System administrator" },
            new Role { RoleId = Guid.Parse("55555555-5555-5555-5555-555555555555"), RoleName = "Guest", Description = "Guest user with limited access" }
        );
    }
}
