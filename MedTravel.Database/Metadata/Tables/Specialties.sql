CREATE TABLE [Metadata].[Specialties] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]        NVARCHAR (100)   NOT NULL,
    [Description] NVARCHAR (1000)  NULL,
    [IconUrl]     NVARCHAR (500)   NULL,
    [Category]    NVARCHAR (50)    NULL,
    [SortOrder]   INT              DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Name] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Metadata_Specialties_Name]
    ON [Metadata].[Specialties]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Specialties_Category]
    ON [Metadata].[Specialties]([Category] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Specialties_Search]
    ON [Metadata].[Specialties]([Name] ASC)
    INCLUDE([Id], [Description], [Category]);

