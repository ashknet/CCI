CREATE TABLE [Hospital].[Appointments] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]           UNIQUEIDENTIFIER NOT NULL,
    [PatientId]          UNIQUEIDENTIFIER NOT NULL,
    [ScheduledDate]      DATE             NOT NULL,
    [ScheduledTime]      TIME (7)         NOT NULL,
    [DurationMinutes]    INT              DEFAULT ((30)) NULL,
    [Status]             NVARCHAR (20)    DEFAULT ('scheduled') NULL,
    [ReasonForVisit]     NVARCHAR (500)   NULL,
    [Notes]              NVARCHAR (2000)  NULL,
    [Fee]                DECIMAL (18, 2)  NULL,
    [IsPaid]             BIT              DEFAULT ((0)) NULL,
    [PaidAt]             DATETIME2 (7)    NULL,
    [CancellationReason] NVARCHAR (500)   NULL,
    [CancelledAt]        DATETIME2 (7)    NULL,
    [CreatedAt]          DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]          DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_Appointments_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Appointments_DoctorId]
    ON [Hospital].[Appointments]([DoctorId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Appointments_PatientId]
    ON [Hospital].[Appointments]([PatientId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Appointments_Date_Status]
    ON [Hospital].[Appointments]([ScheduledDate] ASC, [Status] ASC);

