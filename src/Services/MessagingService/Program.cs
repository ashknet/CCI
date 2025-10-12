using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "MessagingService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapPost("/messages/send", async (long fromUserId, long toUserId, string text) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    await conn.ExecuteAsync("INSERT INTO msg.Messages(FromUserId, ToUserId, Text, CreatedAtUtc) VALUES(@fromUserId,@toUserId,@text,SYSUTCDATETIME())", new { fromUserId, toUserId, text });
    return Results.Ok(new { status = "sent" });
});

app.MapGet("/messages/thread", async (long userA, long userB) =>
{
    await using var conn = new SqlConnection(app.Configuration.GetConnectionString("SqlServer") ?? "Server=localhost,1433;Database=master;User Id=sa;Password=Your_strong_password123!;TrustServerCertificate=True;");
    var rows = await conn.QueryAsync("SELECT * FROM msg.Messages WHERE (FromUserId=@userA AND ToUserId=@userB) OR (FromUserId=@userB AND ToUserId=@userA) ORDER BY CreatedAtUtc", new { userA, userB });
    return Results.Ok(rows);
});

app.Run();