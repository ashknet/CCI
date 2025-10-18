CREATE TABLE [Hospital].[DoctorDiseases] (
    [Id]                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]          UNIQUEIDENTIFIER NOT NULL,
    [DiseaseId]         UNIQUEIDENTIFIER NOT NULL,
    [IsPrimary]         BIT              DEFAULT ((0)) NULL,
    [YearsOfExperience] INT              NULL,
    [TreatmentNotes]    NVARCHAR (1000)  NULL,
    [CreatedAt]         DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_DoctorDiseases_Disease] FOREIGN KEY ([DiseaseId]) REFERENCES [Metadata].[Diseases] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Hospital_DoctorDiseases_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_Hospital_DoctorDisease] UNIQUE NONCLUSTERED ([DoctorId] ASC, [DiseaseId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorDiseases_Search]
    ON [Hospital].[DoctorDiseases]([DiseaseId] ASC, [IsPrimary] ASC)
    INCLUDE([DoctorId], [YearsOfExperience]);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorDiseases_DiseaseId]
    ON [Hospital].[DoctorDiseases]([DiseaseId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorDiseases_DoctorId]
    ON [Hospital].[DoctorDiseases]([DoctorId] ASC);

