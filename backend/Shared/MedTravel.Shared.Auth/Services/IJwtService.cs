using System.Security.Claims;

namespace MedTravel.Shared.Auth.Services;

public interface IJwtService
{
    string GenerateToken(string userId, string email, string role, Dictionary<string, string>? additionalClaims = null);
    ClaimsPrincipal? ValidateToken(string token);
    string? GetUserIdFromToken(string token);
    string? GetRoleFromToken(string token);
}
