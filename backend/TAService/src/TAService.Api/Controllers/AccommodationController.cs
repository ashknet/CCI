using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportationAccommodationService.Core.DTOs;

namespace TransportationAccommodationService.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AccommodationController : ControllerBase
{
    /// <summary>
    /// Search hotels
    /// </summary>
    [HttpPost("search")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<HotelDto>>>> SearchHotels([FromBody] HotelSearchRequest request)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var hotels = new List<HotelDto>
        {
            new(Guid.NewGuid(), "Taj Krishna Hyderabad", "Luxury hotel near Apollo Hospitals",
                "Road No. 1, Banjara Hills", request.City, 17.4239m, 78.4501m,
                5, 4.7m, 850, new List<string> { "WiFi", "Pool", "Gym", "Restaurant", "Wheelchair Accessible" }, 3.5m),
            new(Guid.NewGuid(), "Novotel Hyderabad", "Contemporary hotel near Jubilee Hills",
                "Hitec City", request.City, 17.4485m, 78.3908m,
                4, 4.5m, 620, new List<string> { "WiFi", "Pool", "Restaurant" }, 5.2m)
        };

        if (request.MaxPrice.HasValue)
            hotels = hotels.Where(h => h.AverageRating <= request.MaxPrice.Value).ToList();

        return Ok(ApiResponse<List<HotelDto>>.SuccessResponse(hotels, null, correlationId));
    }

    /// <summary>
    /// Get hotel details
    /// </summary>
    [HttpGet("{id}")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<HotelDto>>> GetHotel(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var hotel = new HotelDto(
            id, "Taj Krishna Hyderabad", "Luxury hotel near Apollo Hospitals",
            "Road No. 1, Banjara Hills", "Hyderabad", 17.4239m, 78.4501m,
            5, 4.7m, 850, new List<string> { "WiFi", "Pool", "Gym", "Restaurant", "Wheelchair Accessible" }, 3.5m
        );

        return Ok(ApiResponse<HotelDto>.SuccessResponse(hotel, null, correlationId));
    }

    /// <summary>
    /// Get hotel rooms
    /// </summary>
    [HttpGet("{id}/rooms")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<HotelRoomDto>>>> GetHotelRooms(Guid id)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();
        
        var rooms = new List<HotelRoomDto>
        {
            new(Guid.NewGuid(), id, "Deluxe Room", "Spacious room with city view",
                8500, "INR", 2, 10, new List<string> { "WiFi", "TV", "AC", "Mini Bar" }),
            new(Guid.NewGuid(), id, "Suite", "Luxury suite with separate living area",
                15000, "INR", 4, 5, new List<string> { "WiFi", "TV", "AC", "Mini Bar", "Jacuzzi" })
        };

        return Ok(ApiResponse<List<HotelRoomDto>>.SuccessResponse(rooms, null, correlationId));
    }

    /// <summary>
    /// Book accommodation
    /// </summary>
    [HttpPost("book")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<AccommodationBookingDto>>> BookAccommodation([FromBody] BookAccommodationRequest request)
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var nights = (request.CheckOutDate - request.CheckInDate).Days;
        var booking = new AccommodationBookingDto(
            Guid.NewGuid(),
            request.HotelId,
            "Taj Krishna Hyderabad",
            request.RoomId,
            "Deluxe Room",
            request.CheckInDate,
            request.CheckOutDate,
            request.NumberOfGuests,
            request.NumberOfRooms,
            8500 * nights * request.NumberOfRooms,
            "INR",
            "confirmed",
            $"HTL{Guid.NewGuid().ToString("N")[..8].ToUpper()}"
        );

        return Ok(ApiResponse<AccommodationBookingDto>.SuccessResponse(booking, "Accommodation booked successfully", correlationId));
    }

    /// <summary>
    /// Get my accommodation bookings
    /// </summary>
    [HttpGet("bookings")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<List<AccommodationBookingDto>>>> GetMyBookings()
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var bookings = new List<AccommodationBookingDto>();
        return Ok(ApiResponse<List<AccommodationBookingDto>>.SuccessResponse(bookings, null, correlationId));
    }

    /// <summary>
    /// Get cost breakdown for user
    /// </summary>
    [HttpGet("cost-breakdown")]
    [Authorize]
    public async Task<ActionResult<ApiResponse<CostBreakdownDto>>> GetCostBreakdown()
    {
        var userId = Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var breakdown = new CostBreakdownDto(
            Guid.NewGuid(),
            userId,
            null,
            50000,
            85000,
            85000,
            220000,
            "INR",
            DateTime.UtcNow
        );

        return Ok(ApiResponse<CostBreakdownDto>.SuccessResponse(breakdown, null, correlationId));
    }
}
