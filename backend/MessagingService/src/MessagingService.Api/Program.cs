using MedTravel.Shared.Auth.Extensions;
using MedTravel.Shared.Logging;
using MedTravel.Shared.Logging.Middleware;
using MedTravel.Shared.Validation.Middleware;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

Log.Logger = LoggingConfiguration.CreateLogger(builder.Configuration, "MessagingService");
builder.Host.UseSerilog();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = "Messaging Service API", Version = "v1" });
});

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", b => b.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

builder.Services.AddMedTravelAuth(builder.Configuration);
builder.Services.AddHealthChecks();

var app = builder.Build();

app.UseMiddleware<CorrelationIdMiddleware>();
app.UseMiddleware<ValidationMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseMedTravelAuth(builder.Configuration);
app.MapControllers();
app.MapHealthChecks("/health");

app.Run();
