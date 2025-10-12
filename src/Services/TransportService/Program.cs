using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "TransportService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/transport/options", async (string from, string to, DateTime date) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    using var multi = await conn.QueryMultipleAsync(
        sql: "transport.sp_GetOptions",
        commandType: CommandType.StoredProcedure,
        param: new { FromCity = from, ToCity = to, DepartDate = date.Date }
    );
    var flights = await multi.ReadAsync();
    var trains = await multi.ReadAsync();
    var buses = await multi.ReadAsync();
    return Results.Ok(new { flights, trains, buses });
});

app.MapGet("/transport/redirect/bus", (string from, string to, DateTime date) =>
{
    var url = $"https://www.redbus.in/search?fromCity={Uri.EscapeDataString(from)}&toCity={Uri.EscapeDataString(to)}&onward={date:yyyy-MM-dd}";
    return Results.Ok(new { url });
});

app.MapGet("/transport/redirect/train", (string from, string to, DateTime date) =>
{
    var url = $"https://www.irctc.co.in/nget/train-search"; // cannot deep link reliably
    return Results.Ok(new { url });
});

app.Run();