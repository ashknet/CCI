using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportationAccommodationService.Core.DTOs;

namespace TransportationAccommodationService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TransportController : ControllerBase
{
    private readonly ILogger<TransportController> _logger;

    public TransportController(ILogger<TransportController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Search flights
    /// </summary>
    [HttpPost("flights/search")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<FlightDto>>>> SearchFlights([FromBody] FlightSearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        // Mock flight data - integrate with actual flight APIs
        var flights = new List<FlightDto>
        {
            new(Guid.NewGuid(), "AI101", "Air India", request.From, request.To,
                request.DepartureDate, request.DepartureDate.AddHours(16),
                85000, "INR", 50, request.FlightClass, true, 960),
            new(Guid.NewGuid(), "EK501", "Emirates", request.From, request.To,
                request.DepartureDate.AddHours(2), request.DepartureDate.AddHours(18),
                95000, "INR", 30, request.FlightClass, true, 960),
            new(Guid.NewGuid(), "QR401", "Qatar Airways", request.From, request.To,
                request.DepartureDate.AddHours(4), request.DepartureDate.AddHours(22),
                78000, "INR", 45, request.FlightClass, false, 1080)
        };

        // Sort by preference
        flights = request.Preference switch
        {
            "cheapest" => flights.OrderBy(f => f.Price).ToList(),
            "fastest" => flights.OrderBy(f => f.DurationMinutes).ToList(),
            _ => flights.OrderByDescending(f => f.IsDirect).ThenBy(f => f.Price).ToList()
        };

        return Ok(ApiResponse<List<FlightDto>>.SuccessResponse(flights, null, correlationId));
    }

    /// <summary>
    /// Search trains
    /// </summary>
    [HttpPost("trains/search")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<TrainDto>>>> SearchTrains([FromBody] TrainSearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        // Mock train data
        var trains = new List<TrainDto>
        {
            new(Guid.NewGuid(), "12345", "Rajdhani Express", request.From, request.To,
                request.DepartureDate, request.DepartureDate.AddHours(24),
                2500, "INR", 100, request.Class),
            new(Guid.NewGuid(), "12346", "Shatabdi Express", request.From, request.To,
                request.DepartureDate.AddHours(2), request.DepartureDate.AddHours(18),
                1800, "INR", 80, request.Class)
        };

        return Ok(ApiResponse<List<TrainDto>>.SuccessResponse(trains, null, correlationId));
    }

    /// <summary>
    /// Book transportation
    /// </summary>
    [HttpPost("book")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<TransportBookingDto>>> BookTransport([FromBody] BookTransportRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var booking = new TransportBookingDto(
            Guid.NewGuid(),
            request.Type,
            "Departure City",
            "Arrival City",
            DateTime.UtcNow.AddDays(10),
            DateTime.UtcNow.AddDays(10).AddHours(16),
            85000,
            "INR",
            "confirmed",
            $"TRN{Guid.NewGuid().ToString("N")[..8].ToUpper()}"
        );

        return Ok(ApiResponse<TransportBookingDto>.SuccessResponse(booking, "Transport booked successfully", correlationId));
    }

    /// <summary>
    /// Get my transport bookings
    /// </summary>
    [HttpGet("bookings")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<TransportBookingDto>>>> GetMyBookings()
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var bookings = new List<TransportBookingDto>();
        return Ok(ApiResponse<List<TransportBookingDto>>.SuccessResponse(bookings, null, correlationId));
    }

    /// <summary>
    /// Cancel transport booking
    /// </summary>
    [HttpDelete("bookings/{id}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<object>>> CancelBooking(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        return Ok(ApiResponse<object>.SuccessResponse(null, "Booking cancelled successfully", correlationId));
    }
}
