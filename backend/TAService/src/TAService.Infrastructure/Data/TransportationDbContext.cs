using Microsoft.EntityFrameworkCore;
using TransportationAccommodationService.Core.Entities;

namespace TransportationAccommodationService.Infrastructure.Data;

public class TransportationDbContext : DbContext
{
    public TransportationDbContext(DbContextOptions<TransportationDbContext> options) : base(options) { }

    // TAService schema entities
    public DbSet<Hotel> Hotels => Set<Hotel>();
    public DbSet<HotelRoom> HotelRooms => Set<HotelRoom>();
    public DbSet<AccommodationBooking> AccommodationBookings => Set<AccommodationBooking>();
    
    // Metadata schema entities
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<Currency> Currencies => Set<Currency>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("TAService");
        base.OnModelCreating(modelBuilder);

        // Configure Metadata schema entities
        modelBuilder.Entity<Country>().ToTable("Countries", "Metadata");
        modelBuilder.Entity<City>().ToTable("Cities", "Metadata");
        modelBuilder.Entity<Currency>().ToTable("Currencies", "Metadata");

        modelBuilder.Entity<Hotel>(entity =>
        {
            entity.ToTable("Hotels", "TAService");
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Latitude).HasPrecision(10, 7);
            entity.Property(e => e.Longitude).HasPrecision(10, 7);
            entity.Property(e => e.AverageRating).HasPrecision(3, 2);
            
            // Foreign key relationships
            entity.HasOne(e => e.City)
                  .WithMany(c => c.Hotels)
                  .HasForeignKey(e => e.CityId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.Country)
                  .WithMany(c => c.Hotels)
                  .HasForeignKey(e => e.CountryId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<HotelRoom>(entity =>
        {
            entity.ToTable("HotelRooms", "TAService");
            entity.HasKey(e => e.Id);
            entity.Property(e => e.PricePerNight).HasPrecision(18, 2);
            entity.HasIndex(e => e.HotelId);
            
            entity.HasOne(e => e.Hotel)
                  .WithMany(h => h.Rooms)
                  .HasForeignKey(e => e.HotelId)
                  .OnDelete(DeleteBehavior.Cascade);
                  
            entity.HasOne(e => e.Currency)
                  .WithMany()
                  .HasForeignKey(e => e.CurrencyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<AccommodationBooking>(entity =>
        {
            entity.ToTable("AccommodationBookings", "TAService");
            entity.HasKey(e => e.Id);
            entity.Property(e => e.TotalPrice).HasPrecision(18, 2);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => new { e.HotelId, e.CheckInDate, e.CheckOutDate });
            
            entity.HasOne(e => e.Hotel)
                  .WithMany(h => h.Bookings)
                  .HasForeignKey(e => e.HotelId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.Room)
                  .WithMany(r => r.Bookings)
                  .HasForeignKey(e => e.RoomId)
                  .OnDelete(DeleteBehavior.Restrict);
                  
            entity.HasOne(e => e.Currency)
                  .WithMany()
                  .HasForeignKey(e => e.CurrencyId)
                  .OnDelete(DeleteBehavior.Restrict);
        });
    }
}
