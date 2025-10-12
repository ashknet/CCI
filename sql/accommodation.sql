-- Accommodation Service SQL schema
CREATE SCHEMA accom AUTHORIZATION dbo;

CREATE TABLE accom.Lodgings (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(256) NOT NULL,
    City NVARCHAR(128) NOT NULL,
    NearHospitalId BIGINT NULL,
    Type NVARCHAR(32) NOT NULL, -- Hotel, Apartment
    Address NVARCHAR(512) NULL,
    PricePerNight DECIMAL(12,2) NOT NULL,
    Amenities NVARCHAR(512) NULL,
    Rating DECIMAL(3,2) NULL
);

GO

CREATE OR ALTER PROCEDURE accom.sp_Search
  @City NVARCHAR(128),
  @HospitalId BIGINT = NULL,
  @MaxPrice DECIMAL(12,2) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM accom.Lodgings
  WHERE City=@City
    AND (@HospitalId IS NULL OR NearHospitalId=@HospitalId)
    AND (@MaxPrice IS NULL OR PricePerNight <= @MaxPrice)
  ORDER BY PricePerNight ASC;
END
GO

-- seed sample lodgings
INSERT INTO accom.Lodgings(Name, City, NearHospitalId, Type, Address, PricePerNight, Amenities, Rating)
VALUES
('Hotel MedStay', 'Hyderabad', 1, 'Hotel', 'Near Apollo Hospitals', 3500, 'WiFi,Breakfast,AirportPickup', 4.3),
('Fortis Residency', 'Bangalore', 2, 'Hotel', 'Opp. Fortis', 4200, 'WiFi,Breakfast', 4.1),
('Lilavati Apartments', 'Mumbai', 3, 'Apartment', '5 min from Lilavati', 3000, 'Kitchen,WiFi', 4.2);
