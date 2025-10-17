using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Api.Services;
using UserManagementService.Core.DTOs;

namespace UserManagementService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IAuthService authService, ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    /// <summary>
    /// Register a new user
    /// </summary>
    [HttpPost("register")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<LoginResponse>>> Register([FromBody] RegisterUserRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var result = await _authService.RegisterAsync(request);
        return Ok(ApiResponse<LoginResponse>.SuccessResponse(result, "User registered successfully", correlationId));
    }

    /// <summary>
    /// Login with email and password
    /// </summary>
    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<LoginResponse>>> Login([FromBody] LoginRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var result = await _authService.LoginAsync(request);
        return Ok(ApiResponse<LoginResponse>.SuccessResponse(result, "Login successful", correlationId));
    }

    /// <summary>
    /// Refresh access token using refresh token
    /// </summary>
    [HttpPost("refresh")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<LoginResponse>>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var result = await _authService.RefreshTokenAsync(request);
        return Ok(ApiResponse<LoginResponse>.SuccessResponse(result, "Token refreshed successfully", correlationId));
    }

    /// <summary>
    /// Logout current session
    /// </summary>
    [HttpPost("logout")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> Logout([FromBody] RefreshTokenRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        await _authService.LogoutAsync(userId, request.RefreshToken);
        return Ok(ApiResponse<object>.SuccessResponse(null, "Logout successful", correlationId));
    }

    /// <summary>
    /// Get current user profile
    /// </summary>
    [HttpGet("profile")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> GetProfile()
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var result = await _authService.GetUserProfileAsync(userId);
        return Ok(ApiResponse<UserDto>.SuccessResponse(result, null, correlationId));
    }

    /// <summary>
    /// Update current user profile
    /// </summary>
    [HttpPut("profile")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<UserDto>>> UpdateProfile([FromBody] UpdateUserRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var result = await _authService.UpdateUserProfileAsync(userId, request);
        return Ok(ApiResponse<UserDto>.SuccessResponse(result, "Profile updated successfully", correlationId));
    }

    /// <summary>
    /// Change password
    /// </summary>
    [HttpPost("change-password")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        await _authService.ChangePasswordAsync(userId, request);
        return Ok(ApiResponse<object>.SuccessResponse(null, "Password changed successfully", correlationId));
    }
}
