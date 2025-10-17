CREATE TABLE [Metadata].[Diseases] (
    [Id]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]                 NVARCHAR (200)   NOT NULL,
    [Category]             NVARCHAR (100)   NULL,
    [Description]          NVARCHAR (2000)  NULL,
    [Symptoms]             NVARCHAR (MAX)   NULL,
    [ICD10Code]            NVARCHAR (20)    NULL,
    [TreatmentOptions]     NVARCHAR (MAX)   NULL,
    [AverageTreatmentCost] DECIMAL (18, 2)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Diseases_Name]
    ON [Metadata].[Diseases]([Name] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Diseases_Category]
    ON [Metadata].[Diseases]([Category] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Metadata_Diseases_ICD10Code]
    ON [Metadata].[Diseases]([ICD10Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Diseases_Search]
    ON [Metadata].[Diseases]([Name] ASC)
    INCLUDE([Description]);

