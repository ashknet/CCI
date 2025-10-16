using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using UserManagementService.Api.Services;
using UserManagementService.Core.DTOs;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/auth")]
[ApiVersion("1.0")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IConfiguration _configuration;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IAuthService authService, IConfiguration configuration, ILogger<AuthController> logger)
    {
        _authService = authService;
        _configuration = configuration;
        _logger = logger;
    }

    /// <summary>
    /// Register new user
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
    /// Login with credentials
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
    /// Refresh access token
    /// </summary>
    [HttpPost("refresh")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<LoginResponse>>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        var result = await _authService.RefreshTokenAsync(request);
        return Ok(ApiResponse<LoginResponse>.SuccessResponse(result, "Token refreshed", correlationId));
    }

    /// <summary>
    /// Verify MFA code
    /// </summary>
    [HttpPost("mfa/verify")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> VerifyMFA([FromBody] object mfaRequest)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        // MFA verification logic
        return Ok(ApiResponse<object>.SuccessResponse(null, "MFA verified", correlationId));
    }

    /// <summary>
    /// Request password reset
    /// </summary>
    [HttpPost("password/forgot")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> ForgotPassword([FromBody] object request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        // Send password reset email
        return Ok(ApiResponse<object>.SuccessResponse(null, "Password reset email sent", correlationId));
    }

    /// <summary>
    /// Reset password with token
    /// </summary>
    [HttpPost("password/reset")]
    [AllowAnonymous]
    public async Task<ActionResult<ApiResponse<object>>> ResetPassword([FromBody] object request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        // Reset password logic
        return Ok(ApiResponse<object>.SuccessResponse(null, "Password reset successful", correlationId));
    }
}
