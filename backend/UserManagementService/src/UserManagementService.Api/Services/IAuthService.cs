using UserManagementService.Core.DTOs;

namespace UserManagementService.Api.Services;

public interface IAuthService
{
    Task<LoginResponse> RegisterAsync(RegisterUserRequest request);
    Task<LoginResponse> LoginAsync(LoginRequest request);
    Task<LoginResponse> RefreshTokenAsync(RefreshTokenRequest request);
    Task LogoutAsync(Guid userId, string refreshToken);
    Task<UserDto> GetUserProfileAsync(Guid userId);
    Task<UserDto> UpdateUserProfileAsync(Guid userId, UpdateUserRequest request);
    Task ChangePasswordAsync(Guid userId, ChangePasswordRequest request);
}
