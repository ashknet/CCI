using UserService.Models;

namespace UserService.Services;

public interface ITokenService
{
    (string Token, DateTime ExpiresAt) GenerateAccessToken(User user, List<string> roles);
    Task<string> GenerateRefreshTokenAsync(Guid userId);
    Guid? GetUserIdFromToken(string token);
}
