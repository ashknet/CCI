using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "CostService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/costs/estimate", async (string disease, decimal travel, int nights, decimal hotelPerNight) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var row = await conn.QuerySingleOrDefaultAsync(
        sql: "costs.sp_Estimate",
        commandType: CommandType.StoredProcedure,
        param: new { Disease = disease, Travel = travel, Nights = nights, HotelPerNight = hotelPerNight }
    );
    return Results.Ok(row);
});

app.Run();