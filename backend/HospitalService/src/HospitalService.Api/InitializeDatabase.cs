using Microsoft.EntityFrameworkCore;
using HospitalService.Infrastructure.Data;
using Serilog;

namespace HospitalService.Api;

public static class DatabaseInitializer
{
    public static async Task InitializeDatabaseAsync(IServiceProvider serviceProvider)
    {
        using var scope = serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<HospitalDbContext>();
        
        try
        {
            // Test database connection
            Log.Information("Testing database connection...");
            await context.Database.OpenConnectionAsync();
            Log.Information("Database connection successful!");
            
            // Test if we can access the Hospitals table
            Log.Information("Testing Hospitals table access...");
            var hospitalCount = await context.Hospitals.CountAsync();
            Log.Information("Found {HospitalCount} hospitals in the database.", hospitalCount);
            
            // Test raw SQL to verify schema
            Log.Information("Testing raw SQL query...");
            var rawCount = await context.Database.SqlQueryRaw<int>("SELECT COUNT(*) FROM Hospital.Hospitals").FirstAsync();
            Log.Information("Raw SQL query found {RawCount} hospitals in Hospital.Hospitals table.", rawCount);
            
        }
        catch (Exception ex)
        {
            Log.Error(ex, "Error initializing database: {ErrorMessage}", ex.Message);
            throw;
        }
    }
}
