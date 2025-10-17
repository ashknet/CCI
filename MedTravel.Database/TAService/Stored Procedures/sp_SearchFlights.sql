
-- =============================================
-- STORED PROCEDURES - TASERVICE
-- =============================================

-- SP: Search Flights
CREATE   PROCEDURE [TAService].[sp_SearchFlights]
    @DepartureAirportId UNIQUEIDENTIFIER,
    @ArrivalAirportId UNIQUEIDENTIFIER,
    @DepartureDate DATE,
    @FlightClass NVARCHAR(20) = NULL,
    @MinSeats INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        f.*,
        a.Name AS AirlineName,
        da.Code AS DepartureAirportCode,
        da.Name AS DepartureAirportName,
        aa.Code AS ArrivalAirportCode,
        aa.Name AS ArrivalAirportName,
        cu.Code AS CurrencyCode
    FROM TAService.Flights f
    INNER JOIN Metadata.Airlines a ON f.AirlineId = a.Id
    INNER JOIN Metadata.Airports da ON f.DepartureAirportId = da.Id
    INNER JOIN Metadata.Airports aa ON f.ArrivalAirportId = aa.Id
    INNER JOIN Metadata.Currencies cu ON f.CurrencyId = cu.Id
    WHERE f.DepartureAirportId = @DepartureAirportId
      AND f.ArrivalAirportId = @ArrivalAirportId
      AND CAST(f.DepartureTime AS DATE) = @DepartureDate
      AND (@FlightClass IS NULL OR f.FlightClass = @FlightClass)
      AND f.AvailableSeats >= @MinSeats
      AND f.IsActive = 1
    ORDER BY f.Price, f.DepartureTime;
END
