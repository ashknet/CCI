namespace TransportationAccommodationService.Core.Entities;

public class Flight
{
    public Guid Id { get; set; }
    public string FlightNumber { get; set; } = string.Empty;
    public string Airline { get; set; } = string.Empty;
    public string DepartureAirport { get; set; } = string.Empty;
    public string ArrivalAirport { get; set; } = string.Empty;
    public DateTime DepartureTime { get; set; }
    public DateTime ArrivalTime { get; set; }
    public decimal Price { get; set; }
    public string Currency { get; set; } = "USD";
    public int AvailableSeats { get; set; }
    public string FlightClass { get; set; } = "Economy";
    public bool IsDirect { get; set; }
    public int DurationMinutes { get; set; }
}

public class Train
{
    public Guid Id { get; set; }
    public string TrainNumber { get; set; } = string.Empty;
    public string TrainName { get; set; } = string.Empty;
    public string DepartureStation { get; set; } = string.Empty;
    public string ArrivalStation { get; set; } = string.Empty;
    public DateTime DepartureTime { get; set; }
    public DateTime ArrivalTime { get; set; }
    public decimal Price { get; set; }
    public string Currency { get; set; } = "INR";
    public int AvailableSeats { get; set; }
    public string Class { get; set; } = "Sleeper";
}

public class TransportBooking
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    public string Type { get; set; } = string.Empty; // flight, train, bus
    public string ReferenceId { get; set; } = string.Empty;
    public string From { get; set; } = string.Empty;
    public string To { get; set; } = string.Empty;
    public DateTime DepartureTime { get; set; }
    public DateTime ArrivalTime { get; set; }
    public decimal TotalPrice { get; set; }
    public string Currency { get; set; } = "USD";
    public string Status { get; set; } = "pending";
    public string PassengerName { get; set; } = string.Empty;
    public string PassengerEmail { get; set; } = string.Empty;
    public string PassengerPhone { get; set; } = string.Empty;
    public string BookingReference { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? CancelledAt { get; set; }
}
