using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Data;
using HospitalService.Infrastructure.Repositories;
using HospitalService.Infrastructure.Services;
using Microsoft.Extensions.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = LoggingConfiguration.CreateLogger(builder.Configuration, "HospitalService");
builder.Host.UseSerilog();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

// Add API Versioning
builder.Services.AddApiVersioning(options =>
{
    options.DefaultApiVersion = new Microsoft.AspNetCore.Mvc.ApiVersion(1, 0);
    options.AssumeDefaultVersionWhenUnspecified = true;
    options.ReportApiVersions = true;
});

builder.Services.AddVersionedApiExplorer(options =>
{
    options.GroupNameFormat = "'v'VVV";
    options.SubstituteApiVersionInUrl = true;
});

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { 
        Title = "Hospital Service API", 
        Version = "v1",
        Description = "API for hospital search, doctor profiles, and appointment booking. All endpoints use /api/v1/ prefix."
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", b => b
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("X-Total-Count", "X-Page-Count"));
    
    // Production CORS policy for specific domains
    options.AddPolicy("Production", b => b
        .WithOrigins(
            "https://cci-kohl.vercel.app",
            "http://localhost:3000",
            "http://localhost:5173",
            "https://localhost:5173"
        )
        .AllowAnyMethod()
        .AllowAnyHeader()
        .WithExposedHeaders("X-Total-Count", "X-Page-Count")
        .AllowCredentials());
});

builder.Services.AddDbContext<HospitalDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlOptions => sqlOptions.EnableRetryOnFailure()));

builder.Services.AddMedTravelAuth(builder.Configuration);

// Add Memory Cache for fast search
builder.Services.AddMemoryCache();

// Add repositories
builder.Services.AddScoped<IHospitalRepository, HospitalRepository>();
builder.Services.AddScoped<IDoctorRepository, DoctorRepository>();
builder.Services.AddScoped<IAppointmentRepository, AppointmentRepository>();
builder.Services.AddScoped<IReviewRepository, ReviewRepository>();
builder.Services.AddScoped<ISpecialtyRepository, SpecialtyRepository>();
builder.Services.AddScoped<ISelectionFlowRepository, SelectionFlowRepository>();

// Add services
builder.Services.AddScoped<IHospitalService, HospitalService.Infrastructure.Services.HospitalService>();
// builder.Services.AddScoped<ISelectionFlowService, SelectionFlowService>(); // Temporarily disabled due to build errors

// Add high-performance search service (Singleton for better caching)
builder.Services.AddSingleton<IFastSearchService, FastSearchService>();

builder.Services.AddHealthChecks();
    //.AddDbContextCheck<HospitalDbContext>(); // TODO: Add when AspNetCore.HealthChecks.SqlServer is properly configured

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

//if (app.Environment.IsDevelopment())
//{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Hospital Service API v1"));
//}

// Use appropriate CORS policy based on environment
if (app.Environment.IsDevelopment())
{
    app.UseCors("AllowAll");
}
else
{
    app.UseCors("Production");
}
app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);
app.MapControllers();
app.MapHealthChecks("/health");

if (app.Environment.IsDevelopment())
{
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<HospitalDbContext>();
    dbContext.Database.Migrate();
}

app.Run();
