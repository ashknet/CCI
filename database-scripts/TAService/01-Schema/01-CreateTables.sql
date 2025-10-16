-- =============================================
-- MedTravel Platform - TAService Database
-- Schema Creation Script
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TAServiceDb')
BEGIN
    CREATE DATABASE TAServiceDb;
END
GO

USE TAServiceDb;
GO

-- =============================================
-- 1. Flights Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flights]'))
BEGIN
    CREATE TABLE [dbo].[Flights] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [FlightNumber] NVARCHAR(20) NOT NULL,
        [Airline] NVARCHAR(100) NOT NULL,
        [DepartureAirport] NVARCHAR(10) NOT NULL,
        [ArrivalAirport] NVARCHAR(10) NOT NULL,
        [DepartureTime] DATETIME2 NOT NULL,
        [ArrivalTime] DATETIME2 NOT NULL,
        [DurationMinutes] INT,
        [Price] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [AvailableSeats] INT,
        [FlightClass] NVARCHAR(20),
        [IsDirect] BIT DEFAULT 1,
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Flights_Route ON [dbo].[Flights]([DepartureAirport], [ArrivalAirport]);
    CREATE INDEX IX_Flights_DepartureTime ON [dbo].[Flights]([DepartureTime]);
    CREATE INDEX IX_Flights_FlightNumber ON [dbo].[Flights]([FlightNumber]);
END
GO

-- =============================================
-- 2. Trains Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Trains]'))
BEGIN
    CREATE TABLE [dbo].[Trains] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [TrainNumber] NVARCHAR(20) NOT NULL,
        [TrainName] NVARCHAR(100) NOT NULL,
        [DepartureStation] NVARCHAR(100) NOT NULL,
        [ArrivalStation] NVARCHAR(100) NOT NULL,
        [DepartureTime] DATETIME2 NOT NULL,
        [ArrivalTime] DATETIME2 NOT NULL,
        [Price] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [AvailableSeats] INT,
        [TrainClass] NVARCHAR(20),
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    
    CREATE INDEX IX_Trains_Route ON [dbo].[Trains]([DepartureStation], [ArrivalStation]);
END
GO

-- =============================================
-- 3. TransportBookings Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransportBookings]'))
BEGIN
    CREATE TABLE [dbo].[TransportBookings] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [BookingType] NVARCHAR(20) NOT NULL, -- flight, train, bus
        [ReferenceId] UNIQUEIDENTIFIER NULL, -- FK to Flights/Trains
        [PassengerName] NVARCHAR(200) NOT NULL,
        [PassengerEmail] NVARCHAR(255),
        [PassengerPhone] NVARCHAR(20),
        [DepartureFrom] NVARCHAR(100) NOT NULL,
        [ArrivalTo] NVARCHAR(100) NOT NULL,
        [DepartureTime] DATETIME2 NOT NULL,
        [ArrivalTime] DATETIME2 NOT NULL,
        [Price] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [Status] NVARCHAR(20) DEFAULT 'pending', -- pending, confirmed, cancelled
        [BookingReference] NVARCHAR(50),
        [PNR] NVARCHAR(50),
        [PaymentId] NVARCHAR(100),
        [IsPaid] BIT DEFAULT 0,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_TransportBookings_UserId ON [dbo].[TransportBookings]([UserId]);
    CREATE INDEX IX_TransportBookings_Status ON [dbo].[TransportBookings]([Status]);
    CREATE INDEX IX_TransportBookings_DepartureTime ON [dbo].[TransportBookings]([DepartureTime]);
END
GO

-- =============================================
-- 4. Hotels Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Hotels]'))
BEGIN
    CREATE TABLE [dbo].[Hotels] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(2000),
        [Address] NVARCHAR(500) NOT NULL,
        [City] NVARCHAR(100) NOT NULL,
        [State] NVARCHAR(100),
        [Country] NVARCHAR(100) NOT NULL,
        [PostalCode] NVARCHAR(20),
        [Latitude] DECIMAL(10,7),
        [Longitude] DECIMAL(10,7),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(255),
        [Website] NVARCHAR(500),
        [StarRating] INT CHECK ([StarRating] BETWEEN 1 AND 5),
        [AverageRating] DECIMAL(3,2) DEFAULT 0,
        [TotalReviews] INT DEFAULT 0,
        [Amenities] NVARCHAR(MAX), -- JSON array
        [NearHospitalId] UNIQUEIDENTIFIER NULL,
        [DistanceToHospitalKm] DECIMAL(5,2),
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Hotels_City ON [dbo].[Hotels]([City]);
    CREATE INDEX IX_Hotels_Location ON [dbo].[Hotels]([Latitude], [Longitude]);
    CREATE INDEX IX_Hotels_Rating ON [dbo].[Hotels]([AverageRating] DESC);
END
GO

-- =============================================
-- 5. HotelRooms Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HotelRooms]'))
BEGIN
    CREATE TABLE [dbo].[HotelRooms] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HotelId] UNIQUEIDENTIFIER NOT NULL,
        [RoomType] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(1000),
        [PricePerNight] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [MaxOccupancy] INT,
        [TotalRooms] INT,
        [AvailableRooms] INT,
        [Amenities] NVARCHAR(MAX), -- JSON array
        [Images] NVARCHAR(MAX), -- JSON array of URLs
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_HotelRooms_Hotel FOREIGN KEY ([HotelId]) REFERENCES [dbo].[Hotels]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_HotelRooms_HotelId ON [dbo].[HotelRooms]([HotelId]);
END
GO

-- =============================================
-- 6. AccommodationBookings Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccommodationBookings]'))
BEGIN
    CREATE TABLE [dbo].[AccommodationBookings] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [HotelId] UNIQUEIDENTIFIER NOT NULL,
        [RoomId] UNIQUEIDENTIFIER NOT NULL,
        [CheckInDate] DATE NOT NULL,
        [CheckOutDate] DATE NOT NULL,
        [NumberOfGuests] INT NOT NULL,
        [NumberOfRooms] INT DEFAULT 1,
        [TotalPrice] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [Status] NVARCHAR(20) DEFAULT 'pending', -- pending, confirmed, cancelled, completed
        [BookingReference] NVARCHAR(50),
        [GuestName] NVARCHAR(200),
        [GuestEmail] NVARCHAR(255),
        [GuestPhone] NVARCHAR(20),
        [SpecialRequests] NVARCHAR(1000),
        [PaymentId] NVARCHAR(100),
        [IsPaid] BIT DEFAULT 0,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_AccommodationBookings_Hotel FOREIGN KEY ([HotelId]) REFERENCES [dbo].[Hotels]([Id]),
        CONSTRAINT FK_AccommodationBookings_Room FOREIGN KEY ([RoomId]) REFERENCES [dbo].[HotelRooms]([Id])
    );
    
    CREATE INDEX IX_AccommodationBookings_UserId ON [dbo].[AccommodationBookings]([UserId]);
    CREATE INDEX IX_AccommodationBookings_CheckIn ON [dbo].[AccommodationBookings]([CheckInDate]);
    CREATE INDEX IX_AccommodationBookings_Status ON [dbo].[AccommodationBookings]([Status]);
END
GO

-- =============================================
-- 7. CostBreakdowns Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CostBreakdowns]'))
BEGIN
    CREATE TABLE [dbo].[CostBreakdowns] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [EstimateType] NVARCHAR(50) DEFAULT 'comprehensive', -- medical, travel, accommodation, comprehensive
        [MedicalCost] DECIMAL(18,2) DEFAULT 0,
        [TravelCost] DECIMAL(18,2) DEFAULT 0,
        [AccommodationCost] DECIMAL(18,2) DEFAULT 0,
        [MiscellaneousCost] DECIMAL(18,2) DEFAULT 0,
        [TotalCost] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [LineItems] NVARCHAR(MAX), -- JSON array of detailed items
        [ValidUntil] DATE,
        [Status] NVARCHAR(20) DEFAULT 'draft', -- draft, confirmed, expired
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    
    CREATE INDEX IX_CostBreakdowns_UserId ON [dbo].[CostBreakdowns]([UserId]);
END
GO

-- =============================================
-- 8. Payments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]'))
BEGIN
    CREATE TABLE [dbo].[Payments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [Currency] NVARCHAR(10) DEFAULT 'INR',
        [PaymentMethod] NVARCHAR(50), -- card, upi, netbanking, wallet
        [PaymentGateway] NVARCHAR(50), -- razorpay, stripe, etc
        [Status] NVARCHAR(20) DEFAULT 'pending', -- pending, authorized, captured, failed, refunded
        [TransactionId] NVARCHAR(100),
        [PaymentIntentId] NVARCHAR(100),
        [Description] NVARCHAR(500),
        [Metadata] NVARCHAR(MAX), -- JSON for additional data
        [ErrorMessage] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        [CapturedAt] DATETIME2 NULL,
        [RefundedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Payments_UserId ON [dbo].[Payments]([UserId]);
    CREATE INDEX IX_Payments_Status ON [dbo].[Payments]([Status]);
    CREATE INDEX IX_Payments_TransactionId ON [dbo].[Payments]([TransactionId]);
END
GO

PRINT 'TAService schema created successfully';
GO
