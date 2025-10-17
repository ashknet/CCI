CREATE TABLE [Hospital].[Reviews] (
    [Id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [HospitalId]    UNIQUEIDENTIFIER NULL,
    [DoctorId]      UNIQUEIDENTIFIER NULL,
    [PatientId]     UNIQUEIDENTIFIER NOT NULL,
    [Rating]        INT              NOT NULL,
    [Title]         NVARCHAR (200)   NULL,
    [Comment]       NVARCHAR (2000)  NULL,
    [TreatmentDate] DATE             NULL,
    [IsVerified]    BIT              DEFAULT ((0)) NULL,
    [IsApproved]    BIT              DEFAULT ((0)) NULL,
    [CreatedAt]     DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CHECK ([Rating]>=(1) AND [Rating]<=(5)),
    CONSTRAINT [FK_Hospital_Reviews_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]),
    CONSTRAINT [FK_Hospital_Reviews_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Reviews_HospitalId]
    ON [Hospital].[Reviews]([HospitalId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Reviews_DoctorId]
    ON [Hospital].[Reviews]([DoctorId] ASC);

