namespace TransportationAccommodationService.Core.Entities;

// These entities are shared across services and should be in a shared library
// For now, we'll define them here to match the database schema

public class Country
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty; // ISO country code (e.g., "IN", "US")
    public string Name { get; set; } = string.Empty;
    public string Region { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    public ICollection<City> Cities { get; set; } = new List<City>();
    public ICollection<Hotel> Hotels { get; set; } = new List<Hotel>();
}

public class City
{
    public Guid Id { get; set; }
    public Guid CountryId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string State { get; set; } = string.Empty;
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public bool IsActive { get; set; } = true;

    public Country Country { get; set; } = null!;
    public ICollection<Hotel> Hotels { get; set; } = new List<Hotel>();
}

public class Currency
{
    public Guid Id { get; set; }
    public string Code { get; set; } = string.Empty; // USD, EUR, INR, etc.
    public string Name { get; set; } = string.Empty;
    public string Symbol { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;

    public ICollection<HotelRoom> HotelRooms { get; set; } = new List<HotelRoom>();
    public ICollection<AccommodationBooking> AccommodationBookings { get; set; } = new List<AccommodationBooking>();
}
