using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "AccommodationService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/accommodation/list", async (string city, long? hospitalId, decimal? maxPrice) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var rows = await conn.QueryAsync(
        sql: "accom.sp_Search",
        commandType: CommandType.StoredProcedure,
        param: new { City = city, HospitalId = hospitalId, MaxPrice = maxPrice }
    );
    return Results.Ok(rows);
});

app.Run();