using Microsoft.EntityFrameworkCore;
using UserService.Data;
using UserService.DTOs;
using UserService.Models;

namespace UserService.Services;

public class UserService : IUserService
{
    private readonly UserDbContext _context;
    private readonly ILogger<UserService> _logger;

    public UserService(UserDbContext context, ILogger<UserService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<ApiResponse<UserDTO>> GetUserByIdAsync(Guid userId)
    {
        try
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                    .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.UserId == userId);

            if (user == null)
            {
                return new ApiResponse<UserDTO>
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            return new ApiResponse<UserDTO>
            {
                Success = true,
                Data = MapToUserDTO(user)
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user");
            return new ApiResponse<UserDTO>
            {
                Success = false,
                Message = "Failed to retrieve user",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserDTO>> GetUserByEmailAsync(string email)
    {
        try
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                    .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Email == email);

            if (user == null)
            {
                return new ApiResponse<UserDTO>
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            return new ApiResponse<UserDTO>
            {
                Success = true,
                Data = MapToUserDTO(user)
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user by email");
            return new ApiResponse<UserDTO>
            {
                Success = false,
                Message = "Failed to retrieve user",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserDTO>> UpdateUserAsync(Guid userId, UpdateUserRequest request)
    {
        try
        {
            var user = await _context.Users
                .Include(u => u.UserRoles)
                    .ThenInclude(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.UserId == userId);

            if (user == null)
            {
                return new ApiResponse<UserDTO>
                {
                    Success = false,
                    Message = "User not found"
                };
            }

            if (!string.IsNullOrWhiteSpace(request.FirstName))
                user.FirstName = request.FirstName;
            
            if (!string.IsNullOrWhiteSpace(request.LastName))
                user.LastName = request.LastName;
            
            if (!string.IsNullOrWhiteSpace(request.PhoneNumber))
                user.PhoneNumber = request.PhoneNumber;
            
            if (request.DateOfBirth.HasValue)
                user.DateOfBirth = request.DateOfBirth;
            
            if (!string.IsNullOrWhiteSpace(request.Gender))
                user.Gender = request.Gender;
            
            if (!string.IsNullOrWhiteSpace(request.ProfileImageUrl))
                user.ProfileImageUrl = request.ProfileImageUrl;

            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return new ApiResponse<UserDTO>
            {
                Success = true,
                Message = "User updated successfully",
                Data = MapToUserDTO(user)
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating user");
            return new ApiResponse<UserDTO>
            {
                Success = false,
                Message = "Failed to update user",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> DeleteUserAsync(Guid userId)
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

            user.IsActive = false;
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "User deactivated successfully",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting user");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Failed to delete user",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<List<UserAddressDTO>>> GetUserAddressesAsync(Guid userId)
    {
        try
        {
            var addresses = await _context.UserAddresses
                .Where(a => a.UserId == userId)
                .Select(a => new UserAddressDTO
                {
                    AddressId = a.AddressId,
                    AddressType = a.AddressType,
                    Street = a.Street,
                    City = a.City,
                    State = a.State,
                    Country = a.Country,
                    PostalCode = a.PostalCode,
                    IsDefault = a.IsDefault
                })
                .ToListAsync();

            return new ApiResponse<List<UserAddressDTO>>
            {
                Success = true,
                Data = addresses
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user addresses");
            return new ApiResponse<List<UserAddressDTO>>
            {
                Success = false,
                Message = "Failed to retrieve addresses",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserAddressDTO>> AddUserAddressAsync(Guid userId, UserAddressDTO addressDto)
    {
        try
        {
            var address = new UserAddress
            {
                UserId = userId,
                AddressType = addressDto.AddressType,
                Street = addressDto.Street,
                City = addressDto.City,
                State = addressDto.State,
                Country = addressDto.Country,
                PostalCode = addressDto.PostalCode,
                IsDefault = addressDto.IsDefault
            };

            if (addressDto.IsDefault)
            {
                var existingAddresses = await _context.UserAddresses
                    .Where(a => a.UserId == userId && a.IsDefault)
                    .ToListAsync();
                
                foreach (var addr in existingAddresses)
                {
                    addr.IsDefault = false;
                }
            }

            await _context.UserAddresses.AddAsync(address);
            await _context.SaveChangesAsync();

            addressDto.AddressId = address.AddressId;

            return new ApiResponse<UserAddressDTO>
            {
                Success = true,
                Message = "Address added successfully",
                Data = addressDto
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding user address");
            return new ApiResponse<UserAddressDTO>
            {
                Success = false,
                Message = "Failed to add address",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserAddressDTO>> UpdateUserAddressAsync(Guid userId, Guid addressId, UserAddressDTO addressDto)
    {
        try
        {
            var address = await _context.UserAddresses
                .FirstOrDefaultAsync(a => a.AddressId == addressId && a.UserId == userId);

            if (address == null)
            {
                return new ApiResponse<UserAddressDTO>
                {
                    Success = false,
                    Message = "Address not found"
                };
            }

            address.AddressType = addressDto.AddressType;
            address.Street = addressDto.Street;
            address.City = addressDto.City;
            address.State = addressDto.State;
            address.Country = addressDto.Country;
            address.PostalCode = addressDto.PostalCode;
            address.IsDefault = addressDto.IsDefault;
            address.UpdatedAt = DateTime.UtcNow;

            if (addressDto.IsDefault)
            {
                var otherAddresses = await _context.UserAddresses
                    .Where(a => a.UserId == userId && a.AddressId != addressId && a.IsDefault)
                    .ToListAsync();
                
                foreach (var addr in otherAddresses)
                {
                    addr.IsDefault = false;
                }
            }

            await _context.SaveChangesAsync();

            return new ApiResponse<UserAddressDTO>
            {
                Success = true,
                Message = "Address updated successfully",
                Data = addressDto
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating user address");
            return new ApiResponse<UserAddressDTO>
            {
                Success = false,
                Message = "Failed to update address",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<bool>> DeleteUserAddressAsync(Guid userId, Guid addressId)
    {
        try
        {
            var address = await _context.UserAddresses
                .FirstOrDefaultAsync(a => a.AddressId == addressId && a.UserId == userId);

            if (address == null)
            {
                return new ApiResponse<bool>
                {
                    Success = false,
                    Message = "Address not found"
                };
            }

            _context.UserAddresses.Remove(address);
            await _context.SaveChangesAsync();

            return new ApiResponse<bool>
            {
                Success = true,
                Message = "Address deleted successfully",
                Data = true
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting user address");
            return new ApiResponse<bool>
            {
                Success = false,
                Message = "Failed to delete address",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserPreferenceDTO>> GetUserPreferencesAsync(Guid userId)
    {
        try
        {
            var preference = await _context.UserPreferences
                .FirstOrDefaultAsync(p => p.UserId == userId);

            if (preference == null)
            {
                return new ApiResponse<UserPreferenceDTO>
                {
                    Success = false,
                    Message = "User preferences not found"
                };
            }

            var dto = new UserPreferenceDTO
            {
                LanguageCode = preference.LanguageCode,
                CurrencyCode = preference.CurrencyCode,
                NotificationEmail = preference.NotificationEmail,
                NotificationSMS = preference.NotificationSMS,
                NotificationPush = preference.NotificationPush,
                ThemePreference = preference.ThemePreference
            };

            return new ApiResponse<UserPreferenceDTO>
            {
                Success = true,
                Data = dto
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user preferences");
            return new ApiResponse<UserPreferenceDTO>
            {
                Success = false,
                Message = "Failed to retrieve preferences",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    public async Task<ApiResponse<UserPreferenceDTO>> UpdateUserPreferencesAsync(Guid userId, UserPreferenceDTO preferencesDto)
    {
        try
        {
            var preference = await _context.UserPreferences
                .FirstOrDefaultAsync(p => p.UserId == userId);

            if (preference == null)
            {
                preference = new UserPreference
                {
                    UserId = userId
                };
                await _context.UserPreferences.AddAsync(preference);
            }

            preference.LanguageCode = preferencesDto.LanguageCode;
            preference.CurrencyCode = preferencesDto.CurrencyCode;
            preference.NotificationEmail = preferencesDto.NotificationEmail;
            preference.NotificationSMS = preferencesDto.NotificationSMS;
            preference.NotificationPush = preferencesDto.NotificationPush;
            preference.ThemePreference = preferencesDto.ThemePreference;
            preference.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return new ApiResponse<UserPreferenceDTO>
            {
                Success = true,
                Message = "Preferences updated successfully",
                Data = preferencesDto
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating user preferences");
            return new ApiResponse<UserPreferenceDTO>
            {
                Success = false,
                Message = "Failed to update preferences",
                Errors = new List<string> { ex.Message }
            };
        }
    }

    private static UserDTO MapToUserDTO(User user)
    {
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
}
