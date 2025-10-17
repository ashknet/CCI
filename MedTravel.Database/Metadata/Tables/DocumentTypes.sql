CREATE TABLE [Metadata].[DocumentTypes] (
    [Id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]          NVARCHAR (100)   NOT NULL,
    [Description]   NVARCHAR (500)   NULL,
    [Category]      NVARCHAR (50)    NULL,
    [IsRequired]    BIT              DEFAULT ((0)) NULL,
    [MaxFileSizeMB] INT              DEFAULT ((5)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC)
);

