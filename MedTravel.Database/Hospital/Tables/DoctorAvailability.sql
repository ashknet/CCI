CREATE TABLE [Hospital].[DoctorAvailability] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]            UNIQUEIDENTIFIER NOT NULL,
    [DayOfWeek]           INT              NOT NULL,
    [StartTime]           TIME (7)         NOT NULL,
    [EndTime]             TIME (7)         NOT NULL,
    [SlotDurationMinutes] INT              DEFAULT ((30)) NULL,
    [IsActive]            BIT              DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_DoctorAvailability_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorAvailability_DoctorId]
    ON [Hospital].[DoctorAvailability]([DoctorId] ASC);

