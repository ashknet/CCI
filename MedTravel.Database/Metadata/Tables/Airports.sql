CREATE TABLE [Metadata].[Airports] (
    [Id]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Code]      NVARCHAR (3)     NOT NULL,
    [Name]      NVARCHAR (200)   NOT NULL,
    [CityId]    UNIQUEIDENTIFIER NULL,
    [CountryId] UNIQUEIDENTIFIER NOT NULL,
    [Latitude]  DECIMAL (10, 7)  NULL,
    [Longitude] DECIMAL (10, 7)  NULL,
    [IsActive]  BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Metadata_Airports_City] FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities] ([Id]),
    CONSTRAINT [FK_Metadata_Airports_Country] FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries] ([Id]),
    UNIQUE NONCLUSTERED ([Code] ASC)
);

