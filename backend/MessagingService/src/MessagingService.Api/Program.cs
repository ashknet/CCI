using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Microsoft.EntityFrameworkCore;
using Serilog;
using MessagingService.Infrastructure.Data;
using Microsoft.Extensions.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = LoggingConfiguration.CreateLogger(builder.Configuration, "MessagingService");
builder.Host.UseSerilog();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { 
        Title = "Messaging Service API", 
        Version = "v1",
        Description = "API for secure patient-provider messaging"
    });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

builder.Services.AddDbContext<MessagingDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection") ?? 
        "Server=sqlserver;Database=MessagingDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;",
        sqlOptions => sqlOptions.EnableRetryOnFailure()
    ));

builder.Services.AddMedTravelAuth(builder.Configuration);
builder.Services.AddHealthChecks();
    //.AddDbContextCheck<MessagingDbContext>(); // TODO: Add when AspNetCore.HealthChecks.SqlServer is properly configured

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider.GetRequiredService<MessagingDbContext>();
    dbContext.Database.Migrate();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);
app.MapControllers();
app.MapHealthChecks("/health");

app.Run();
