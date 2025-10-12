using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserService.DTOs;

namespace UserService.Controllers;

/// <summary>
/// User management endpoints
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Authorize]
[Produces("application/json")]
public class UsersController : ControllerBase
{
    private readonly Services.IUserService _userService;
    private readonly ILogger<UsersController> _logger;

    public UsersController(Services.IUserService userService, ILogger<UsersController> logger)
    {
        _userService = userService;
        _logger = logger;
    }

    /// <summary>
    /// Get current user profile
    /// </summary>
    /// <returns>User details</returns>
    [HttpGet("me")]
    [ProducesResponseType(typeof(ApiResponse<UserDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ApiResponse<UserDTO>>> GetCurrentUser()
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.GetUserByIdAsync(userId);
        return result.Success ? Ok(result) : NotFound(result);
    }

    /// <summary>
    /// Get user by ID
    /// </summary>
    /// <param name="userId">User ID</param>
    /// <returns>User details</returns>
    [HttpGet("{userId}")]
    [ProducesResponseType(typeof(ApiResponse<UserDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ApiResponse<UserDTO>>> GetUser(Guid userId)
    {
        var result = await _userService.GetUserByIdAsync(userId);
        return result.Success ? Ok(result) : NotFound(result);
    }

    /// <summary>
    /// Update user profile
    /// </summary>
    /// <param name="request">Updated user details</param>
    /// <returns>Updated user details</returns>
    [HttpPut("me")]
    [ProducesResponseType(typeof(ApiResponse<UserDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ApiResponse<UserDTO>>> UpdateUser([FromBody] UpdateUserRequest request)
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.UpdateUserAsync(userId, request);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    /// <summary>
    /// Delete/deactivate user account
    /// </summary>
    /// <returns>Success confirmation</returns>
    [HttpDelete("me")]
    [ProducesResponseType(typeof(ApiResponse<bool>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<bool>>> DeleteUser()
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<bool>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.DeleteUserAsync(userId);
        return Ok(result);
    }

    /// <summary>
    /// Get user addresses
    /// </summary>
    /// <returns>List of user addresses</returns>
    [HttpGet("me/addresses")]
    [ProducesResponseType(typeof(ApiResponse<List<UserAddressDTO>>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<List<UserAddressDTO>>>> GetAddresses()
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<List<UserAddressDTO>>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.GetUserAddressesAsync(userId);
        return Ok(result);
    }

    /// <summary>
    /// Add new address
    /// </summary>
    /// <param name="address">Address details</param>
    /// <returns>Created address</returns>
    [HttpPost("me/addresses")]
    [ProducesResponseType(typeof(ApiResponse<UserAddressDTO>), StatusCodes.Status201Created)]
    public async Task<ActionResult<ApiResponse<UserAddressDTO>>> AddAddress([FromBody] UserAddressDTO address)
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserAddressDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.AddUserAddressAsync(userId, address);
        return result.Success ? CreatedAtAction(nameof(GetAddresses), result) : BadRequest(result);
    }

    /// <summary>
    /// Update address
    /// </summary>
    /// <param name="addressId">Address ID</param>
    /// <param name="address">Updated address details</param>
    /// <returns>Updated address</returns>
    [HttpPut("me/addresses/{addressId}")]
    [ProducesResponseType(typeof(ApiResponse<UserAddressDTO>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<UserAddressDTO>>> UpdateAddress(Guid addressId, [FromBody] UserAddressDTO address)
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserAddressDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.UpdateUserAddressAsync(userId, addressId, address);
        return result.Success ? Ok(result) : BadRequest(result);
    }

    /// <summary>
    /// Delete address
    /// </summary>
    /// <param name="addressId">Address ID</param>
    /// <returns>Success confirmation</returns>
    [HttpDelete("me/addresses/{addressId}")]
    [ProducesResponseType(typeof(ApiResponse<bool>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<bool>>> DeleteAddress(Guid addressId)
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<bool>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.DeleteUserAddressAsync(userId, addressId);
        return Ok(result);
    }

    /// <summary>
    /// Get user preferences
    /// </summary>
    /// <returns>User preferences</returns>
    [HttpGet("me/preferences")]
    [ProducesResponseType(typeof(ApiResponse<UserPreferenceDTO>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<UserPreferenceDTO>>> GetPreferences()
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserPreferenceDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.GetUserPreferencesAsync(userId);
        return Ok(result);
    }

    /// <summary>
    /// Update user preferences
    /// </summary>
    /// <param name="preferences">Updated preferences</param>
    /// <returns>Updated preferences</returns>
    [HttpPut("me/preferences")]
    [ProducesResponseType(typeof(ApiResponse<UserPreferenceDTO>), StatusCodes.Status200OK)]
    public async Task<ActionResult<ApiResponse<UserPreferenceDTO>>> UpdatePreferences([FromBody] UserPreferenceDTO preferences)
    {
        var userIdClaim = User.FindFirst("userId")?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return BadRequest(new ApiResponse<UserPreferenceDTO>
            {
                Success = false,
                Message = "Invalid user"
            });
        }

        var result = await _userService.UpdateUserPreferencesAsync(userId, preferences);
        return Ok(result);
    }
}
