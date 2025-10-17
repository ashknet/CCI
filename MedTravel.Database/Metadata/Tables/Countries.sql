CREATE TABLE [Metadata].[Countries] (
    [Id]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Code]     NVARCHAR (3)     NOT NULL,
    [Name]     NVARCHAR (100)   NOT NULL,
    [Region]   NVARCHAR (50)    NULL,
    [IsActive] BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Countries_Code]
    ON [Metadata].[Countries]([Code] ASC);

