using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;
using UserManagementService.Api.Services;
using UserManagementService.Core.Interfaces;
using UserManagementService.Infrastructure.Data;
using UserManagementService.Infrastructure.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = LoggingConfiguration.CreateLogger(builder.Configuration, "UserManagementService");
builder.Host.UseSerilog();

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { 
        Title = "User Management Service API", 
        Version = "v1",
        Description = "API for user registration, authentication, profiles, and notifications"
    });
    c.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme. Example: 'Bearer {token}'",
        Name = "Authorization",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Add CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

// Add Database
builder.Services.AddDbContext<UserManagementDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlOptions => sqlOptions.EnableRetryOnFailure()
    ));

// Add Authentication and Authorization
builder.Services.AddMedTravelAuth(builder.Configuration);

// Add Repositories
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IRoleRepository, RoleRepository>();
builder.Services.AddScoped<ISessionRepository, SessionRepository>();
builder.Services.AddScoped<INotificationRepository, NotificationRepository>();
builder.Services.AddScoped<IUserPreferenceRepository, UserPreferenceRepository>();
builder.Services.AddScoped<IInsurancePolicyRepository, InsurancePolicyRepository>();
builder.Services.AddScoped<IAuditLogRepository, AuditLogRepository>();

// Add Services
builder.Services.AddScoped<IAuthService, AuthService>();

// Add Health Checks
builder.Services.AddHealthChecks()
    .AddDbContextCheck<UserManagementDbContext>();

var app = builder.Build();

// Configure middleware
app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

// Configure Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "User Management Service API v1"));
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);

app.MapControllers();
app.MapHealthChecks("/health");

// Apply migrations automatically in development
if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<UserManagementDbContext>();
    dbContext.Database.Migrate();
}

app.Run();
