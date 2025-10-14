namespace TransportationAccommodationService.Core.Entities;

public class Hotel
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string Country { get; set; } = string.Empty;
    public decimal Latitude { get; set; }
    public decimal Longitude { get; set; }
    public decimal StarRating { get; set; }
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public string Phone { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public List<string> Amenities { get; set; } = new();
    public decimal DistanceToHospitalKm { get; set; }
    public Guid? NearbyHospitalId { get; set; }
}

public class HotelRoom
{
    public Guid Id { get; set; }
    public Guid HotelId { get; set; }
    public string RoomType { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public decimal PricePerNight { get; set; }
    public string Currency { get; set; } = "USD";
    public int MaxOccupancy { get; set; }
    public int AvailableRooms { get; set; }
    public List<string> Amenities { get; set; } = new();
}

public class AccommodationBooking
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public Guid HotelId { get; set; }
    public Guid RoomId { get; set; }
    public DateTime CheckInDate { get; set; }
    public DateTime CheckOutDate { get; set; }
    public int NumberOfGuests { get; set; }
    public int NumberOfRooms { get; set; }
    public decimal TotalPrice { get; set; }
    public string Currency { get; set; } = "USD";
    public string Status { get; set; } = "pending";
    public string GuestName { get; set; } = string.Empty;
    public string GuestEmail { get; set; } = string.Empty;
    public string GuestPhone { get; set; } = string.Empty;
    public string BookingReference { get; set; } = string.Empty;
    public string SpecialRequests { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? CancelledAt { get; set; }
}

public class CostBreakdown
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public Guid? AppointmentId { get; set; }
    public decimal MedicalCost { get; set; }
    public decimal TransportCost { get; set; }
    public decimal AccommodationCost { get; set; }
    public decimal TotalCost { get; set; }
    public string Currency { get; set; } = "USD";
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
