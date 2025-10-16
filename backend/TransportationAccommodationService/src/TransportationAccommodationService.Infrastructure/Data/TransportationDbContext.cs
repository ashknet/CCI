using Microsoft.EntityFrameworkCore;
using TransportationAccommodationService.Core.Entities;

namespace TransportationAccommodationService.Infrastructure.Data;

public class TransportationDbContext : DbContext
{
    public TransportationDbContext(DbContextOptions<TransportationDbContext> options) : base(options) { }

    public DbSet<Flight> Flights => Set<Flight>();
    public DbSet<Train> Trains => Set<Train>();
    public DbSet<TransportBooking> TransportBookings => Set<TransportBooking>();
    public DbSet<Hotel> Hotels => Set<Hotel>();
    public DbSet<HotelRoom> HotelRooms => Set<HotelRoom>();
    public DbSet<AccommodationBooking> AccommodationBookings => Set<AccommodationBooking>();
    public DbSet<CostBreakdown> CostBreakdowns => Set<CostBreakdown>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Flight>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Price).HasPrecision(18, 2);
            entity.HasIndex(e => new { e.DepartureAirport, e.ArrivalAirport, e.DepartureTime });
        });

        modelBuilder.Entity<Train>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Price).HasPrecision(18, 2);
            entity.HasIndex(e => new { e.DepartureStation, e.ArrivalStation, e.DepartureTime });
        });

        modelBuilder.Entity<TransportBooking>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TotalPrice).HasPrecision(18, 2);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.Status, e.CreatedAt });
        });

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Latitude).HasPrecision(10, 7);
            entity.Property(e => e.Longitude).HasPrecision(10, 7);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
            entity.HasIndex(e => e.City);
            entity.HasIndex(e => e.NearbyHospitalId);
        });

        modelBuilder.Entity<HotelRoom>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.PricePerNight).HasPrecision(18, 2);
            entity.HasIndex(e => e.HotelId);
        });

        modelBuilder.Entity<AccommodationBooking>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TotalPrice).HasPrecision(18, 2);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.HotelId, e.CheckInDate, e.CheckOutDate });
        });

        modelBuilder.Entity<CostBreakdown>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.MedicalCost).HasPrecision(18, 2);
            entity.Property(e => e.TransportCost).HasPrecision(18, 2);
            entity.Property(e => e.AccommodationCost).HasPrecision(18, 2);
            entity.Property(e => e.TotalCost).HasPrecision(18, 2);
            entity.HasIndex(e => e.UserId);
        });

        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        // Seed sample flights
        modelBuilder.Entity<Flight>().HasData(
            new Flight
            {
                Id = Guid.NewGuid(),
                FlightNumber = "AI101",
                Airline = "Air India",
                DepartureAirport = "JFK",
                ArrivalAirport = "HYD",
                DepartureTime = DateTime.UtcNow.AddDays(10),
                ArrivalTime = DateTime.UtcNow.AddDays(10).AddHours(16),
                Price = 85000,
                Currency = "INR",
                AvailableSeats = 50,
                FlightClass = "Economy",
                IsDirect = true,
                DurationMinutes = 960
            }
        );

        // Seed sample hotels
        modelBuilder.Entity<Hotel>().HasData(
            new Hotel
            {
                Id = Guid.NewGuid(),
                Name = "Taj Krishna Hyderabad",
                Description = "Luxury hotel near Apollo Hospitals",
                Address = "Road No. 1, Banjara Hills",
                City = "Hyderabad",
                Country = "India",
                Latitude = 17.4239m,
                Longitude = 78.4501m,
                StarRating = 5,
                AverageRating = 4.7m,
                TotalReviews = 850,
                Phone = "+91-40-66293939",
                Email = "tajkrishna@tajhotels.com",
                DistanceToHospitalKm = 3.5m
            }
        );
    }
}
