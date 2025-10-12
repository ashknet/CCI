-- Transport Service SQL schema
CREATE SCHEMA transport AUTHORIZATION dbo;

CREATE TABLE transport.Airlines (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(8) NOT NULL,
    Name NVARCHAR(128) NOT NULL
);

CREATE TABLE transport.Flights (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    AirlineId BIGINT NOT NULL REFERENCES transport.Airlines(Id),
    FromCity NVARCHAR(128) NOT NULL,
    ToCity NVARCHAR(128) NOT NULL,
    DepartAtUtc DATETIME2 NOT NULL,
    ArriveAtUtc DATETIME2 NOT NULL,
    Price DECIMAL(12,2) NOT NULL
);

CREATE TABLE transport.Trains (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    TrainNo NVARCHAR(16) NOT NULL,
    FromCity NVARCHAR(128) NOT NULL,
    ToCity NVARCHAR(128) NOT NULL,
    DepartAt DATETIME2 NOT NULL,
    ArriveAt DATETIME2 NOT NULL,
    Price DECIMAL(12,2) NOT NULL
);

CREATE TABLE transport.Buses (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Operator NVARCHAR(128) NOT NULL,
    FromCity NVARCHAR(128) NOT NULL,
    ToCity NVARCHAR(128) NOT NULL,
    DepartAt DATETIME2 NOT NULL,
    ArriveAt DATETIME2 NOT NULL,
    Price DECIMAL(12,2) NOT NULL
);

GO

CREATE OR ALTER PROCEDURE transport.sp_GetOptions
    @FromCity NVARCHAR(128),
    @ToCity NVARCHAR(128),
    @DepartDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 10 'flight' AS Type, f.Id, a.Name AS Carrier, f.FromCity, f.ToCity, f.DepartAtUtc, f.ArriveAtUtc, f.Price
    FROM transport.Flights f JOIN transport.Airlines a ON a.Id = f.AirlineId
    WHERE f.FromCity=@FromCity AND f.ToCity=@ToCity AND CAST(f.DepartAtUtc AS DATE)=@DepartDate
    ORDER BY f.Price ASC;

    SELECT TOP 10 'train' AS Type, t.Id, t.TrainNo AS Carrier, t.FromCity, t.ToCity, t.DepartAt, t.ArriveAt, t.Price
    FROM transport.Trains t
    WHERE t.FromCity=@FromCity AND t.ToCity=@ToCity AND CAST(t.DepartAt AS DATE)=@DepartDate
    ORDER BY t.Price ASC;

    SELECT TOP 10 'bus' AS Type, b.Id, b.Operator AS Carrier, b.FromCity, b.ToCity, b.DepartAt, b.ArriveAt, b.Price
    FROM transport.Buses b
    WHERE b.FromCity=@FromCity AND b.ToCity=@ToCity AND CAST(b.DepartAt AS DATE)=@DepartDate
    ORDER BY b.Price ASC;
END
GO
