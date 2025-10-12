using System.ComponentModel.DataAnnotations;

namespace UserService.Models;

public class User
{
    [Key]
    public Guid UserId { get; set; } = Guid.NewGuid();
    
    [Required]
    [EmailAddress]
    [MaxLength(255)]
    public string Email { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(500)]
    public string PasswordHash { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;
    
    [Required]
    [MaxLength(100)]
    public string LastName { get; set; } = string.Empty;
    
    [MaxLength(20)]
    public string? PhoneNumber { get; set; }
    
    public DateTime? DateOfBirth { get; set; }
    
    [MaxLength(20)]
    public string? Gender { get; set; }
    
    [MaxLength(500)]
    public string? ProfileImageUrl { get; set; }
    
    public bool IsActive { get; set; } = true;
    
    public bool IsEmailVerified { get; set; } = false;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? LastLoginAt { get; set; }
    
    // Navigation properties
    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    public virtual ICollection<UserAddress> Addresses { get; set; } = new List<UserAddress>();
    public virtual UserPreference? Preference { get; set; }
    public virtual ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}

public class UserRole
{
    [Key]
    public Guid UserRoleMappingId { get; set; } = Guid.NewGuid();
    
    [Required]
    public Guid UserId { get; set; }
    
    [Required]
    public Guid RoleId { get; set; }
    
    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    public virtual User User { get; set; } = null!;
    public virtual Role Role { get; set; } = null!;
}

public class Role
{
    [Key]
    public Guid RoleId { get; set; } = Guid.NewGuid();
    
    [Required]
    [MaxLength(50)]
    public string RoleName { get; set; } = string.Empty;
    
    [MaxLength(255)]
    public string? Description { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    public virtual ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
}

public class UserAddress
{
    [Key]
    public Guid AddressId { get; set; } = Guid.NewGuid();
    
    [Required]
    public Guid UserId { get; set; }
    
    [Required]
    [MaxLength(50)]
    public string AddressType { get; set; } = string.Empty;
    
    [MaxLength(255)]
    public string? Street { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string City { get; set; } = string.Empty;
    
    [MaxLength(100)]
    public string? State { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string Country { get; set; } = string.Empty;
    
    [MaxLength(20)]
    public string? PostalCode { get; set; }
    
    public bool IsDefault { get; set; } = false;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation property
    public virtual User User { get; set; } = null!;
}

public class UserPreference
{
    [Key]
    public Guid PreferenceId { get; set; } = Guid.NewGuid();
    
    [Required]
    public Guid UserId { get; set; }
    
    [MaxLength(10)]
    public string LanguageCode { get; set; } = "en";
    
    [MaxLength(10)]
    public string CurrencyCode { get; set; } = "USD";
    
    public bool NotificationEmail { get; set; } = true;
    
    public bool NotificationSMS { get; set; } = true;
    
    public bool NotificationPush { get; set; } = true;
    
    [MaxLength(20)]
    public string ThemePreference { get; set; } = "light";
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation property
    public virtual User User { get; set; } = null!;
}

public class RefreshToken
{
    [Key]
    public Guid TokenId { get; set; } = Guid.NewGuid();
    
    [Required]
    public Guid UserId { get; set; }
    
    [Required]
    [MaxLength(500)]
    public string Token { get; set; } = string.Empty;
    
    public DateTime ExpiresAt { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    
    public DateTime? RevokedAt { get; set; }
    
    public bool IsRevoked { get; set; } = false;
    
    // Navigation property
    public virtual User User { get; set; } = null!;
}

public class AuthenticationLog
{
    [Key]
    public Guid LogId { get; set; } = Guid.NewGuid();
    
    public Guid? UserId { get; set; }
    
    [Required]
    [MaxLength(50)]
    public string ActionType { get; set; } = string.Empty;
    
    [MaxLength(50)]
    public string? IPAddress { get; set; }
    
    [MaxLength(500)]
    public string? UserAgent { get; set; }
    
    public bool IsSuccess { get; set; }
    
    [MaxLength(255)]
    public string? FailureReason { get; set; }
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
