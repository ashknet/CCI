CREATE TABLE [Metadata].[AccreditationBodies] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]        NVARCHAR (200)   NOT NULL,
    [Acronym]     NVARCHAR (20)    NULL,
    [Description] NVARCHAR (1000)  NULL,
    [Website]     NVARCHAR (500)   NULL,
    [IsActive]    BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC)
);

