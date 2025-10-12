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
