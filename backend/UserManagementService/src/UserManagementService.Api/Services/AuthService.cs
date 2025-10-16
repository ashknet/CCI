using BCrypt.Net;
using MedTravel.Shared.Auth.Services;
using MedTravel.Shared.Exceptions;
using UserManagementService.Core.DTOs;
using UserManagementService.Core.Entities;
using UserManagementService.Core.Interfaces;

namespace UserManagementService.Api.Services;

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepository;
    private readonly IRoleRepository _roleRepository;
    private readonly ISessionRepository _sessionRepository;
    private readonly IUserPreferenceRepository _preferenceRepository;
    private readonly IJwtService _jwtService;
    private readonly ILogger<AuthService> _logger;

    public AuthService(
        IUserRepository userRepository,
        IRoleRepository roleRepository,
        ISessionRepository sessionRepository,
        IUserPreferenceRepository preferenceRepository,
        IJwtService jwtService,
        ILogger<AuthService> logger)
    {
        _userRepository = userRepository;
        _roleRepository = roleRepository;
        _sessionRepository = sessionRepository;
        _preferenceRepository = preferenceRepository;
        _jwtService = jwtService;
        _logger = logger;
    }

    public async Task<LoginResponse> RegisterAsync(RegisterUserRequest request)
    {
        // Check if user already exists
        if (await _userRepository.ExistsAsync(request.Email))
        {
            throw new BusinessException("User with this email already exists");
        }

        // Create new user
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = request.Email.ToLower(),
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
            FirstName = request.FirstName,
            LastName = request.LastName,
            Phone = request.Phone,
            DateOfBirth = request.DateOfBirth,
            Gender = request.Gender,
            Nationality = request.Nationality,
            PassportNumber = request.PassportNumber ?? string.Empty,
            Country = request.Country,
            City = request.City,
            Address = request.Address ?? string.Empty,
            PostalCode = request.PostalCode ?? string.Empty,
            IsActive = true,
            EmailVerified = false,
            PhoneVerified = false,
            TwoFactorEnabled = false
        };

        user = await _userRepository.CreateAsync(user);

        // Assign default patient role
        var patientRole = await _roleRepository.GetByNameAsync("patient");
        if (patientRole != null)
        {
            await _userRepository.AddUserRoleAsync(user.Id, patientRole.Id);
        }

        // Create default preferences
        var preferences = new UserPreference
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            PreferredLanguage = "en",
            PreferredCurrency = "USD",
            EmailNotifications = true,
            SmsNotifications = true,
            PushNotifications = true,
            TimeZone = "UTC"
        };
        await _preferenceRepository.CreateAsync(preferences);

        _logger.LogInformation("User {Email} registered successfully", user.Email);

        // Generate tokens and return
        return await GenerateLoginResponse(user);
    }

    public async Task<LoginResponse> LoginAsync(LoginRequest request)
    {
        var user = await _userRepository.GetByEmailAsync(request.Email);
        
        if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedException("Invalid email or password");
        }

        if (!user.IsActive)
        {
            throw new ForbiddenException("User account is deactivated");
        }

        user.LastLoginAt = DateTime.UtcNow;
        await _userRepository.UpdateAsync(user);

        _logger.LogInformation("User {Email} logged in successfully", user.Email);

        return await GenerateLoginResponse(user, request.DeviceInfo);
    }

    public async Task<LoginResponse> RefreshTokenAsync(RefreshTokenRequest request)
    {
        var session = await _sessionRepository.GetByRefreshTokenAsync(request.RefreshToken);
        
        if (session == null)
        {
            throw new UnauthorizedException("Invalid refresh token");
        }

        var user = await _userRepository.GetByIdAsync(session.UserId);
        if (user == null || !user.IsActive)
        {
            throw new UnauthorizedException("User not found or inactive");
        }

        // Revoke old session
        await _sessionRepository.RevokeAsync(session.Id);

        // Generate new tokens
        return await GenerateLoginResponse(user);
    }

    public async Task LogoutAsync(Guid userId, string refreshToken)
    {
        var session = await _sessionRepository.GetByRefreshTokenAsync(refreshToken);
        if (session != null && session.UserId == userId)
        {
            await _sessionRepository.RevokeAsync(session.Id);
        }

        _logger.LogInformation("User {UserId} logged out", userId);
    }

    public async Task<UserDto> GetUserProfileAsync(Guid userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        return MapToUserDto(user);
    }

    public async Task<UserDto> UpdateUserProfileAsync(Guid userId, UpdateUserRequest request)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        if (!string.IsNullOrEmpty(request.FirstName))
            user.FirstName = request.FirstName;
        if (!string.IsNullOrEmpty(request.LastName))
            user.LastName = request.LastName;
        if (!string.IsNullOrEmpty(request.Phone))
            user.Phone = request.Phone;
        if (!string.IsNullOrEmpty(request.Country))
            user.Country = request.Country;
        if (!string.IsNullOrEmpty(request.City))
            user.City = request.City;
        if (!string.IsNullOrEmpty(request.Address))
            user.Address = request.Address;
        if (!string.IsNullOrEmpty(request.PostalCode))
            user.PostalCode = request.PostalCode;
        if (!string.IsNullOrEmpty(request.PassportNumber))
            user.PassportNumber = request.PassportNumber;

        user = await _userRepository.UpdateAsync(user);

        _logger.LogInformation("User {UserId} profile updated", userId);

        return MapToUserDto(user);
    }

    public async Task ChangePasswordAsync(Guid userId, ChangePasswordRequest request)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            throw new NotFoundException("User not found");
        }

        if (!BCrypt.Net.BCrypt.Verify(request.CurrentPassword, user.PasswordHash))
        {
            throw new BusinessException("Current password is incorrect");
        }

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
        await _userRepository.UpdateAsync(user);

        // Revoke all existing sessions
        await _sessionRepository.RevokeAllUserSessionsAsync(userId);

        _logger.LogInformation("User {UserId} password changed", userId);
    }

    private async Task<LoginResponse> GenerateLoginResponse(User user, string? deviceInfo = null)
    {
        var roles = await _userRepository.GetUserRolesAsync(user.Id);
        var primaryRole = roles.FirstOrDefault()?.Name ?? "patient";

        var additionalClaims = new Dictionary<string, string>
        {
            { "Country", user.Country },
            { "City", user.City }
        };

        var accessToken = _jwtService.GenerateToken(user.Id.ToString(), user.Email, primaryRole, additionalClaims);
        var refreshToken = Guid.NewGuid().ToString("N");

        // Create session
        var session = new Session
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            RefreshToken = refreshToken,
            DeviceInfo = deviceInfo ?? "Unknown",
            IpAddress = "0.0.0.0",
            ExpiresAt = DateTime.UtcNow.AddDays(30)
        };
        await _sessionRepository.CreateAsync(session);

        return new LoginResponse(
            accessToken,
            refreshToken,
            DateTime.UtcNow.AddHours(1),
            MapToUserDto(user)
        );
    }

    private UserDto MapToUserDto(User user)
    {
        var roles = user.UserRoles.Select(ur => ur.Role.Name).ToList();

        return new UserDto(
            user.Id,
            user.Email,
            user.FirstName,
            user.LastName,
            user.Phone,
            user.DateOfBirth,
            user.Gender,
            user.Nationality,
            user.Country,
            user.City,
            user.Address,
            user.PostalCode,
            user.PassportNumber,
            user.EmailVerified,
            user.PhoneVerified,
            user.TwoFactorEnabled,
            roles,
            user.CreatedAt,
            user.LastLoginAt
        );
    }
}
