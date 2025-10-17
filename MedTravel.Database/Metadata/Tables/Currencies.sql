CREATE TABLE [Metadata].[Currencies] (
    [Id]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Code]     NVARCHAR (3)     NOT NULL,
    [Name]     NVARCHAR (50)    NOT NULL,
    [Symbol]   NVARCHAR (10)    NULL,
    [IsActive] BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Metadata_Currencies_Code]
    ON [Metadata].[Currencies]([Code] ASC);

