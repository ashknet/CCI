using System.Text;
using MedTravel.Shared.Auth.Middleware;
using MedTravel.Shared.Auth.Models;
using MedTravel.Shared.Auth.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;

namespace MedTravel.Shared.Auth.Extensions;

public static class AuthExtensions
{
    public static IServiceCollection AddMedTravelAuth(this IServiceCollection services, IConfiguration configuration)
    {
        var authSettings = configuration.GetSection("AuthSettings").Get<AuthSettings>() ?? new AuthSettings();
        services.Configure<AuthSettings>(configuration.GetSection("AuthSettings"));
        services.AddScoped<IJwtService, JwtService>();

        if (!authSettings.LocalDevMode)
        {
            // Production JWT authentication
            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(authSettings.JwtSecret)),
                    ValidateIssuer = true,
                    ValidIssuer = authSettings.JwtIssuer,
                    ValidateAudience = true,
                    ValidAudience = authSettings.JwtAudience,
                    ValidateLifetime = true,
                    ClockSkew = TimeSpan.Zero
                };
            });
        }
        else
        {
            // Local dev mode - no actual JWT validation
            services.AddAuthentication("LocalDev")
                .AddScheme<Microsoft.AspNetCore.Authentication.AuthenticationSchemeOptions, LocalDevAuthHandler>("LocalDev", options => { });
        }

        services.AddAuthorization();

        return services;
    }

    public static IApplicationBuilder UseMedTravelAuth(this IApplicationBuilder app, IConfiguration configuration)
    {
        var authSettings = configuration.GetSection("AuthSettings").Get<AuthSettings>();
        
        if (authSettings?.LocalDevMode == true)
        {
            app.UseMiddleware<LocalDevAuthMiddleware>();
        }

        app.UseAuthentication();
        app.UseAuthorization();

        return app;
    }
}
