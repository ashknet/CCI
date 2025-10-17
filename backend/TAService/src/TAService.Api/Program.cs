using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;
using TransportationAccommodationService.Infrastructure.Data;
using Microsoft.Extensions.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = LoggingConfiguration.CreateLogger(builder.Configuration, "TransportationAccommodationService");
builder.Host.UseSerilog();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { 
        Title = "Transportation & Accommodation Service API", 
        Version = "v1",
        Description = "API for flight/train booking and hotel accommodation"
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

builder.Services.AddDbContext<TransportationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection") ?? 
        "Server=sqlserver;Database=TransportationDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;",
        sqlOptions => sqlOptions.EnableRetryOnFailure()
    ));

builder.Services.AddMedTravelAuth(builder.Configuration);
builder.Services.AddHealthChecks();
    //.AddDbContextCheck<TransportationDbContext>(); // TODO: Add when AspNetCore.HealthChecks.SqlServer is properly configured

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<TransportationDbContext>();
    dbContext.Database.Migrate();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);
app.MapControllers();
app.MapHealthChecks("/health");

app.Run();
