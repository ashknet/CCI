CREATE TABLE [Hospital].[DoctorSpecialties] (
    [Id]                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]          UNIQUEIDENTIFIER NOT NULL,
    [SpecialtyId]       UNIQUEIDENTIFIER NOT NULL,
    [IsPrimary]         BIT              DEFAULT ((0)) NULL,
    [YearsOfExperience] INT              NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_DoctorSpecialties_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Hospital_DoctorSpecialties_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id]),
    CONSTRAINT [UQ_Hospital_DoctorSpecialty] UNIQUE NONCLUSTERED ([DoctorId] ASC, [SpecialtyId] ASC)
);

