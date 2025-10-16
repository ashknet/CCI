-- =============================================
-- TAService - Sample Data
-- =============================================

USE TAServiceDb;
GO

-- =============================================
-- 1. Insert Sample Flights
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Flights)
BEGIN
    INSERT INTO Flights (FlightNumber, Airline, DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, DurationMinutes, Price, AvailableSeats, FlightClass, IsDirect)
    VALUES
        -- International flights to India
        ('AI101', 'Air India', 'JFK', 'HYD', DATEADD(DAY, 10, GETDATE()), DATEADD(DAY, 10, DATEADD(HOUR, 16, GETDATE())), 960, 85000, 50, 'Economy', 1),
        ('EK501', 'Emirates', 'JFK', 'HYD', DATEADD(DAY, 10, DATEADD(HOUR, 2, GETDATE())), DATEADD(DAY, 10, DATEADD(HOUR, 18, GETDATE())), 960, 95000, 30, 'Business', 1),
        ('QR401', 'Qatar Airways', 'LHR', 'BLR', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 15, DATEADD(HOUR, 14, GETDATE())), 840, 78000, 45, 'Economy', 0),
        ('BA143', 'British Airways', 'LHR', 'BOM', DATEADD(DAY, 20, GETDATE()), DATEADD(DAY, 20, DATEADD(HOUR, 10, GETDATE())), 600, 105000, 25, 'Premium Economy', 1),
        
        -- Domestic flights within India
        ('6E234', 'IndiGo', 'DEL', 'HYD', DATEADD(DAY, 5, GETDATE()), DATEADD(DAY, 5, DATEADD(HOUR, 2, GETDATE())), 120, 4500, 100, 'Economy', 1),
        ('SG456', 'SpiceJet', 'BOM', 'BLR', DATEADD(DAY, 7, GETDATE()), DATEADD(DAY, 7, DATEADD(HOUR, 1.5, GETDATE())), 90, 3800, 120, 'Economy', 1),
        ('AI789', 'Air India', 'BLR', 'HYD', DATEADD(DAY, 12, GETDATE()), DATEADD(DAY, 12, DATEADD(HOUR, 1, GETDATE())), 60, 5200, 80, 'Business', 1);
    
    PRINT '✅ Flights inserted';
END
GO

-- =============================================
-- 2. Insert Sample Trains
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Trains)
BEGIN
    INSERT INTO Trains (TrainNumber, TrainName, DepartureStation, ArrivalStation, DepartureTime, ArrivalTime, Price, AvailableSeats, TrainClass)
    VALUES
        ('12345', 'Rajdhani Express', 'New Delhi', 'Hyderabad', DATEADD(DAY, 8, '16:00:00'), DATEADD(DAY, 9, '10:00:00'), 2500, 100, 'AC 2-Tier'),
        ('12346', 'Shatabdi Express', 'Mumbai', 'Bangalore', DATEADD(DAY, 10, '06:00:00'), DATEADD(DAY, 10, '20:00:00'), 1800, 80, 'AC Chair Car'),
        ('22691', 'Rajdhani Express', 'Bangalore', 'New Delhi', DATEADD(DAY, 15, '20:00:00'), DATEADD(DAY, 16, '06:00:00'), 3200, 90, 'AC 3-Tier');
    
    PRINT '✅ Trains inserted';
END
GO

-- =============================================
-- 3. Insert Sample Hotels
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Hotels)
BEGIN
    INSERT INTO Hotels (Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, Phone, Email, Website, StarRating, AverageRating, TotalReviews, Amenities, DistanceToHospitalKm)
    VALUES
        ('Taj Krishna Hyderabad', 
         'Luxury hotel near Apollo Hospitals with medical tourism support',
         'Road No. 1, Banjara Hills',
         'Hyderabad',
         'Telangana',
         'India',
         '500034',
         17.4239,
         78.4501,
         '+91-40-66662323',
         'krishna.hyderabad@tajhotels.com',
         'https://www.tajhotels.com',
         5,
         4.7,
         850,
         '["WiFi","Pool","Gym","Restaurant","Spa","Wheelchair Accessible","Medical Assistance","Airport Shuttle"]',
         3.5),
        
        ('Novotel Hyderabad',
         'Contemporary hotel with easy access to major hospitals',
         'Hitec City',
         'Hyderabad',
         'Telangana',
         'India',
         '500081',
         17.4485,
         78.3908,
         '+91-40-44752222',
         'H6798@accor.com',
         'https://www.novotel.com',
         4,
         4.5,
         620,
         '["WiFi","Pool","Restaurant","Gym","Business Center","Wheelchair Accessible"]',
         5.2),
        
        ('ITC Windsor Bangalore',
         'Heritage luxury hotel near major medical facilities',
         'Windsor Square, 25 Golf Course Road',
         'Bangalore',
         'Karnataka',
         'India',
         '560052',
         12.9716,
         77.5946,
         '+91-80-22269898',
         'itcwindsor@itchotels.in',
         'https://www.itchotels.com',
         5,
         4.8,
         1100,
         '["WiFi","Pool","Spa","Multiple Restaurants","Medical Support","Concierge"]',
         2.8);
    
    PRINT '✅ Hotels inserted';
END
GO

-- =============================================
-- 4. Insert Hotel Rooms
-- =============================================
IF NOT EXISTS (SELECT 1 FROM HotelRooms)
BEGIN
    -- Insert rooms for each hotel
    INSERT INTO HotelRooms (HotelId, RoomType, Description, PricePerNight, MaxOccupancy, TotalRooms, AvailableRooms, Amenities)
    SELECT 
        Id,
        'Deluxe Room',
        'Spacious room with modern amenities',
        8500,
        2,
        50,
        45,
        '["King Bed","WiFi","TV","Minibar","Safe","Air Conditioning"]'
    FROM Hotels
    WHERE Name LIKE '%Taj Krishna%'
    
    UNION ALL
    
    SELECT 
        Id,
        'Executive Suite',
        'Luxurious suite with separate living area',
        15000,
        3,
        20,
        15,
        '["King Bed","Living Room","WiFi","TV","Minibar","Butler Service"]'
    FROM Hotels
    WHERE Name LIKE '%Taj Krishna%'
    
    UNION ALL
    
    SELECT 
        Id,
        'Standard Room',
        'Comfortable room with essential amenities',
        6500,
        2,
        80,
        70,
        '["Queen Bed","WiFi","TV","Air Conditioning"]'
    FROM Hotels
    WHERE Name LIKE '%Novotel%'
    
    UNION ALL
    
    SELECT 
        Id,
        'Premium Room',
        'Elegant room with city views',
        12000,
        2,
        40,
        35,
        '["King Bed","City View","WiFi","Work Desk","Premium Toiletries"]'
    FROM Hotels
    WHERE Name LIKE '%ITC Windsor%';
    
    PRINT '✅ Hotel rooms inserted';
END
GO

PRINT 'TAService sample data inserted successfully';
GO
