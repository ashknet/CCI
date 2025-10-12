using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using BCrypt.Net;
using Dapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// JWT configuration
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? "medtourism-local";
var jwtAudience = builder.Configuration["Jwt:Audience"] ?? "medtourism-clients";
var jwtKey = builder.Configuration["Jwt:Key"] ?? "dev_super_secret_key_please_change";
var signingKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = signingKey,
            ClockSkew = TimeSpan.FromMinutes(2)
        };
    });

builder.Services.AddAuthorization();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "IdentityService", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT"
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        { new OpenApiSecurityScheme { Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" } }, new string[] {} }
    });
});

var app = builder.Build();

// Swagger always on for local dev and beyond
app.UseSwagger();
app.UseSwaggerUI();

// Only enforce JWT outside Development
if (!app.Environment.IsDevelopment())
{
    app.UseAuthentication();
    app.UseAuthorization();
}

string DefaultConnStr() => app.Configuration.GetConnectionString("SqlServer") ?? "Server=sqlserver;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;";

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapPost("/user/register", async (RegisterRequest req) =>
{
    if (string.IsNullOrWhiteSpace(req.Email) || string.IsNullOrWhiteSpace(req.Password) || string.IsNullOrWhiteSpace(req.FullName))
        return Results.BadRequest(new { error = "Missing required fields" });

    var passwordHash = BCrypt.Net.BCrypt.HashPassword(req.Password);
    await using var conn = new SqlConnection(DefaultConnStr());
    var newId = await conn.ExecuteScalarAsync<long>(
        sql: "identity.sp_CreateUser",
        commandType: CommandType.StoredProcedure,
        param: new
        {
            Email = req.Email,
            PasswordHash = passwordHash,
            FullName = req.FullName,
            Phone = req.Phone,
            Country = req.Country,
            City = req.City,
            Role = req.Role ?? "Patient"
        }
    );

    var token = CreateToken(newId, req.Email, req.Role ?? "Patient", jwtIssuer, jwtAudience, signingKey);
    return Results.Ok(new { userId = newId, token });
});

app.MapPost("/user/login", async (LoginRequest req) =>
{
    await using var conn = new SqlConnection(DefaultConnStr());
    var user = await conn.QuerySingleOrDefaultAsync<dynamic>(
        sql: "identity.sp_GetUserByEmail",
        commandType: CommandType.StoredProcedure,
        param: new { Email = req.Email }
    );
    if (user is null) return Results.Unauthorized();
    string storedHash = user.PasswordHash;
    bool ok = BCrypt.Net.BCrypt.Verify(req.Password, storedHash);
    if (!ok) return Results.Unauthorized();

    long userId = (long)user.Id;
    string role = (string)user.Role;
    var token = CreateToken(userId, req.Email, role, jwtIssuer, jwtAudience, signingKey);
    return Results.Ok(new { userId, token, role, name = (string)user.FullName });
});

app.MapGet("/me", [Microsoft.AspNetCore.Authorization.Authorize] (ClaimsPrincipal user) =>
{
    var id = user.FindFirstValue(ClaimTypes.NameIdentifier);
    var email = user.FindFirstValue(ClaimTypes.Email);
    var role = user.FindFirstValue(ClaimTypes.Role);
    return Results.Ok(new { id, email, role });
});

app.Run();

static string CreateToken(long userId, string email, string role, string issuer, string audience, SymmetricSecurityKey key)
{
    var handler = new JwtSecurityTokenHandler();
    var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
    var claims = new List<Claim>
    {
        new(ClaimTypes.NameIdentifier, userId.ToString()),
        new(ClaimTypes.Email, email),
        new(ClaimTypes.Role, role)
    };
    var token = new JwtSecurityToken(
        issuer: issuer,
        audience: audience,
        claims: claims,
        notBefore: DateTime.UtcNow.AddMinutes(-1),
        expires: DateTime.UtcNow.AddHours(8),
        signingCredentials: creds
    );
    return handler.WriteToken(token);
}

public record RegisterRequest(string Email, string Password, string FullName, string? Phone, string? Country, string? City, string? Role);
public record LoginRequest(string Email, string Password);