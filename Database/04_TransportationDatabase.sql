-- =============================================
-- Medical Travel Booking Platform
-- Transportation Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelTransportDB')
BEGIN
    CREATE DATABASE MedicalTravelTransportDB;
END
GO

USE MedicalTravelTransportDB;
GO

-- Transportation Providers
CREATE TABLE TransportationProviders (
    ProviderId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProviderName NVARCHAR(255) NOT NULL,
    ProviderType NVARCHAR(50) NOT NULL, -- Flight, Train, Bus
    LogoUrl NVARCHAR(500),
    ContactEmail NVARCHAR(255),
    ContactPhone NVARCHAR(20),
    APIEndpoint NVARCHAR(500),
    APIKey NVARCHAR(500), -- Encrypted
    IsActive BIT DEFAULT 1,
    Rating DECIMAL(3,2) DEFAULT 0.0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_TransportationProviders_ProviderType (ProviderType)
);

-- Airports
CREATE TABLE Airports (
    AirportId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AirportCode NVARCHAR(10) NOT NULL UNIQUE,
    AirportName NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    Timezone NVARCHAR(50),
    IsActive BIT DEFAULT 1,
    INDEX IX_Airports_AirportCode (AirportCode),
    INDEX IX_Airports_City (City)
);

-- Train Stations
CREATE TABLE TrainStations (
    StationId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    StationCode NVARCHAR(10) NOT NULL UNIQUE,
    StationName NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    IsActive BIT DEFAULT 1,
    INDEX IX_TrainStations_StationCode (StationCode),
    INDEX IX_TrainStations_City (City)
);

-- Bus Terminals
CREATE TABLE BusTerminals (
    TerminalId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TerminalCode NVARCHAR(10) NOT NULL UNIQUE,
    TerminalName NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    IsActive BIT DEFAULT 1,
    INDEX IX_BusTerminals_TerminalCode (TerminalCode),
    INDEX IX_BusTerminals_City (City)
);

-- Flight Options
CREATE TABLE Flights (
    FlightId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProviderId UNIQUEIDENTIFIER NOT NULL,
    FlightNumber NVARCHAR(20) NOT NULL,
    DepartureAirportId UNIQUEIDENTIFIER NOT NULL,
    ArrivalAirportId UNIQUEIDENTIFIER NOT NULL,
    DepartureTime DATETIME2 NOT NULL,
    ArrivalTime DATETIME2 NOT NULL,
    Duration INT NOT NULL, -- Minutes
    Price DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    AvailableSeats INT NOT NULL,
    FlightClass NVARCHAR(50), -- Economy, Business, First
    IsDirectFlight BIT DEFAULT 1,
    Stops INT DEFAULT 0,
    BaggageAllowance NVARCHAR(100),
    IsRefundable BIT DEFAULT 0,
    ExternalBookingUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ProviderId) REFERENCES TransportationProviders(ProviderId),
    FOREIGN KEY (DepartureAirportId) REFERENCES Airports(AirportId),
    FOREIGN KEY (ArrivalAirportId) REFERENCES Airports(AirportId),
    INDEX IX_Flights_DepartureAirportId (DepartureAirportId),
    INDEX IX_Flights_ArrivalAirportId (ArrivalAirportId),
    INDEX IX_Flights_DepartureTime (DepartureTime),
    INDEX IX_Flights_Price (Price)
);

-- Train Options
CREATE TABLE Trains (
    TrainId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProviderId UNIQUEIDENTIFIER NOT NULL,
    TrainNumber NVARCHAR(20) NOT NULL,
    DepartureStationId UNIQUEIDENTIFIER NOT NULL,
    ArrivalStationId UNIQUEIDENTIFIER NOT NULL,
    DepartureTime DATETIME2 NOT NULL,
    ArrivalTime DATETIME2 NOT NULL,
    Duration INT NOT NULL, -- Minutes
    Price DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    AvailableSeats INT NOT NULL,
    TrainClass NVARCHAR(50), -- Standard, First, Sleeper
    IsRefundable BIT DEFAULT 0,
    ExternalBookingUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ProviderId) REFERENCES TransportationProviders(ProviderId),
    FOREIGN KEY (DepartureStationId) REFERENCES TrainStations(StationId),
    FOREIGN KEY (ArrivalStationId) REFERENCES TrainStations(StationId),
    INDEX IX_Trains_DepartureStationId (DepartureStationId),
    INDEX IX_Trains_ArrivalStationId (ArrivalStationId),
    INDEX IX_Trains_DepartureTime (DepartureTime)
);

-- Bus Options
CREATE TABLE Buses (
    BusId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProviderId UNIQUEIDENTIFIER NOT NULL,
    BusNumber NVARCHAR(20) NOT NULL,
    DepartureTerminalId UNIQUEIDENTIFIER NOT NULL,
    ArrivalTerminalId UNIQUEIDENTIFIER NOT NULL,
    DepartureTime DATETIME2 NOT NULL,
    ArrivalTime DATETIME2 NOT NULL,
    Duration INT NOT NULL, -- Minutes
    Price DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    AvailableSeats INT NOT NULL,
    BusType NVARCHAR(50), -- Standard, Luxury, Sleeper
    Amenities NVARCHAR(500), -- WiFi, AC, Charging ports
    IsRefundable BIT DEFAULT 0,
    ExternalBookingUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ProviderId) REFERENCES TransportationProviders(ProviderId),
    FOREIGN KEY (DepartureTerminalId) REFERENCES BusTerminals(TerminalId),
    FOREIGN KEY (ArrivalTerminalId) REFERENCES BusTerminals(TerminalId),
    INDEX IX_Buses_DepartureTerminalId (DepartureTerminalId),
    INDEX IX_Buses_ArrivalTerminalId (ArrivalTerminalId),
    INDEX IX_Buses_DepartureTime (DepartureTime)
);

-- Transportation Bookings
CREATE TABLE TransportationBookings (
    BookingId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    AppointmentId UNIQUEIDENTIFIER, -- Optional link to appointment
    TransportationType NVARCHAR(20) NOT NULL, -- Flight, Train, Bus
    TransportationId UNIQUEIDENTIFIER NOT NULL, -- FlightId, TrainId, or BusId
    BookingReference NVARCHAR(100) UNIQUE,
    PassengerName NVARCHAR(255) NOT NULL,
    PassengerEmail NVARCHAR(255) NOT NULL,
    PassengerPhone NVARCHAR(20),
    NumberOfPassengers INT DEFAULT 1,
    TotalPrice DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    BookingStatus NVARCHAR(50) DEFAULT 'Pending', -- Pending, Confirmed, Cancelled
    PaymentStatus NVARCHAR(50) DEFAULT 'Pending',
    ExternalBookingId NVARCHAR(255),
    ConfirmationNumber NVARCHAR(100),
    BookedAt DATETIME2 DEFAULT GETUTCDATE(),
    CancelledAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_TransportationBookings_UserId (UserId),
    INDEX IX_TransportationBookings_BookingReference (BookingReference),
    INDEX IX_TransportationBookings_BookingStatus (BookingStatus)
);

-- Insert Sample Transportation Providers
INSERT INTO TransportationProviders (ProviderName, ProviderType, Rating) VALUES
('Global Airways', 'Flight', 4.5),
('International Express', 'Flight', 4.3),
('National Railways', 'Train', 4.2),
('Express Train Service', 'Train', 4.4),
('Comfort Bus Lines', 'Bus', 4.0),
('Premium Coach', 'Bus', 4.1);

-- Insert Sample Airports
INSERT INTO Airports (AirportCode, AirportName, City, Country, Latitude, Longitude, Timezone) VALUES
('JFK', 'John F. Kennedy International Airport', 'New York', 'USA', 40.6413, -73.7781, 'America/New_York'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA', 33.9416, -118.4085, 'America/Los_Angeles'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore', 1.3644, 103.9915, 'Asia/Singapore'),
('DXB', 'Dubai International Airport', 'Dubai', 'UAE', 25.2532, 55.3657, 'Asia/Dubai'),
('LHR', 'London Heathrow Airport', 'London', 'UK', 51.4700, -0.4543, 'Europe/London');

-- Insert Sample Train Stations
INSERT INTO TrainStations (StationCode, StationName, City, Country) VALUES
('NYP', 'New York Penn Station', 'New York', 'USA'),
('WAS', 'Washington Union Station', 'Washington DC', 'USA'),
('NDLS', 'New Delhi Railway Station', 'New Delhi', 'India'),
('SIN', 'Singapore Railway Station', 'Singapore', 'Singapore');

-- Insert Sample Flights
DECLARE @Provider1 UNIQUEIDENTIFIER = (SELECT TOP 1 ProviderId FROM TransportationProviders WHERE ProviderName = 'Global Airways');
DECLARE @JFK UNIQUEIDENTIFIER = (SELECT TOP 1 AirportId FROM Airports WHERE AirportCode = 'JFK');
DECLARE @SIN UNIQUEIDENTIFIER = (SELECT TOP 1 AirportId FROM Airports WHERE AirportCode = 'SIN');
DECLARE @DXB UNIQUEIDENTIFIER = (SELECT TOP 1 AirportId FROM Airports WHERE AirportCode = 'DXB');

INSERT INTO Flights (ProviderId, FlightNumber, DepartureAirportId, ArrivalAirportId, DepartureTime, ArrivalTime, Duration, Price, AvailableSeats, FlightClass) VALUES
(@Provider1, 'GA123', @JFK, @SIN, DATEADD(DAY, 7, GETUTCDATE()), DATEADD(HOUR, 18, DATEADD(DAY, 7, GETUTCDATE())), 1080, 1250.00, 150, 'Economy'),
(@Provider1, 'GA124', @JFK, @DXB, DATEADD(DAY, 7, GETUTCDATE()), DATEADD(HOUR, 14, DATEADD(DAY, 7, GETUTCDATE())), 840, 980.00, 180, 'Economy');

GO
