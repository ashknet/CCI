CREATE TABLE [TAService].[AccommodationBookings] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]           UNIQUEIDENTIFIER NOT NULL,
    [HotelId]          UNIQUEIDENTIFIER NOT NULL,
    [RoomId]           UNIQUEIDENTIFIER NOT NULL,
    [CheckInDate]      DATE             NOT NULL,
    [CheckOutDate]     DATE             NOT NULL,
    [NumberOfGuests]   INT              NOT NULL,
    [NumberOfRooms]    INT              DEFAULT ((1)) NULL,
    [TotalPrice]       DECIMAL (18, 2)  NOT NULL,
    [CurrencyId]       UNIQUEIDENTIFIER NOT NULL,
    [Status]           NVARCHAR (20)    DEFAULT ('pending') NULL,
    [BookingReference] NVARCHAR (50)    NULL,
    [GuestName]        NVARCHAR (200)   NULL,
    [GuestEmail]       NVARCHAR (255)   NULL,
    [GuestPhone]       NVARCHAR (20)    NULL,
    [SpecialRequests]  NVARCHAR (1000)  NULL,
    [PaymentId]        NVARCHAR (100)   NULL,
    [IsPaid]           BIT              DEFAULT ((0)) NULL,
    [CreatedAt]        DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]        DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TAService_AccommodationBookings_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id]),
    CONSTRAINT [FK_TAService_AccommodationBookings_Hotel] FOREIGN KEY ([HotelId]) REFERENCES [TAService].[Hotels] ([Id]),
    CONSTRAINT [FK_TAService_AccommodationBookings_Room] FOREIGN KEY ([RoomId]) REFERENCES [TAService].[HotelRooms] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_AccommodationBookings_UserId]
    ON [TAService].[AccommodationBookings]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_AccommodationBookings_CheckIn]
    ON [TAService].[AccommodationBookings]([CheckInDate] ASC);

