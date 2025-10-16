using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Core.DTOs;
using UserManagementService.Core.Interfaces;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/users")]
[ApiVersion("1.0")]
public class UsersController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly ILogger<UsersController> _logger;

    public UsersController(IUserRepository userRepository, ILogger<UsersController> logger)
    {
        _userRepository = userRepository;
        _logger = logger;
    }

    /// <summary>
    /// Get user by ID
    /// </summary>
    [HttpGet("{userId}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> GetUser(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var isAdmin = User.IsInRole("support") || User.IsInRole("hospital_admin");

        if (userId != currentUserId && !isAdmin)
            return Forbid();

        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            return NotFound(ApiResponse<UserDto>.ErrorResponse("User not found", null, correlationId));

        var dto = MapToDto(user);
        return Ok(ApiResponse<UserDto>.SuccessResponse(dto, null, correlationId));
    }

    /// <summary>
    /// Update user information
    /// </summary>
    [HttpPut("{userId}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> UpdateUser(Guid userId, [FromBody] UpdateUserRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            return NotFound(ApiResponse<UserDto>.ErrorResponse("User not found", null, correlationId));

        if (!string.IsNullOrEmpty(request.FirstName)) user.FirstName = request.FirstName;
        if (!string.IsNullOrEmpty(request.LastName)) user.LastName = request.LastName;
        if (!string.IsNullOrEmpty(request.Phone)) user.Phone = request.Phone;
        if (!string.IsNullOrEmpty(request.Country)) user.Country = request.Country;
        if (!string.IsNullOrEmpty(request.City)) user.City = request.City;

        user = await _userRepository.UpdateAsync(user);
        return Ok(ApiResponse<UserDto>.SuccessResponse(MapToDto(user), "User updated successfully", correlationId));
    }

    /// <summary>
    /// Delete user (admin only)
    /// </summary>
    [HttpDelete("{userId}")]
    [Authorize(Roles = "support")]
    public async Task<ActionResult<ApiResponse<object>>> DeleteUser(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var success = await _userRepository.DeleteAsync(userId);
        
        if (!success)
            return NotFound(ApiResponse<object>.ErrorResponse("User not found", null, correlationId));

        return Ok(ApiResponse<object>.SuccessResponse(null, "User deleted successfully", correlationId));
    }

    /// <summary>
    /// Get all users (admin only, with pagination and filters)
    /// </summary>
    [HttpGet]
    [Authorize(Roles = "support,hospital_admin")]
    public async Task<ActionResult<ApiResponse<PagedResult<UserDto>>>> GetUsers(
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20,
        [FromQuery] string? role = null,
        [FromQuery] string? country = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var users = await _userRepository.GetAllAsync(pageNumber, pageSize);
        
        var result = new PagedResult<UserDto>
        {
            Items = users.Select(MapToDto).ToList(),
            PageNumber = pageNumber,
            PageSize = pageSize,
            TotalCount = users.Count()
        };

        return Ok(ApiResponse<PagedResult<UserDto>>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Get user profile
    /// </summary>
    [HttpGet("{userId}/profile")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> GetUserProfile(Guid userId)
    {
        return await GetUser(userId);
    }

    /// <summary>
    /// Update user profile
    /// </summary>
    [HttpPut("{userId}/profile")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> UpdateUserProfile(Guid userId, [FromBody] UpdateUserRequest request)
    {
        return await UpdateUser(userId, request);
    }

    /// <summary>
    /// Get user preferences
    /// </summary>
    [HttpGet("{userId}/preferences")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> GetUserPreferences(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        // Mock preferences
        var preferences = new
        {
            language = "en",
            currency = "USD",
            emailNotifications = true,
            smsNotifications = true,
            pushNotifications = true
        };

        return Ok(ApiResponse<object>.SuccessResponse(preferences, null, correlationId));
    }

    /// <summary>
    /// Update user preferences
    /// </summary>
    [HttpPut("{userId}/preferences")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> UpdateUserPreferences(Guid userId, [FromBody] object preferences)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId)
            return Forbid();

        return Ok(ApiResponse<object>.SuccessResponse(preferences, "Preferences updated", correlationId));
    }

    /// <summary>
    /// Get user roles
    /// </summary>
    [HttpGet("{userId}/roles")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<string>>>> GetUserRoles(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var roles = await _userRepository.GetUserRolesAsync(userId);
        var roleNames = roles.Select(r => r.Name).ToList();
        
        return Ok(ApiResponse<List<string>>.SuccessResponse(roleNames, null, correlationId));
    }

    /// <summary>
    /// Update user roles (admin only)
    /// </summary>
    [HttpPut("{userId}/roles")]
    [Authorize(Roles = "support")]
    public async Task<ActionResult<ApiResponse<object>>> UpdateUserRoles(Guid userId, [FromBody] List<string> roles)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        // Implementation would update roles
        return Ok(ApiResponse<object>.SuccessResponse(null, "Roles updated", correlationId));
    }

    /// <summary>
    /// Get user bookings
    /// </summary>
    [HttpGet("{userId}/bookings")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetUserBookings(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        // Would fetch from appointments and bookings
        var bookings = new List<object>();
        return Ok(ApiResponse<List<object>>.SuccessResponse(bookings, null, correlationId));
    }

    /// <summary>
    /// Get user visits
    /// </summary>
    [HttpGet("{userId}/visits")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetUserVisits(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var visits = new List<object>();
        return Ok(ApiResponse<List<object>>.SuccessResponse(visits, null, correlationId));
    }

    /// <summary>
    /// Get user invoices
    /// </summary>
    [HttpGet("{userId}/invoices")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<object>>>> GetUserInvoices(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var invoices = new List<object>();
        return Ok(ApiResponse<List<object>>.SuccessResponse(invoices, null, correlationId));
    }

    /// <summary>
    /// Get user spend summary
    /// </summary>
    [HttpGet("{userId}/spend-summary")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> GetUserSpendSummary(Guid userId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var currentUserId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        if (userId != currentUserId && !User.IsInRole("support"))
            return Forbid();

        var summary = new
        {
            totalSpent = 0m,
            currency = "INR",
            breakdown = new
            {
                medical = 0m,
                travel = 0m,
                accommodation = 0m
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(summary, null, correlationId));
    }

    private UserDto MapToDto(Core.Entities.User user)
    {
        var roles = user.UserRoles.Select(ur => ur.Role.Name).ToList();
        return new UserDto(
            user.Id, user.Email, user.FirstName, user.LastName, user.Phone,
            user.DateOfBirth, user.Gender, user.Nationality, user.Country, user.City,
            user.Address, user.PostalCode, user.PassportNumber, user.EmailVerified,
            user.PhoneVerified, user.TwoFactorEnabled, roles, user.CreatedAt, user.LastLoginAt
        );
    }
}
