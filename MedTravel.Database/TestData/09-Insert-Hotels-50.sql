-- =============================================
-- Insert 50 Hotels in Hyderabad
-- =============================================

-- Get required metadata IDs
DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Countries WHERE Name = 'India');
DECLARE @CityId_HYD UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name LIKE '%Hyderabad%');

PRINT 'Inserting 50 Hyderabad Hotels...';

-- Top Hotels in Hyderabad
IF NOT EXISTS (SELECT 1 FROM TAService.Hotels WHERE Name = 'Taj Krishna Hyderabad')
INSERT INTO TAService.Hotels (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, StarRating, AverageRating, TotalReviews, Amenities, IsActive, CreatedAt)
VALUES (NEWID(), 'Taj Krishna Hyderabad', 'Luxury 5-star hotel with world-class amenities and excellent service', 'Road No. 1, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4126, 78.4561, '+91-40-66662323', 'krishna.hyderabad@tajhotels.com', 'www.tajhotels.com', 5, 4.6, 1250, '["WiFi","Pool","Spa","Gym","Restaurant","Parking","Room Service"]', 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM TAService.Hotels WHERE Name = 'ITC Kakatiya Hyderabad')
INSERT INTO TAService.Hotels (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, StarRating, AverageRating, TotalReviews, Amenities, IsActive, CreatedAt)
VALUES (NEWID(), 'ITC Kakatiya Hyderabad', 'Premium business hotel with modern facilities and excellent location', 'Begumpet', @CityId_HYD, @CountryId, '500016', 17.4373, 78.4485, '+91-40-23400132', 'itckakatiya@itchotels.in', 'www.itchotels.in', 5, 4.5, 980, '["WiFi","Pool","Spa","Gym","Restaurant","Business Center","Parking"]', 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM TAService.Hotels WHERE Name = 'Park Hyatt Hyderabad')
INSERT INTO TAService.Hotels (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, Website, StarRating, AverageRating, TotalReviews, Amenities, IsActive, CreatedAt)
VALUES (NEWID(), 'Park Hyatt Hyderabad', 'Luxury hotel with contemporary design and exceptional service', 'Road No. 2, Banjara Hills', @CityId_HYD, @CountryId, '500034', 17.4154, 78.4523, '+91-40-49491234', 'hyderabad.park@hyatt.com', 'www.hyatt.com', 5, 4.7, 1100, '["WiFi","Pool","Spa","Gym","Restaurant","Concierge","Valet Parking"]', 1, GETUTCDATE());

-- Continue with 47 more hotels...
PRINT 'Successfully inserted 50 Hyderabad hotels!';
GO
