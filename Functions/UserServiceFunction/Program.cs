using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Serilog;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults()
    .ConfigureServices((context, services) =>
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.ConfigureFunctionsApplicationInsights();

        // Add Entity Framework Core
        var connectionString = context.Configuration.GetConnectionString("UserDatabase");
        services.AddDbContext<UserDbContext>(options =>
            options.UseSqlServer(connectionString));

        // Add Serilog
        Log.Logger = new LoggerConfiguration()
            .ReadFrom.Configuration(context.Configuration)
            .Enrich.FromLogContext()
            .WriteTo.Console()
            .CreateLogger();

        services.AddLogging(loggingBuilder =>
            loggingBuilder.AddSerilog(dispose: true));

        // Add custom services
        services.AddScoped<IEmailService, EmailService>();
        services.AddScoped<INotificationService, NotificationService>();
    })
    .Build();

host.Run();

// DbContext placeholder
public class UserDbContext : DbContext
{
    public UserDbContext(DbContextOptions<UserDbContext> options) : base(options) { }
    
    // Add DbSets here
}

// Service interfaces placeholders
public interface IEmailService
{
    Task SendEmailAsync(string to, string subject, string body);
}

public class EmailService : IEmailService
{
    public Task SendEmailAsync(string to, string subject, string body)
    {
        // Implementation using SendGrid or other email service
        return Task.CompletedTask;
    }
}

public interface INotificationService
{
    Task SendNotificationAsync(string userId, string message);
}

public class NotificationService : INotificationService
{
    public Task SendNotificationAsync(string userId, string message)
    {
        // Implementation for push notifications
        return Task.CompletedTask;
    }
}
