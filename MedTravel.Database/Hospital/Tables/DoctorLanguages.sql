CREATE TABLE [Hospital].[DoctorLanguages] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]         UNIQUEIDENTIFIER NOT NULL,
    [LanguageId]       UNIQUEIDENTIFIER NOT NULL,
    [ProficiencyLevel] NVARCHAR (20)    DEFAULT ('Fluent') NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_DoctorLanguages_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Hospital_DoctorLanguages_Language] FOREIGN KEY ([LanguageId]) REFERENCES [Metadata].[Languages] ([Id]),
    CONSTRAINT [UQ_Hospital_DoctorLanguage] UNIQUE NONCLUSTERED ([DoctorId] ASC, [LanguageId] ASC)
);

