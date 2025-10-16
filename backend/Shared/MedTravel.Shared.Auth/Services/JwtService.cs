using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using MedTravel.Shared.Auth.Models;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace MedTravel.Shared.Auth.Services;

public class JwtService : IJwtService
{
    private readonly AuthSettings _authSettings;
    private readonly JwtSecurityTokenHandler _tokenHandler;

    public JwtService(IOptions<AuthSettings> authSettings)
    {
        _authSettings = authSettings.Value;
        _tokenHandler = new JwtSecurityTokenHandler();
    }

    public string GenerateToken(string userId, string email, string role, Dictionary<string, string>? additionalClaims = null)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userId),
            new(ClaimTypes.Email, email),
            new(ClaimTypes.Role, role),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        if (additionalClaims != null)
        {
            foreach (var claim in additionalClaims)
            {
                claims.Add(new Claim(claim.Key, claim.Value));
            }
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_authSettings.JwtSecret));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expires = DateTime.UtcNow.AddMinutes(_authSettings.JwtExpirationMinutes);

        var token = new JwtSecurityToken(
            issuer: _authSettings.JwtIssuer,
            audience: _authSettings.JwtAudience,
            claims: claims,
            expires: expires,
            signingCredentials: creds
        );

        return _tokenHandler.WriteToken(token);
    }

    public ClaimsPrincipal? ValidateToken(string token)
    {
        try
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_authSettings.JwtSecret));
            var validationParameters = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = key,
                ValidateIssuer = true,
                ValidIssuer = _authSettings.JwtIssuer,
                ValidateAudience = true,
                ValidAudience = _authSettings.JwtAudience,
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            };

            var principal = _tokenHandler.ValidateToken(token, validationParameters, out var validatedToken);
            return principal;
        }
        catch
        {
            return null;
        }
    }

    public string? GetUserIdFromToken(string token)
    {
        var principal = ValidateToken(token);
        return principal?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
    }

    public string? GetRoleFromToken(string token)
    {
        var principal = ValidateToken(token);
        return principal?.FindFirst(ClaimTypes.Role)?.Value;
    }
}
