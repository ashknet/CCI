CREATE TABLE [Metadata].[Cities] (
    [Id]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [CountryId] UNIQUEIDENTIFIER NOT NULL,
    [Name]      NVARCHAR (100)   NOT NULL,
    [State]     NVARCHAR (100)   NULL,
    [Latitude]  DECIMAL (10, 7)  NULL,
    [Longitude] DECIMAL (10, 7)  NULL,
    [IsActive]  BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Metadata_Cities_Country] FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries] ([Id])
);




GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Cities_CountryId]
    ON [Metadata].[Cities]([CountryId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Cities_Name]
    ON [Metadata].[Cities]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Cities_Search]
    ON [Metadata].[Cities]([Name] ASC, [IsActive] ASC)
    INCLUDE([Id], [State]);

