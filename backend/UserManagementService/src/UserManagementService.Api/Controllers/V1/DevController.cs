using MedTravel.Shared.Auth.Models;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace UserManagementService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/dev")]
[ApiVersion("1.0")]
public class DevController : ControllerBase
{
    private readonly AuthSettings _authSettings;

    public DevController(IOptions<AuthSettings> authSettings)
    {
        _authSettings = authSettings.Value;
    }

    /// <summary>
    /// Get default user configuration (Local Dev Mode Only)
    /// Returns the configured default user when auth bypass is enabled
    /// </summary>
    [HttpGet("default-user")]
    [AllowAnonymous]
    public ActionResult<ApiResponse<object>> GetDefaultUser()
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        if (!_authSettings.LocalDevMode)
        {
            return NotFound(ApiResponse<object>.ErrorResponse(
                "This endpoint is only available in Local Dev Mode",
                null,
                correlationId
            ));
        }

        var user = _authSettings.LocalDevUser;
        if (user == null)
        {
            return NotFound(ApiResponse<object>.ErrorResponse(
                "No default user configured",
                null,
                correlationId
            ));
        }

        var userData = new
        {
            userId = user.UserId,
            email = user.Email,
            firstName = user.FirstName,
            lastName = user.LastName,
            role = user.Role,
            country = user.Country,
            city = user.City,
            phone = user.Phone,
            localDevMode = _authSettings.LocalDevMode
        };

        return Ok(ApiResponse<object>.SuccessResponse(
            userData,
            "Local dev user configuration retrieved. Authentication is bypassed in this mode.",
            correlationId
        ));
    }
}
