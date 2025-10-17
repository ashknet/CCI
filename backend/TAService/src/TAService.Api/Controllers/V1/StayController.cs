using System.Security.Claims;
using MedTravel.Shared.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TransportationAccommodationService.Core.DTOs;

namespace TransportationAccommodationService.Api.Controllers.V1;

[ApiController]
[Route("api/v1/stay")]
[Authorize]
[ApiVersion("1.0")]
public class StayController : ControllerBase
{
    /// <summary>
    /// Search hotels and rentals with advanced filters
    /// </summary>
    [HttpGet("search")]
    public async Task<ActionResult<ApiResponse<List<HotelDto>>>> SearchStay(
        [FromQuery] Guid? nearHospitalId = null,
        [FromQuery] decimal? maxDistance = null,
        [FromQuery] string? costRange = null,
        [FromQuery] string? amenities = null,
        [FromQuery] string? condition = null,
        [FromQuery] int? durationDays = null,
        [FromQuery] DateTime? checkIn = null,
        [FromQuery] DateTime? checkOut = null)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var hotels = new List<HotelDto>
        {
            new(Guid.NewGuid(), "Taj Krishna Hyderabad", "Luxury hotel near Apollo Hospitals",
                "Road No. 1, Banjara Hills", "Hyderabad", 17.4239m, 78.4501m, 5, 4.7m, 850,
                new List<string> { "WiFi", "Pool", "Gym", "Restaurant", "Wheelchair Accessible", "Medical Assistance" },
                3.5m),
            new(Guid.NewGuid(), "Novotel Hyderabad", "Contemporary hotel near hospitals",
                "Hitec City", "Hyderabad", 17.4485m, 78.3908m, 4, 4.5m, 620,
                new List<string> { "WiFi", "Pool", "Restaurant", "Wheelchair Accessible" },
                5.2m)
        };

        // Apply filters
        if (maxDistance.HasValue)
            hotels = hotels.Where(h => h.DistanceToHospitalKm <= maxDistance.Value).ToList();

        if (!string.IsNullOrEmpty(amenities))
        {
            var requiredAmenities = amenities.Split(',').Select(a => a.Trim()).ToList();
            hotels = hotels.Where(h => requiredAmenities.All(ra => h.Amenities.Contains(ra))).ToList();
        }

        return Ok(ApiResponse<List<HotelDto>>.SuccessResponse(hotels, null, correlationId));
    }

    /// <summary>
    /// Get property details
    /// </summary>
    [HttpGet("properties/{propertyId}")]
    public async Task<ActionResult<ApiResponse<object>>> GetProperty(Guid propertyId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var property = new
        {
            id = propertyId,
            name = "Taj Krishna Hyderabad",
            type = "hotel",
            description = "Luxury hotel with medical tourism support",
            address = "Road No. 1, Banjara Hills, Hyderabad",
            latitude = 17.4239,
            longitude = 78.4501,
            starRating = 5,
            averageRating = 4.7,
            totalReviews = 850,
            amenities = new[] {
                "WiFi", "Pool", "Gym", "Restaurant", "Spa",
                "Wheelchair Accessible", "Medical Assistance", "Airport Shuttle"
            },
            distanceToHospital = 3.5,
            nearbyHospitals = new[] {
                new { name = "Apollo Hospitals", distance = 3.5 },
                new { name = "Care Hospitals", distance = 5.0 }
            },
            rooms = new[] {
                new { type = "Deluxe", pricePerNight = 8500, available = 10 },
                new { type = "Suite", pricePerNight = 15000, available = 5 }
            },
            policies = new {
                checkInTime = "14:00",
                checkOutTime = "12:00",
                cancellationPolicy = "Free cancellation up to 24 hours before check-in"
            }
        };

        return Ok(ApiResponse<object>.SuccessResponse(property, null, correlationId));
    }

    /// <summary>
    /// Book accommodation
    /// </summary>
    [HttpPost("book")]
    public async Task<ActionResult<ApiResponse<AccommodationBookingDto>>> BookStay([FromBody] BookAccommodationRequest request)
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
    /// Cancel accommodation booking
    /// </summary>
    [HttpDelete("bookings/{bookingId}/cancel")]
    public async Task<ActionResult<ApiResponse<object>>> CancelBooking(Guid bookingId)
    {
        var correlationId = HttpContext.Items["CorrelationId"]?.ToString();

        var refund = new
        {
            bookingId,
            refundAmount = 80000m,
            cancellationFee = 5000m,
            currency = "INR",
            refundStatus = "processing"
        };

        return Ok(ApiResponse<object>.SuccessResponse(refund, "Booking cancelled", correlationId));
    }
}
