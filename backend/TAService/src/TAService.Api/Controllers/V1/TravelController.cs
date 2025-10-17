using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportationAccommodationService.Core.DTOs;

namespace TransportationAccommodationService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/travel")]
[Authorize]
[ApiVersion("1.0")]
public class TravelController : ControllerBase
{
    /// <summary>
    /// Search flights
    /// </summary>
    [HttpGet("flights/search")]
    public async Task<ActionResult<ApiResponse<List<FlightDto>>>> SearchFlights(
        [FromQuery] string from,
        [FromQuery] string to,
        [FromQuery] DateTime date,
        [FromQuery] DateTime? returnDate = null,
        [FromQuery] int passengers = 1,
        [FromQuery] string flightClass = "Economy")
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var flights = GenerateMockFlights(from, to, date, flightClass);
        return Ok(ApiResponse<List<FlightDto>>.SuccessResponse(flights, null, correlationId));
    }

    /// <summary>
    /// Get flight recommendations based on appointment date
    /// </summary>
    [HttpGet("flights/recommendations")]
    public async Task<ActionResult<ApiResponse<object>>> GetFlightRecommendations(
        [FromQuery] DateTime appointmentDate,
        [FromQuery] string preference = "best")
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var recommendations = new
        {
            appointmentDate,
            preference,
            bestFlight = new {
                flightNumber = "AI101",
                price = 85000,
                duration = 960,
                isDirect = true,
                score = 95
            },
            cheapestFlight = new {
                flightNumber = "QR401",
                price = 78000,
                duration = 1080,
                isDirect = false,
                score = 85
            },
            fastestFlight = new {
                flightNumber = "EK501",
                price = 95000,
                duration = 900,
                isDirect = true,
                score = 90
            },
            recommendedDeparture = appointmentDate.AddDays(-1),
            recommendedReturn = appointmentDate.AddDays(7),
            tips = new[] {
                "Book flights at least 2 weeks in advance for better prices",
                "Arrive 1 day before appointment to account for any travel delays",
                "Plan return after 5-7 days for post-operative care"
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(recommendations, null, correlationId));
    }

    /// <summary>
    /// Book flight
    /// </summary>
    [HttpPost("flights/book")]
    public async Task<ActionResult<ApiResponse<TransportBookingDto>>> BookFlight([FromBody] BookTransportRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var booking = new TransportBookingDto(
            Guid.NewGuid(),
            "flight",
            "JFK",
            "HYD",
            DateTime.UtcNow.AddDays(10),
            DateTime.UtcNow.AddDays(10).AddHours(16),
            85000,
            "INR",
            "confirmed",
            $"FLT{Guid.NewGuid().ToString("N")[..8].ToUpper()}"
        );

        return Ok(ApiResponse<TransportBookingDto>.SuccessResponse(booking, "Flight booked successfully", correlationId));
    }

    /// <summary>
    /// Get flight itinerary details
    /// </summary>
    [HttpGet("flights/itineraries/{itineraryId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetItinerary(Guid itineraryId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var itinerary = new
        {
            id = itineraryId,
            pnr = $"PNR{Guid.NewGuid().ToString("N")[..6].ToUpper()}",
            bookingReference = $"AI{Guid.NewGuid().ToString("N")[..8].ToUpper()}",
            status = "confirmed",
            outbound = new {
                flightNumber = "AI101",
                airline = "Air India",
                departure = "JFK - 10:00 AM",
                arrival = "HYD - 02:00 AM (+1)",
                duration = "16h",
                terminal = "Terminal 4"
            },
            passenger = new {
                name = "John Doe",
                email = "john@example.com",
                phone = "+1-555-0100"
            },
            totalCost = 85000,
            currency = "INR",
            eTicketUrl = "/tickets/itinerary-" + itineraryId
        };

        return Ok(ApiResponse<object>.SuccessResponse(itinerary, null, correlationId));
    }

    /// <summary>
    /// Cancel flight booking
    /// </summary>
    [HttpDelete("flights/bookings/{bookingId}/cancel")]
    public async Task<ActionResult<ApiResponse<object>>> CancelFlightBooking(Guid bookingId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var refund = new
        {
            bookingId,
            refundAmount = 76500m,
            cancellationFee = 8500m,
            currency = "INR",
            refundMethod = "Original payment method",
            processedIn = "5-7 business days"
        };

        return Ok(ApiResponse<object>.SuccessResponse(refund, "Booking cancelled, refund initiated", correlationId));
    }

    /// <summary>
    /// Search trains
    /// </summary>
    [HttpGet("trains/search")]
    public async Task<ActionResult<ApiResponse<List<TrainDto>>>> SearchTrains(
        [FromQuery] string from,
        [FromQuery] string to,
        [FromQuery] DateTime date,
        [FromQuery] int passengers = 1,
        [FromQuery] string trainClass = "Sleeper")
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var trains = GenerateMockTrains(from, to, date, trainClass);
        return Ok(ApiResponse<List<TrainDto>>.SuccessResponse(trains, null, correlationId));
    }

    /// <summary>
    /// Search buses
    /// </summary>
    [HttpGet("buses/search")]
    public async Task<ActionResult<ApiResponse<List<object>>>> SearchBuses(
        [FromQuery] string from,
        [FromQuery] string to,
        [FromQuery] DateTime date)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var buses = new List<object>
        {
            new {
                id = Guid.NewGuid(),
                operatorName = "VRL Travels",
                busType = "Sleeper AC",
                departureTime = date.AddHours(22),
                arrivalTime = date.AddHours(34),
                price = 1200m,
                currency = "INR",
                seatsAvailable = 25
            }
        };

        return Ok(ApiResponse<List<object>>.SuccessResponse(buses, null, correlationId));
    }

    /// <summary>
    /// Book train (or get redirect token for partner integration)
    /// </summary>
    [HttpPost("trains/book")]
    public async Task<ActionResult<ApiResponse<object>>> BookTrain([FromBody] object bookingRequest)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var result = new
        {
            bookingType = "partner_redirect",
            redirectUrl = "https://www.irctc.co.in/nget/booking",
            redirectToken = Guid.NewGuid().ToString(),
            expiresIn = 300,
            instructions = "You will be redirected to IRCTC for booking confirmation"
        };

        return Ok(ApiResponse<object>.SuccessResponse(result, "Redirect token generated", correlationId));
    }

    /// <summary>
    /// Get booking details by mode and ID
    /// </summary>
    [HttpGet("{mode}/bookings/{bookingId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetBooking(string mode, Guid bookingId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var booking = new
        {
            id = bookingId,
            mode,
            status = "confirmed",
            bookingReference = $"{mode.ToUpper()}{Guid.NewGuid().ToString("N")[..8].ToUpper()}",
            from = "Origin",
            to = "Destination",
            departureTime = DateTime.UtcNow.AddDays(10),
            totalCost = 2500m,
            currency = "INR"
        };

        return Ok(ApiResponse<object>.SuccessResponse(booking, null, correlationId));
    }

    private List<FlightDto> GenerateMockFlights(string from, string to, DateTime date, string flightClass)
    {
        return new List<FlightDto>
        {
            new(Guid.NewGuid(), "AI101", "Air India", from, to, date, date.AddHours(16), 85000, "INR", 50, flightClass, true, 960),
            new(Guid.NewGuid(), "EK501", "Emirates", from, to, date.AddHours(2), date.AddHours(18), 95000, "INR", 30, flightClass, true, 960),
            new(Guid.NewGuid(), "QR401", "Qatar Airways", from, to, date.AddHours(4), date.AddHours(22), 78000, "INR", 45, flightClass, false, 1080)
        };
    }

    private List<TrainDto> GenerateMockTrains(string from, string to, DateTime date, string trainClass)
    {
        return new List<TrainDto>
        {
            new(Guid.NewGuid(), "12345", "Rajdhani Express", from, to, date, date.AddHours(24), 2500, "INR", 100, trainClass),
            new(Guid.NewGuid(), "12346", "Shatabdi Express", from, to, date.AddHours(2), date.AddHours(18), 1800, "INR", 80, trainClass)
        };
    }
}
