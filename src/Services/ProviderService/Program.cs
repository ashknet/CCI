using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "ProviderService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/providers/search", async (HttpContext http) =>
{
    string? q = http.Request.Query["q"];
    string? hospital = http.Request.Query["hospital"]; 
    string? doctor = http.Request.Query["doctor"]; 
    string? city = http.Request.Query["city"]; 
    string? disease = http.Request.Query["disease"]; 

    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var results = await conn.QueryAsync(
        sql: "provider.sp_SearchProviders",
        commandType: CommandType.StoredProcedure,
        param: new { q, hospital, doctor, city, disease }
    );
    return Results.Ok(results);
});

app.Run();