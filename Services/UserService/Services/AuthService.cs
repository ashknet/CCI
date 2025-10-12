using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using UserService.Data;
using UserService.DTOs;
using UserService.Models;

namespace UserService.Services;

public class AuthService : IAuthService
{
    private readonly UserDbContext _context;
    private readonly ITokenService _tokenService;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly ILogger<AuthService> _logger;

    public AuthService(
        UserDbContext context,
        ITokenService tokenService,
        ILogger<AuthService> logger)
    {
        _context = context;
        _tokenService = tokenService;
        _passwordHasher = new PasswordHasher<User>();
        _logger = logger;
    }

    public async Task<ApiResponse<LoginResponse>> RegisterAsync(RegisterRequest request)
    {
        try
        {
            // Check if user already exists
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                return new ApiResponse<LoginResponse>
                {
                    Success = false,
                    Message = "User with this email already exists"
                };
            }

            var user = new User
            {
                Email = request.Email,
                FirstName = request.FirstName,
                LastName = request.LastName,
                PhoneNumber = request.PhoneNumber,
                DateOfBirth = request.DateOfBirth,
                Gender = request.Gender
            };

            user.PasswordHash = _passwordHasher.HashPassword(user, request.Password);

            await _context.Users.AddAsync(user);
            
            // Assign default "Patient" role
            var patientRole = await _context.Roles.FirstOrDefaultAsync(r => r.RoleName == "Patient");
            if (patientRole != null)
            {
                await _context.UserRoles.AddAsync(new UserRole
                {
                    UserId = user.UserId,
                    RoleId = patientRole.RoleId
                });
            }

            // Create default preferences
            await _context.UserPreferences.AddAsync(new UserPreference
            {
                UserId = user.UserId
            });

            await _context.SaveChangesAsync();

            // Log authentication
            await LogAuthenticationAsync(user.UserId, "Register", true);

            // Generate tokens
            var accessToken = _tokenService.GenerateAccessToken(user, new List<string> { "Patient" });
            var refreshToken = await _tokenService.GenerateRefreshTokenAsync(user.UserId);

            var response = new LoginResponse
            {
                AccessToken = accessToken.Token,
                RefreshToken = refreshToken,
                ExpiresAt = accessToken.ExpiresAt,
                User = await GetUserDTOAsync(user.UserId)
            };

            _logger.LogInformation("User {Email} registered successfully", request.Email);

            return new ApiResponse<LoginResponse>
            {
                Success = true,
                Message = "Registration successful",
                Data = response
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during user registration");
            return new ApiResponse<LoginResponse>
            {
                Success = false,
                Message = "Registration failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<LoginResponse>> LoginAsync(LoginRequest request)
    {
        try
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                    .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null)
            {
                await LogAuthenticationAsync(null, "Login", false, "User not found");
                return new ApiResponse<LoginResponse>
                {
                    Success = false,
                    Message = "Invalid email or password"
                };
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.Password);
            
            if (result == PasswordVerificationResult.Failed)
            {
                await LogAuthenticationAsync(user.UserId, "Login", false, "Invalid password");
                return new ApiResponse<LoginResponse>
                {
                    Success = false,
                    Message = "Invalid email or password"
                };
            }

            if (!user.IsActive)
            {
                await LogAuthenticationAsync(user.UserId, "Login", false, "Account inactive");
                return new ApiResponse<LoginResponse>
                {
                    Success = false,
                    Message = "Account is inactive"
                };
            }

            // Update last login
            user.LastLoginAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            await LogAuthenticationAsync(user.UserId, "Login", true);

            var roles = user.UserRoles.Select(ur => ur.Role.RoleName).ToList();
            var accessToken = _tokenService.GenerateAccessToken(user, roles);
            var refreshToken = await _tokenService.GenerateRefreshTokenAsync(user.UserId);

            var response = new LoginResponse
            {
                AccessToken = accessToken.Token,
                RefreshToken = refreshToken,
                ExpiresAt = accessToken.ExpiresAt,
                User = await GetUserDTOAsync(user.UserId)
            };

            _logger.LogInformation("User {Email} logged in successfully", request.Email);

            return new ApiResponse<LoginResponse>
            {
                Success = true,
                Message = "Login successful",
                Data = response
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during login");
            return new ApiResponse<LoginResponse>
            {
                Success = false,
                Message = "Login failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<LoginResponse>> RefreshTokenAsync(string refreshToken)
    {
        try
        {
            var token = await _context.RefreshTokens
                .Include(rt => rt.User)
                    .ThenInclude(u => u.UserRoles)
                        .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(rt => rt.Token == refreshToken && !rt.IsRevoked);

            if (token == null || token.ExpiresAt < DateTime.UtcNow)
            {
                return new ApiResponse<LoginResponse>
                {
                    Success = false,
                    Message = "Invalid or expired refresh token"
                };
            }

            var roles = token.User.UserRoles.Select(ur => ur.Role.RoleName).ToList();
            var accessToken = _tokenService.GenerateAccessToken(token.User, roles);
            var newRefreshToken = await _tokenService.GenerateRefreshTokenAsync(token.UserId);

            // Revoke old refresh token
            token.IsRevoked = true;
            token.RevokedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            var response = new LoginResponse
            {
                AccessToken = accessToken.Token,
                RefreshToken = newRefreshToken,
                ExpiresAt = accessToken.ExpiresAt,
                User = await GetUserDTOAsync(token.UserId)
            };

            return new ApiResponse<LoginResponse>
            {
                Success = true,
                Message = "Token refreshed successfully",
                Data = response
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error refreshing token");
            return new ApiResponse<LoginResponse>
            {
                Success = false,
                Message = "Token refresh failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> LogoutAsync(Guid userId)
    {
        try
        {
            var tokens = await _context.RefreshTokens
                .Where(rt => rt.UserId == userId && !rt.IsRevoked)
                .ToListAsync();

            foreach (var token in tokens)
            {
                token.IsRevoked = true;
                token.RevokedAt = DateTime.UtcNow;
            }

            await _context.SaveChangesAsync();
            await LogAuthenticationAsync(userId, "Logout", true);

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "Logout successful",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during logout");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Logout failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> ChangePasswordAsync(Guid userId, ChangePasswordRequest request)
    {
        try
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return new ApiResponse<bool>
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.CurrentPassword);
            if (result == PasswordVerificationResult.Failed)
            {
                return new ApiResponse<bool>
                {
                    Success = false,
                    Message = "Current password is incorrect"
                };
            }

            user.PasswordHash = _passwordHasher.HashPassword(user, request.NewPassword);
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            await LogAuthenticationAsync(userId, "PasswordChange", true);

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "Password changed successfully",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error changing password");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Password change failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> ForgotPasswordAsync(ForgotPasswordRequest request)
    {
        try
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);
            if (user == null)
            {
                // Don't reveal if user exists
                return new ApiResponse<bool>
                {
                    Success = true,
                    Message = "If the email exists, a password reset link has been sent",
                    Data = true
                };
            }

            // TODO: Generate password reset token and send email
            // This would typically integrate with the notification service

            _logger.LogInformation("Password reset requested for {Email}", request.Email);

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "If the email exists, a password reset link has been sent",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing forgot password request");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Failed to process request",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> ResetPasswordAsync(ResetPasswordRequest request)
    {
        try
        {
            // TODO: Implement password reset with token validation
            // This would verify the reset token and update the password

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "Password reset successful",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error resetting password");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Password reset failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> VerifyEmailAsync(string token)
    {
        try
        {
            // TODO: Implement email verification
            return new ApiResponse<bool>
            {
                Success = true,
                Message = "Email verified successfully",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error verifying email");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Email verification failed",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    private async Task<UserDTO> GetUserDTOAsync(Guid userId)
    {
        var user = await _context.Users
            .Include(u => u.UserRoles)
                .ThenInclude(ur => ur.Role)
            .FirstOrDefaultAsync(u => u.UserId == userId);

        if (user == null)
            throw new Exception("User not found");

        return new UserDTO
        {
            UserId = user.UserId,
            Email = user.Email,
            FirstName = user.FirstName,
            LastName = user.LastName,
            PhoneNumber = user.PhoneNumber,
            DateOfBirth = user.DateOfBirth,
            Gender = user.Gender,
            ProfileImageUrl = user.ProfileImageUrl,
            IsEmailVerified = user.IsEmailVerified,
            Roles = user.UserRoles.Select(ur => ur.Role.RoleName).ToList(),
            CreatedAt = user.CreatedAt
        };
    }

    private async Task LogAuthenticationAsync(Guid? userId, string actionType, bool isSuccess, string? failureReason = null)
    {
        try
        {
            await _context.AuthenticationLogs.AddAsync(new AuthenticationLog
            {
                UserId = userId,
                ActionType = actionType,
                IsSuccess = isSuccess,
                FailureReason = failureReason
            });
            await _context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error logging authentication event");
        }
    }
}
