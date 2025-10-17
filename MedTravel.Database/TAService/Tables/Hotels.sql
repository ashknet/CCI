CREATE TABLE [TAService].[Hotels] (
    [Id]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]                 NVARCHAR (200)   NOT NULL,
    [Description]          NVARCHAR (2000)  NULL,
    [Address]              NVARCHAR (500)   NOT NULL,
    [CityId]               UNIQUEIDENTIFIER NOT NULL,
    [CountryId]            UNIQUEIDENTIFIER NOT NULL,
    [PostalCode]           NVARCHAR (20)    NULL,
    [Latitude]             DECIMAL (10, 7)  NULL,
    [Longitude]            DECIMAL (10, 7)  NULL,
    [Phone]                NVARCHAR (20)    NULL,
    [Email]                NVARCHAR (255)   NULL,
    [Website]              NVARCHAR (500)   NULL,
    [StarRating]           INT              NULL,
    [AverageRating]        DECIMAL (3, 2)   DEFAULT ((0)) NULL,
    [TotalReviews]         INT              DEFAULT ((0)) NULL,
    [Amenities]            NVARCHAR (MAX)   NULL,
    [NearHospitalId]       UNIQUEIDENTIFIER NULL,
    [DistanceToHospitalKm] DECIMAL (5, 2)   NULL,
    [IsActive]             BIT              DEFAULT ((1)) NULL,
    [CreatedAt]            DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]            DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CHECK ([StarRating]>=(1) AND [StarRating]<=(5)),
    CONSTRAINT [FK_TAService_Hotels_City] FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities] ([Id]),
    CONSTRAINT [FK_TAService_Hotels_Country] FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Hotels_City]
    ON [TAService].[Hotels]([CityId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Hotels_Location]
    ON [TAService].[Hotels]([Latitude] ASC, [Longitude] ASC);

