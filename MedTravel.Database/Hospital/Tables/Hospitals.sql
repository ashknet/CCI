CREATE TABLE [Hospital].[Hospitals] (
    [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]            NVARCHAR (255)   NOT NULL,
    [Description]     NVARCHAR (2000)  NULL,
    [Address]         NVARCHAR (500)   NOT NULL,
    [CityId]          UNIQUEIDENTIFIER NOT NULL,
    [CountryId]       UNIQUEIDENTIFIER NOT NULL,
    [PostalCode]      NVARCHAR (20)    NULL,
    [Latitude]        DECIMAL (10, 7)  NULL,
    [Longitude]       DECIMAL (10, 7)  NULL,
    [Phone]           NVARCHAR (20)    NULL,
    [Email]           NVARCHAR (255)   NULL,
    [Website]         NVARCHAR (500)   NULL,
    [BedCapacity]     INT              NULL,
    [YearEstablished] INT              NULL,
    [AverageRating]   DECIMAL (3, 2)   DEFAULT ((0)) NULL,
    [TotalReviews]    INT              DEFAULT ((0)) NULL,
    [IsActive]        BIT              DEFAULT ((1)) NULL,
    [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]       DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_Hospitals_City] FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities] ([Id]),
    CONSTRAINT [FK_Hospital_Hospitals_Country] FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries] ([Id])
);




GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Hospitals_City]
    ON [Hospital].[Hospitals]([CityId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Hospitals_Name]
    ON [Hospital].[Hospitals]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospitals_Search]
    ON [Hospital].[Hospitals]([Name] ASC, [IsActive] ASC)
    INCLUDE([Id], [Description], [Address], [AverageRating]);

