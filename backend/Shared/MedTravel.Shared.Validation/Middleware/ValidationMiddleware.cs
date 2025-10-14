using System.Net;
using System.Text.Json;
using MedTravel.Shared.Exceptions;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Http;

namespace MedTravel.Shared.Validation.Middleware;

public class ValidationMiddleware
{
    private readonly RequestDelegate _next;

    public ValidationMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (BusinessException ex)
        {
            await HandleBusinessExceptionAsync(context, ex);
        }
        catch (Exception ex)
        {
            await HandleExceptionAsync(context, ex);
        }
    }

    private static Task HandleBusinessExceptionAsync(HttpContext context, BusinessException exception)
    {
        context.Response.ContentType = "application/json";
        context.Response.StatusCode = exception.StatusCode;

        var correlationId = context.Items["CorrelationId"]?.ToString();
        var response = ApiResponse<object>.ErrorResponse(exception.Message, exception.Errors, correlationId);

        return context.Response.WriteAsync(JsonSerializer.Serialize(response));
    }

    private static Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/json";
        context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;

        var correlationId = context.Items["CorrelationId"]?.ToString();
        var response = ApiResponse<object>.ErrorResponse(
            "An internal server error occurred.",
            new List<string> { exception.Message },
            correlationId
        );

        return context.Response.WriteAsync(JsonSerializer.Serialize(response));
    }
}
