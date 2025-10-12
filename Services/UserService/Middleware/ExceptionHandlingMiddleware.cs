using System.Net;
using System.Text.Json;
using UserService.DTOs;

namespace UserService.Middleware;

public class ExceptionHandlingMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<ExceptionHandlingMiddleware> _logger;

    public ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unhandled exception occurred");
            await HandleExceptionAsync(context, ex);
        }
    }

    private static Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        var code = HttpStatusCode.InternalServerError;
        var result = string.Empty;

        switch (exception)
        {
            case ArgumentNullException _:
            case ArgumentException _:
                code = HttpStatusCode.BadRequest;
                break;
            case UnauthorizedAccessException _:
                code = HttpStatusCode.Unauthorized;
                break;
            case KeyNotFoundException _:
                code = HttpStatusCode.NotFound;
                break;
        }

        var response = new ApiResponse<object>
        {
            Success = false,
            Message = "An error occurred processing your request",
            Errors = new List<string> { exception.Message }
        };

        result = JsonSerializer.Serialize(response);
        context.Response.ContentType = "application/json";
        context.Response.StatusCode = (int)code;
        return context.Response.WriteAsync(result);
    }
}
