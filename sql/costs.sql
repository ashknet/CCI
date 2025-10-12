-- Cost Service SQL schema
CREATE SCHEMA costs AUTHORIZATION dbo;

CREATE TABLE costs.TreatmentCosts (
  Id BIGINT IDENTITY(1,1) PRIMARY KEY,
  Disease NVARCHAR(256) NOT NULL,
  MinCost DECIMAL(12,2) NOT NULL,
  MaxCost DECIMAL(12,2) NOT NULL,
  Currency NVARCHAR(8) NOT NULL DEFAULT 'INR'
);

GO

CREATE OR ALTER PROCEDURE costs.sp_Estimate
  @Disease NVARCHAR(256),
  @Travel DECIMAL(12,2),
  @Nights INT,
  @HotelPerNight DECIMAL(12,2)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @t TABLE (MinCost DECIMAL(12,2), MaxCost DECIMAL(12,2), Currency NVARCHAR(8));
  INSERT INTO @t SELECT MinCost, MaxCost, Currency FROM costs.TreatmentCosts WHERE Disease=@Disease;
  SELECT TOP 1
    (MinCost + @Travel + (@Nights * @HotelPerNight)) AS EstimatedMin,
    (MaxCost + @Travel + (@Nights * @HotelPerNight)) AS EstimatedMax,
    Currency
  FROM @t;
END
GO
