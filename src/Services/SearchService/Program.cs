using System.Net.Http.Json;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient("providers", c => c.BaseAddress = new Uri(builder.Configuration["Services:ProviderService"] ?? "http://providerservice:8082"));

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "SearchService", Version = "v1" });
});

var app = builder.Build();
app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapGet("/search", async (HttpContext http, IHttpClientFactory factory) =>
{
    var q = http.Request.QueryString.Value;
    var client = factory.CreateClient("providers");
    var providers = await client.GetFromJsonAsync<object>($"/providers/search{q}");
    return Results.Ok(new { providers });
});

app.Run();