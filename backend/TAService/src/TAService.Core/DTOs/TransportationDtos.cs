namespace TransportationAccommodationService.Core.DTOs;

public record FlightSearchRequest(
    string From,
    string To,
    DateTime DepartureDate,
    DateTime? ReturnDate,
    int Passengers,
    string FlightClass = "Economy",
    string Preference = "cheapest" // cheapest, fastest, best
);

public record FlightDto(
    Guid Id,
    string FlightNumber,
    string Airline,
    string DepartureAirport,
    string ArrivalAirport,
    DateTime DepartureTime,
    DateTime ArrivalTime,
    decimal Price,
    string Currency,
    int AvailableSeats,
    string FlightClass,
    bool IsDirect,
    int DurationMinutes
);

public record TrainSearchRequest(
    string From,
    string To,
    DateTime DepartureDate,
    int Passengers,
    string Class = "Sleeper"
);

public record TrainDto(
    Guid Id,
    string TrainNumber,
    string TrainName,
    string DepartureStation,
    string ArrivalStation,
    DateTime DepartureTime,
    DateTime ArrivalTime,
    decimal Price,
    string Currency,
    int AvailableSeats,
    string Class
);

public record BookTransportRequest(
    string Type,
    Guid ReferenceId,
    string PassengerName,
    string PassengerEmail,
    string PassengerPhone
);

public record TransportBookingDto(
    Guid Id,
    string Type,
    string From,
    string To,
    DateTime DepartureTime,
    DateTime ArrivalTime,
    decimal TotalPrice,
    string Currency,
    string Status,
    string BookingReference
);

public record HotelSearchRequest(
    string City,
    Guid? NearHospitalId,
    DateTime CheckIn,
    DateTime CheckOut,
    int Guests,
    int Rooms = 1,
    decimal? MaxPrice = null
);

public record HotelDto(
    Guid Id,
    string Name,
    string Description,
    string Address,
    string City,
    decimal Latitude,
    decimal Longitude,
    decimal StarRating,
    decimal AverageRating,
    int TotalReviews,
    List<string> Amenities,
    decimal DistanceToHospitalKm
);

public record HotelRoomDto(
    Guid Id,
    Guid HotelId,
    string RoomType,
    string Description,
    decimal PricePerNight,
    string Currency,
    int MaxOccupancy,
    int AvailableRooms,
    List<string> Amenities
);

public record BookAccommodationRequest(
    Guid HotelId,
    Guid RoomId,
    DateTime CheckInDate,
    DateTime CheckOutDate,
    int NumberOfGuests,
    int NumberOfRooms,
    string GuestName,
    string GuestEmail,
    string GuestPhone,
    string? SpecialRequests
);

public record AccommodationBookingDto(
    Guid Id,
    Guid HotelId,
    string HotelName,
    Guid RoomId,
    string RoomType,
    DateTime CheckInDate,
    DateTime CheckOutDate,
    int NumberOfGuests,
    int NumberOfRooms,
    decimal TotalPrice,
    string Currency,
    string Status,
    string BookingReference
);

public record CostBreakdownDto(
    Guid Id,
    Guid UserId,
    Guid? AppointmentId,
    decimal MedicalCost,
    decimal TransportCost,
    decimal AccommodationCost,
    decimal TotalCost,
    string Currency,
    DateTime CreatedAt
);
