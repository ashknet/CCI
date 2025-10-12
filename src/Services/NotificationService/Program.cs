using MassTransit;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddMassTransit(x =>
{
    x.UsingRabbitMq((context, cfg) =>
    {
        cfg.Host(builder.Configuration.GetValue<string>("Rabbit:Host") ?? "rabbitmq", h =>
        {
            h.Username(builder.Configuration.GetValue<string>("Rabbit:User") ?? "guest");
            h.Password(builder.Configuration.GetValue<string>("Rabbit:Pass") ?? "guest");
        });
    });
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "NotificationService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.Run();