CREATE TABLE [Metadata].[Languages] (
    [Id]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Code]       NVARCHAR (10)    NOT NULL,
    [Name]       NVARCHAR (50)    NOT NULL,
    [NativeName] NVARCHAR (50)    NULL,
    [IsActive]   BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Metadata_Languages_Code]
    ON [Metadata].[Languages]([Code] ASC);

