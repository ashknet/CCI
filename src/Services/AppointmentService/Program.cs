using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "AppointmentService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/appointments/availability", async (long doctorId, DateTime from, DateTime to) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var rows = await conn.QueryAsync(
        sql: "appt.sp_GetAvailability",
        commandType: CommandType.StoredProcedure,
        param: new { DoctorId = doctorId, From = from, To = to }
    );
    return Results.Ok(rows);
});

app.MapPost("/appointments/book", async (long doctorId, long userId, DateTime startAtUtc, DateTime endAtUtc) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    try
    {
        await conn.ExecuteAsync(
            sql: "appt.sp_BookAppointment",
            commandType: CommandType.StoredProcedure,
            param: new { DoctorId = doctorId, UserId = userId, StartAtUtc = startAtUtc, EndAtUtc = endAtUtc }
        );
        return Results.Ok(new { status = "confirmed" });
    }
    catch (SqlException ex)
    {
        return Results.BadRequest(new { error = ex.Message });
    }
});

app.MapGet("/appointments/{userId:long}", async (long userId) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var rows = await conn.QueryAsync("SELECT * FROM appt.Appointments WHERE UserId=@userId ORDER BY StartAtUtc DESC", new { userId });
    return Results.Ok(rows);
});

app.Run();