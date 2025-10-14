namespace UserManagementService.Core.DTOs;

public record RegisterUserRequest(
    string Email,
    string Password,
    string FirstName,
    string LastName,
    string Phone,
    DateTime DateOfBirth,
    string Gender,
    string Nationality,
    string Country,
    string City,
    string? Address = null,
    string? PostalCode = null,
    string? PassportNumber = null
);

public record LoginRequest(
    string Email,
    string Password,
    string? DeviceInfo = null
);

public record LoginResponse(
    string AccessToken,
    string RefreshToken,
    DateTime ExpiresAt,
    UserDto User
);

public record RefreshTokenRequest(
    string RefreshToken
);

public record UpdateUserRequest(
    string? FirstName,
    string? LastName,
    string? Phone,
    string? Country,
    string? City,
    string? Address,
    string? PostalCode,
    string? PassportNumber
);

public record ChangePasswordRequest(
    string CurrentPassword,
    string NewPassword
);

public record UserDto(
    Guid Id,
    string Email,
    string FirstName,
    string LastName,
    string Phone,
    DateTime DateOfBirth,
    string Gender,
    string Nationality,
    string Country,
    string City,
    string? Address,
    string? PostalCode,
    string? PassportNumber,
    bool EmailVerified,
    bool PhoneVerified,
    bool TwoFactorEnabled,
    List<string> Roles,
    DateTime CreatedAt,
    DateTime? LastLoginAt
);

public record UserPreferenceDto(
    Guid Id,
    string PreferredLanguage,
    string PreferredCurrency,
    bool EmailNotifications,
    bool SmsNotifications,
    bool PushNotifications,
    string TimeZone
);

public record UpdateUserPreferenceRequest(
    string? PreferredLanguage,
    string? PreferredCurrency,
    bool? EmailNotifications,
    bool? SmsNotifications,
    bool? PushNotifications,
    string? TimeZone
);

public record InsurancePolicyDto(
    Guid Id,
    string ProviderName,
    string PolicyNumber,
    string CoverageType,
    decimal CoverageAmount,
    DateTime ValidFrom,
    DateTime ValidTo,
    bool IsActive,
    string? DocumentUrl
);

public record CreateInsurancePolicyRequest(
    string ProviderName,
    string PolicyNumber,
    string CoverageType,
    decimal CoverageAmount,
    DateTime ValidFrom,
    DateTime ValidTo,
    string? DocumentUrl
);

public record NotificationDto(
    Guid Id,
    string Type,
    string Channel,
    string Subject,
    string Message,
    string Status,
    DateTime ScheduledFor,
    DateTime? SentAt,
    DateTime? ReadAt
);

public record CreateNotificationRequest(
    Guid UserId,
    string Type,
    string Channel,
    string Subject,
    string Message,
    DateTime? ScheduledFor = null
);
