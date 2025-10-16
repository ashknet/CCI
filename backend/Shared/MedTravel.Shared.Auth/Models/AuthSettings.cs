namespace MedTravel.Shared.Auth.Models;

public class AuthSettings
{
    public bool LocalDevMode { get; set; }
    public string JwtSecret { get; set; } = string.Empty;
    public string JwtIssuer { get; set; } = string.Empty;
    public string JwtAudience { get; set; } = string.Empty;
    public int JwtExpirationMinutes { get; set; } = 60;
    public LocalDevUser? LocalDevUser { get; set; }
}

public class LocalDevUser
{
    public string UserId { get; set; } = "local-dev-user-001";
    public string Email { get; set; } = "devuser@medtravel.local";
    public string FirstName { get; set; } = "Dev";
    public string LastName { get; set; } = "User";
    public string Role { get; set; } = "patient";
    public string Country { get; set; } = "USA";
    public string City { get; set; } = "New York";
    public string Phone { get; set; } = "+1-555-0100";
}
