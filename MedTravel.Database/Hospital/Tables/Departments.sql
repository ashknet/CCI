CREATE TABLE [Hospital].[Departments] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [HospitalId]       UNIQUEIDENTIFIER NOT NULL,
    [SpecialtyId]      UNIQUEIDENTIFIER NOT NULL,
    [HeadOfDepartment] NVARCHAR (200)   NULL,
    [Phone]            NVARCHAR (20)    NULL,
    [Email]            NVARCHAR (255)   NULL,
    [FloorNumber]      INT              NULL,
    [BedCount]         INT              NULL,
    [CreatedAt]        DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_Departments_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Hospital_Departments_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Departments_HospitalId]
    ON [Hospital].[Departments]([HospitalId] ASC);

