CREATE TABLE [Metadata].[DiseaseSpecialties] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DiseaseId]   UNIQUEIDENTIFIER NOT NULL,
    [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Metadata_DiseaseSpecialties_Disease] FOREIGN KEY ([DiseaseId]) REFERENCES [Metadata].[Diseases] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Metadata_DiseaseSpecialties_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_Metadata_DiseaseSpecialty] UNIQUE NONCLUSTERED ([DiseaseId] ASC, [SpecialtyId] ASC)
);

