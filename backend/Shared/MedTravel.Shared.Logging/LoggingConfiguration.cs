using Microsoft.Extensions.Configuration;
using Serilog;
using Serilog.Events;

namespace MedTravel.Shared.Logging;

public static class LoggingConfiguration
{
    public static ILogger CreateLogger(IConfiguration configuration, string serviceName)
    {
        return new LoggerConfiguration()
            .MinimumLevel.Information()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .MinimumLevel.Override("System", LogEventLevel.Warning)
            .Enrich.FromLogContext()
            .Enrich.WithProperty("ServiceName", serviceName)
            .Enrich.WithMachineName()
            .Enrich.WithEnvironmentName()
            .Enrich.WithThreadId()
            .WriteTo.Console(outputTemplate: "[{Timestamp:yyyy-MM-dd HH:mm:ss} {Level:u3}] [{ServiceName}] {Message:lj}{NewLine}{Exception}")
            .WriteTo.File(
                path: $"logs/{serviceName}-.log",
                rollingInterval: RollingInterval.Day,
                retainedFileCountLimit: 7,
                outputTemplate: "[{Timestamp:yyyy-MM-dd HH:mm:ss} {Level:u3}] [{ServiceName}] [{SourceContext}] {Message:lj}{NewLine}{Exception}")
            .CreateLogger();
    }
}
