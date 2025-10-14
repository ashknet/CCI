using System.Security.Claims;
using MedTravel.Shared.Auth.Models;
using MedTravel.Shared.Auth.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace MedTravel.Shared.Auth.Middleware;

public class LocalDevAuthMiddleware
{
    private readonly RequestDelegate _next;
    private readonly AuthSettings _authSettings;
    private readonly IJwtService _jwtService;

    public LocalDevAuthMiddleware(RequestDelegate next, IOptions<AuthSettings> authSettings, IJwtService jwtService)
    {
        _next = next;
        _authSettings = authSettings.Value;
        _jwtService = jwtService;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        if (_authSettings.LocalDevMode && _authSettings.LocalDevUser != null)
        {
            // In local dev mode, automatically authenticate with configured user
            var devUser = _authSettings.LocalDevUser;
            
            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, devUser.UserId),
                new(ClaimTypes.Email, devUser.Email),
                new(ClaimTypes.Role, devUser.Role),
                new(ClaimTypes.GivenName, devUser.FirstName),
                new(ClaimTypes.Surname, devUser.LastName),
                new("Country", devUser.Country),
                new("City", devUser.City),
                new("Phone", devUser.Phone)
            };

            var identity = new ClaimsIdentity(claims, "LocalDev");
            context.User = new ClaimsPrincipal(identity);
        }

        await _next(context);
    }
}
