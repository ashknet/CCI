CREATE TABLE [TAService].[TransportBookings] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]           UNIQUEIDENTIFIER NOT NULL,
    [BookingType]      NVARCHAR (20)    NOT NULL,
    [ReferenceId]      UNIQUEIDENTIFIER NULL,
    [PassengerName]    NVARCHAR (200)   NOT NULL,
    [PassengerEmail]   NVARCHAR (255)   NULL,
    [PassengerPhone]   NVARCHAR (20)    NULL,
    [DepartureFrom]    NVARCHAR (100)   NOT NULL,
    [ArrivalTo]        NVARCHAR (100)   NOT NULL,
    [DepartureTime]    DATETIME2 (7)    NOT NULL,
    [ArrivalTime]      DATETIME2 (7)    NOT NULL,
    [Price]            DECIMAL (18, 2)  NOT NULL,
    [CurrencyId]       UNIQUEIDENTIFIER NOT NULL,
    [Status]           NVARCHAR (20)    DEFAULT ('pending') NULL,
    [BookingReference] NVARCHAR (50)    NULL,
    [PNR]              NVARCHAR (50)    NULL,
    [PaymentId]        NVARCHAR (100)   NULL,
    [IsPaid]           BIT              DEFAULT ((0)) NULL,
    [CreatedAt]        DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]        DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TAService_TransportBookings_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_TransportBookings_UserId]
    ON [TAService].[TransportBookings]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_TransportBookings_Status]
    ON [TAService].[TransportBookings]([Status] ASC);

