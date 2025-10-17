CREATE TABLE [TAService].[Flights] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [FlightNumber]       NVARCHAR (20)    NOT NULL,
    [AirlineId]          UNIQUEIDENTIFIER NOT NULL,
    [DepartureAirportId] UNIQUEIDENTIFIER NOT NULL,
    [ArrivalAirportId]   UNIQUEIDENTIFIER NOT NULL,
    [DepartureTime]      DATETIME2 (7)    NOT NULL,
    [ArrivalTime]        DATETIME2 (7)    NOT NULL,
    [DurationMinutes]    INT              NULL,
    [Price]              DECIMAL (18, 2)  NOT NULL,
    [CurrencyId]         UNIQUEIDENTIFIER NOT NULL,
    [AvailableSeats]     INT              NULL,
    [FlightClass]        NVARCHAR (20)    NULL,
    [IsDirect]           BIT              DEFAULT ((1)) NULL,
    [IsActive]           BIT              DEFAULT ((1)) NULL,
    [CreatedAt]          DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]          DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TAService_Flights_Airline] FOREIGN KEY ([AirlineId]) REFERENCES [Metadata].[Airlines] ([Id]),
    CONSTRAINT [FK_TAService_Flights_ArrivalAirport] FOREIGN KEY ([ArrivalAirportId]) REFERENCES [Metadata].[Airports] ([Id]),
    CONSTRAINT [FK_TAService_Flights_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id]),
    CONSTRAINT [FK_TAService_Flights_DepartureAirport] FOREIGN KEY ([DepartureAirportId]) REFERENCES [Metadata].[Airports] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Flights_Route]
    ON [TAService].[Flights]([DepartureAirportId] ASC, [ArrivalAirportId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Flights_DepartureTime]
    ON [TAService].[Flights]([DepartureTime] ASC);

