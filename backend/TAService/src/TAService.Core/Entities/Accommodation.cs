namespace TransportationAccommodationService.Core.Entities;

public class Hotel
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public Guid CityId { get; set; }
    public Guid CountryId { get; set; }
    public string PostalCode { get; set; } = string.Empty;
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public string Phone { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Website { get; set; } = string.Empty;
    public int? StarRating { get; set; }
    public decimal AverageRating { get; set; }
    public int TotalReviews { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
    
    // Navigation properties
    public City City { get; set; } = null!;
    public Country Country { get; set; } = null!;
    public ICollection<HotelRoom> Rooms { get; set; } = new List<HotelRoom>();
    public ICollection<AccommodationBooking> Bookings { get; set; } = new List<AccommodationBooking>();
}

public class HotelRoom
{
    public Guid Id { get; set; }
    public Guid HotelId { get; set; }
    public string RoomType { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public decimal PricePerNight { get; set; }
    public Guid CurrencyId { get; set; }
    public int? MaxOccupancy { get; set; }
    public int? TotalRooms { get; set; }
    public int? AvailableRooms { get; set; }
    public string? Amenities { get; set; } // JSON string
    public string? Images { get; set; } // JSON string
    public bool IsActive { get; set; } = true;
    
    // Navigation properties
    public Hotel Hotel { get; set; } = null!;
    public Currency Currency { get; set; } = null!;
    public ICollection<AccommodationBooking> Bookings { get; set; } = new List<AccommodationBooking>();
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
    public int NumberOfRooms { get; set; } = 1;
    public decimal TotalPrice { get; set; }
    public Guid CurrencyId { get; set; }
    public string Status { get; set; } = "pending";
    public string? BookingReference { get; set; }
    public string? GuestName { get; set; }
    public string? GuestEmail { get; set; }
    public string? GuestPhone { get; set; }
    public string? SpecialRequests { get; set; }
    public string? PaymentId { get; set; }
    public bool IsPaid { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
    
    // Navigation properties
    public Hotel Hotel { get; set; } = null!;
    public HotelRoom Room { get; set; } = null!;
    public Currency Currency { get; set; } = null!;
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
