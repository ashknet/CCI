using UserService.DTOs;

namespace UserService.Services;

public interface IAuthService
{
    Task<ApiResponse<LoginResponse>> RegisterAsync(RegisterRequest request);
    Task<ApiResponse<LoginResponse>> LoginAsync(LoginRequest request);
    Task<ApiResponse<LoginResponse>> RefreshTokenAsync(string refreshToken);
    Task<ApiResponse<bool>> LogoutAsync(Guid userId);
    Task<ApiResponse<bool>> ChangePasswordAsync(Guid userId, ChangePasswordRequest request);
    Task<ApiResponse<bool>> ForgotPasswordAsync(ForgotPasswordRequest request);
    Task<ApiResponse<bool>> ResetPasswordAsync(ResetPasswordRequest request);
    Task<ApiResponse<bool>> VerifyEmailAsync(string token);
}
