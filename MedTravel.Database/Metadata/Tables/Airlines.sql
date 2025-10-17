CREATE TABLE [Metadata].[Airlines] (
    [Id]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Code]     NVARCHAR (3)     NOT NULL,
    [Name]     NVARCHAR (100)   NOT NULL,
    [Country]  NVARCHAR (100)   NULL,
    [IsActive] BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC)
);

