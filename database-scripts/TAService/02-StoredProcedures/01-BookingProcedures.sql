-- =============================================
-- TAService - Stored Procedures
-- =============================================

USE TAServiceDb;
GO

-- =============================================
-- SP: Search Flights
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_SearchFlights]
    @DepartureAirport NVARCHAR(10),
    @ArrivalAirport NVARCHAR(10),
    @DepartureDate DATE,
    @FlightClass NVARCHAR(20) = NULL,
    @MinSeats INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM Flights
    WHERE DepartureAirport = @DepartureAirport
      AND ArrivalAirport = @ArrivalAirport
      AND CAST(DepartureTime AS DATE) = @DepartureDate
      AND (@FlightClass IS NULL OR FlightClass = @FlightClass)
      AND AvailableSeats >= @MinSeats
      AND IsActive = 1
    ORDER BY Price, DepartureTime;
END
GO

-- =============================================
-- SP: Get Flight Recommendations
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetFlightRecommendations]
    @DepartureAirport NVARCHAR(10),
    @ArrivalAirport NVARCHAR(10),
    @AppointmentDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @DepartureDate DATE = DATEADD(DAY, -1, @AppointmentDate);
    
    -- Best overall (balance of price, duration, rating)
    SELECT TOP 1 'best' AS Recommendation, * 
    FROM Flights
    WHERE DepartureAirport = @DepartureAirport
      AND ArrivalAirport = @ArrivalAirport
      AND CAST(DepartureTime AS DATE) = @DepartureDate
      AND IsActive = 1
    ORDER BY (Price / 1000 + DurationMinutes / 60) ASC;
    
    -- Cheapest
    SELECT TOP 1 'cheapest' AS Recommendation, *
    FROM Flights
    WHERE DepartureAirport = @DepartureAirport
      AND ArrivalAirport = @ArrivalAirport
      AND CAST(DepartureTime AS DATE) = @DepartureDate
      AND IsActive = 1
    ORDER BY Price ASC;
    
    -- Fastest
    SELECT TOP 1 'fastest' AS Recommendation, *
    FROM Flights
    WHERE DepartureAirport = @DepartureAirport
      AND ArrivalAirport = @ArrivalAirport
      AND CAST(DepartureTime AS DATE) = @DepartureDate
      AND IsActive = 1
    ORDER BY DurationMinutes ASC;
END
GO

-- =============================================
-- SP: Create Transport Booking
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CreateTransportBooking]
    @UserId UNIQUEIDENTIFIER,
    @BookingType NVARCHAR(20),
    @ReferenceId UNIQUEIDENTIFIER,
    @PassengerName NVARCHAR(200),
    @PassengerEmail NVARCHAR(255),
    @PassengerPhone NVARCHAR(20),
    @BookingId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @DepartureFrom NVARCHAR(100);
        DECLARE @ArrivalTo NVARCHAR(100);
        DECLARE @DepartureTime DATETIME2;
        DECLARE @ArrivalTime DATETIME2;
        DECLARE @Price DECIMAL(18,2);
        DECLARE @Currency NVARCHAR(10);
        
        -- Get flight/train details
        IF @BookingType = 'flight'
        BEGIN
            SELECT 
                @DepartureFrom = DepartureAirport,
                @ArrivalTo = ArrivalAirport,
                @DepartureTime = DepartureTime,
                @ArrivalTime = ArrivalTime,
                @Price = Price,
                @Currency = Currency
            FROM Flights
            WHERE Id = @ReferenceId;
            
            -- Update available seats
            UPDATE Flights
            SET AvailableSeats = AvailableSeats - 1
            WHERE Id = @ReferenceId AND AvailableSeats > 0;
        END
        
        -- Create booking
        SET @BookingId = NEWID();
        INSERT INTO TransportBookings (Id, UserId, BookingType, ReferenceId, PassengerName, PassengerEmail, PassengerPhone,
                                       DepartureFrom, ArrivalTo, DepartureTime, ArrivalTime, Price, Currency, Status, BookingReference)
        VALUES (@BookingId, @UserId, @BookingType, @ReferenceId, @PassengerName, @PassengerEmail, @PassengerPhone,
                @DepartureFrom, @ArrivalTo, @DepartureTime, @ArrivalTime, @Price, @Currency, 'pending',
                @BookingType + SUBSTRING(CAST(@BookingId AS NVARCHAR(36)), 1, 8));
        
        COMMIT TRANSACTION;
        SELECT @BookingId AS BookingId, @Price AS TotalPrice;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- SP: Search Hotels Near Hospital
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_SearchHotelsNearHospital]
    @Latitude DECIMAL(10,7),
    @Longitude DECIMAL(10,7),
    @MaxDistanceKm DECIMAL(5,2) = 10,
    @MinStarRating INT = NULL,
    @MaxPricePerNight DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 50
        *,
        (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(Latitude)) *
            COS(RADIANS(Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(Latitude))
        )) AS CalculatedDistanceKm
    FROM Hotels
    WHERE IsActive = 1
        AND Latitude IS NOT NULL
        AND Longitude IS NOT NULL
        AND (@MinStarRating IS NULL OR StarRating >= @MinStarRating)
    HAVING (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(Latitude)) *
            COS(RADIANS(Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(Latitude))
        )) <= @MaxDistanceKm
    ORDER BY CalculatedDistanceKm, AverageRating DESC;
END
GO

-- =============================================
-- SP: Create Cost Estimate
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CreateCostEstimate]
    @UserId UNIQUEIDENTIFIER,
    @MedicalCost DECIMAL(18,2),
    @TravelCost DECIMAL(18,2),
    @AccommodationCost DECIMAL(18,2),
    @MiscCost DECIMAL(18,2) = 0,
    @ValidDays INT = 30,
    @EstimateId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCost DECIMAL(18,2) = @MedicalCost + @TravelCost + @AccommodationCost + @MiscCost;
    DECLARE @ValidUntil DATE = DATEADD(DAY, @ValidDays, GETDATE());
    
    SET @EstimateId = NEWID();
    
    INSERT INTO CostBreakdowns (Id, UserId, EstimateType, MedicalCost, TravelCost, AccommodationCost, 
                                MiscellaneousCost, TotalCost, ValidUntil, Status)
    VALUES (@EstimateId, @UserId, 'comprehensive', @MedicalCost, @TravelCost, @AccommodationCost,
            @MiscCost, @TotalCost, @ValidUntil, 'draft');
    
    SELECT @EstimateId AS EstimateId, @TotalCost AS TotalCost;
END
GO

PRINT 'TAService stored procedures created successfully';
GO
