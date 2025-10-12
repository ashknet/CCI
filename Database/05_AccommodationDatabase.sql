-- =============================================
-- Medical Travel Booking Platform
-- Accommodation Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelAccommodationDB')
BEGIN
    CREATE DATABASE MedicalTravelAccommodationDB;
END
GO

USE MedicalTravelAccommodationDB;
GO

-- Accommodation Properties
CREATE TABLE Accommodations (
    AccommodationId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationName NVARCHAR(255) NOT NULL,
    AccommodationType NVARCHAR(50) NOT NULL, -- Hotel, Apartment, Guesthouse, Medical Lodge
    Description NVARCHAR(MAX),
    Rating DECIMAL(3,2) DEFAULT 0.0,
    TotalReviews INT DEFAULT 0,
    ContactEmail NVARCHAR(255),
    ContactPhone NVARCHAR(20),
    Website NVARCHAR(500),
    CheckInTime TIME DEFAULT '14:00:00',
    CheckOutTime TIME DEFAULT '11:00:00',
    CancellationPolicy NVARCHAR(MAX),
    IsActive BIT DEFAULT 1,
    IsMedicalFriendly BIT DEFAULT 0, -- Special facilities for medical patients
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_Accommodations_AccommodationType (AccommodationType),
    INDEX IX_Accommodations_Rating (Rating)
);

-- Accommodation Addresses
CREATE TABLE AccommodationAddresses (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationId UNIQUEIDENTIFIER NOT NULL,
    Street NVARCHAR(255),
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100),
    Country NVARCHAR(100) NOT NULL,
    PostalCode NVARCHAR(20),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    DistanceToNearestHospital DECIMAL(10,2), -- in kilometers
    NearestHospitalId UNIQUEIDENTIFIER, -- References ProviderService.Hospitals
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId) ON DELETE CASCADE,
    INDEX IX_AccommodationAddresses_AccommodationId (AccommodationId),
    INDEX IX_AccommodationAddresses_City (City)
);

-- Room Types
CREATE TABLE RoomTypes (
    RoomTypeId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationId UNIQUEIDENTIFIER NOT NULL,
    RoomTypeName NVARCHAR(100) NOT NULL, -- Single, Double, Suite, etc.
    Description NVARCHAR(MAX),
    MaxOccupancy INT NOT NULL,
    BedType NVARCHAR(50),
    RoomSize DECIMAL(8,2), -- Square meters
    PricePerNight DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    TotalRooms INT NOT NULL,
    AvailableRooms INT NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId) ON DELETE CASCADE,
    INDEX IX_RoomTypes_AccommodationId (AccommodationId)
);

-- Amenities
CREATE TABLE Amenities (
    AmenityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AmenityName NVARCHAR(100) NOT NULL UNIQUE,
    AmenityCategory NVARCHAR(50), -- General, Room, Medical, Accessibility
    IconUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Accommodation Amenities
CREATE TABLE AccommodationAmenities (
    AccommodationAmenityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationId UNIQUEIDENTIFIER NOT NULL,
    AmenityId UNIQUEIDENTIFIER NOT NULL,
    IsAvailable BIT DEFAULT 1,
    IsFree BIT DEFAULT 1,
    AdditionalCost DECIMAL(10,2),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId) ON DELETE CASCADE,
    FOREIGN KEY (AmenityId) REFERENCES Amenities(AmenityId) ON DELETE CASCADE,
    INDEX IX_AccommodationAmenities_AccommodationId (AccommodationId)
);

-- Room Amenities
CREATE TABLE RoomAmenities (
    RoomAmenityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    RoomTypeId UNIQUEIDENTIFIER NOT NULL,
    AmenityId UNIQUEIDENTIFIER NOT NULL,
    FOREIGN KEY (RoomTypeId) REFERENCES RoomTypes(RoomTypeId) ON DELETE CASCADE,
    FOREIGN KEY (AmenityId) REFERENCES Amenities(AmenityId) ON DELETE CASCADE,
    INDEX IX_RoomAmenities_RoomTypeId (RoomTypeId)
);

-- Disease-Specific Accommodations (e.g., wheelchair accessible, quiet rooms)
CREATE TABLE DiseaseAccommodationSuitability (
    SuitabilityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationId UNIQUEIDENTIFIER NOT NULL,
    DiseaseId UNIQUEIDENTIFIER NOT NULL, -- References ProviderService.Diseases
    SuitabilityScore INT, -- 1-10 scale
    RecommendationNotes NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId) ON DELETE CASCADE,
    INDEX IX_DiseaseAccommodationSuitability_AccommodationId (AccommodationId),
    INDEX IX_DiseaseAccommodationSuitability_DiseaseId (DiseaseId)
);

-- Accommodation Bookings
CREATE TABLE AccommodationBookings (
    BookingId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    AppointmentId UNIQUEIDENTIFIER, -- Optional link to appointment
    AccommodationId UNIQUEIDENTIFIER NOT NULL,
    RoomTypeId UNIQUEIDENTIFIER NOT NULL,
    BookingReference NVARCHAR(100) UNIQUE,
    GuestName NVARCHAR(255) NOT NULL,
    GuestEmail NVARCHAR(255) NOT NULL,
    GuestPhone NVARCHAR(20),
    NumberOfGuests INT DEFAULT 1,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfNights INT NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    BookingStatus NVARCHAR(50) DEFAULT 'Pending', -- Pending, Confirmed, CheckedIn, CheckedOut, Cancelled
    PaymentStatus NVARCHAR(50) DEFAULT 'Pending',
    SpecialRequests NVARCHAR(MAX),
    ConfirmationNumber NVARCHAR(100),
    BookedAt DATETIME2 DEFAULT GETUTCDATE(),
    CancelledAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId),
    FOREIGN KEY (RoomTypeId) REFERENCES RoomTypes(RoomTypeId),
    INDEX IX_AccommodationBookings_UserId (UserId),
    INDEX IX_AccommodationBookings_BookingReference (BookingReference),
    INDEX IX_AccommodationBookings_CheckInDate (CheckInDate),
    INDEX IX_AccommodationBookings_BookingStatus (BookingStatus)
);

-- Accommodation Images
CREATE TABLE AccommodationImages (
    ImageId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AccommodationId UNIQUEIDENTIFIER,
    RoomTypeId UNIQUEIDENTIFIER,
    ImageUrl NVARCHAR(500) NOT NULL,
    Caption NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    IsPrimary BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AccommodationId) REFERENCES Accommodations(AccommodationId) ON DELETE CASCADE,
    FOREIGN KEY (RoomTypeId) REFERENCES RoomTypes(RoomTypeId),
    INDEX IX_AccommodationImages_AccommodationId (AccommodationId),
    INDEX IX_AccommodationImages_RoomTypeId (RoomTypeId)
);

-- Insert Sample Amenities
INSERT INTO Amenities (AmenityName, AmenityCategory) VALUES
('WiFi', 'General'),
('Parking', 'General'),
('Restaurant', 'General'),
('24/7 Reception', 'General'),
('Wheelchair Accessible', 'Accessibility'),
('Elevator', 'Accessibility'),
('Air Conditioning', 'Room'),
('TV', 'Room'),
('Refrigerator', 'Room'),
('Microwave', 'Room'),
('Private Bathroom', 'Room'),
('Medical Equipment Storage', 'Medical'),
('Nurse on Call', 'Medical'),
('Special Diet Meals', 'Medical'),
('Oxygen Supply Available', 'Medical');

-- Insert Sample Accommodations
INSERT INTO Accommodations (AccommodationName, AccommodationType, Description, Rating, IsMedicalFriendly) VALUES
('Medical Stay Hotel', 'Hotel', 'Hotel specifically designed for medical tourists with trained staff and medical amenities', 4.8, 1),
('Comfort Inn Near Hospital', 'Hotel', 'Comfortable hotel within walking distance of major hospitals', 4.5, 1),
('Recovery Apartments', 'Apartment', 'Fully equipped apartments for extended medical stays with kitchen facilities', 4.6, 1),
('Healing Lodge', 'Medical Lodge', 'Specialized medical recovery facility with nursing support', 4.9, 1);

-- Insert Sample Room Types
DECLARE @Hotel1 UNIQUEIDENTIFIER = (SELECT TOP 1 AccommodationId FROM Accommodations WHERE AccommodationName = 'Medical Stay Hotel');
DECLARE @Hotel2 UNIQUEIDENTIFIER = (SELECT TOP 1 AccommodationId FROM Accommodations WHERE AccommodationName = 'Comfort Inn Near Hospital');

INSERT INTO RoomTypes (AccommodationId, RoomTypeName, Description, MaxOccupancy, BedType, PricePerNight, TotalRooms, AvailableRooms) VALUES
(@Hotel1, 'Standard Single', 'Single room with medical-friendly features', 1, 'Single', 120.00, 20, 15),
(@Hotel1, 'Deluxe Double', 'Spacious double room with wheelchair access', 2, 'Double', 180.00, 15, 12),
(@Hotel1, 'Medical Suite', 'Suite with medical equipment storage and nurse call button', 2, 'King', 250.00, 10, 8),
(@Hotel2, 'Standard Room', 'Comfortable room with basic amenities', 2, 'Queen', 100.00, 30, 25),
(@Hotel2, 'Family Room', 'Large room suitable for patient and caregiver', 4, 'Two Queens', 150.00, 10, 8);

GO
