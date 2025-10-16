using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;
using HospitalService.Core.Interfaces;
using HospitalService.Infrastructure.Data;
using HospitalService.Infrastructure.Repositories;

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
    options.AddPolicy("AllowAll", b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

builder.Services.AddDbContext<HospitalDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlOptions => sqlOptions.EnableRetryOnFailure()));

builder.Services.AddMedTravelAuth(builder.Configuration);

builder.Services.AddScoped<IHospitalRepository, HospitalRepository>();
builder.Services.AddScoped<IDoctorRepository, DoctorRepository>();
builder.Services.AddScoped<IAppointmentRepository, AppointmentRepository>();
builder.Services.AddScoped<IReviewRepository, ReviewRepository>();
builder.Services.AddScoped<ISpecialtyRepository, SpecialtyRepository>();

builder.Services.AddHealthChecks().AddDbContextCheck<HospitalDbContext>();

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Hospital Service API v1"));
}

app.UseCors("AllowAll");
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
