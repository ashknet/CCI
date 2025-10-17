CREATE TABLE [TAService].[HotelRooms] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [HotelId]        UNIQUEIDENTIFIER NOT NULL,
    [RoomType]       NVARCHAR (50)    NOT NULL,
    [Description]    NVARCHAR (1000)  NULL,
    [PricePerNight]  DECIMAL (18, 2)  NOT NULL,
    [CurrencyId]     UNIQUEIDENTIFIER NOT NULL,
    [MaxOccupancy]   INT              NULL,
    [TotalRooms]     INT              NULL,
    [AvailableRooms] INT              NULL,
    [Amenities]      NVARCHAR (MAX)   NULL,
    [Images]         NVARCHAR (MAX)   NULL,
    [IsActive]       BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TAService_HotelRooms_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id]),
    CONSTRAINT [FK_TAService_HotelRooms_Hotel] FOREIGN KEY ([HotelId]) REFERENCES [TAService].[Hotels] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_HotelRooms_HotelId]
    ON [TAService].[HotelRooms]([HotelId] ASC);

