using UserService.DTOs;

namespace UserService.Services;

public interface IUserService
{
    Task<ApiResponse<UserDTO>> GetUserByIdAsync(Guid userId);
    Task<ApiResponse<UserDTO>> GetUserByEmailAsync(string email);
    Task<ApiResponse<UserDTO>> UpdateUserAsync(Guid userId, UpdateUserRequest request);
    Task<ApiResponse<bool>> DeleteUserAsync(Guid userId);
    Task<ApiResponse<List<UserAddressDTO>>> GetUserAddressesAsync(Guid userId);
    Task<ApiResponse<UserAddressDTO>> AddUserAddressAsync(Guid userId, UserAddressDTO address);
    Task<ApiResponse<UserAddressDTO>> UpdateUserAddressAsync(Guid userId, Guid addressId, UserAddressDTO address);
    Task<ApiResponse<bool>> DeleteUserAddressAsync(Guid userId, Guid addressId);
    Task<ApiResponse<UserPreferenceDTO>> GetUserPreferencesAsync(Guid userId);
    Task<ApiResponse<UserPreferenceDTO>> UpdateUserPreferencesAsync(Guid userId, UserPreferenceDTO preferences);
}
