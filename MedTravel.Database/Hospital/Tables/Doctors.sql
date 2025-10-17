CREATE TABLE [Hospital].[Doctors] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [HospitalId]          UNIQUEIDENTIFIER NOT NULL,
    [FirstName]           NVARCHAR (100)   NOT NULL,
    [LastName]            NVARCHAR (100)   NOT NULL,
    [Email]               NVARCHAR (255)   NOT NULL,
    [Phone]               NVARCHAR (20)    NULL,
    [Qualification]       NVARCHAR (200)   NULL,
    [YearsOfExperience]   INT              NULL,
    [Biography]           NVARCHAR (2000)  NULL,
    [ProfileImageUrl]     NVARCHAR (500)   NULL,
    [ConsultationFee]     DECIMAL (18, 2)  NULL,
    [AverageRating]       DECIMAL (3, 2)   DEFAULT ((0)) NULL,
    [TotalReviews]        INT              DEFAULT ((0)) NULL,
    [IsAcceptingPatients] BIT              DEFAULT ((1)) NULL,
    [IsActive]            BIT              DEFAULT ((1)) NULL,
    [CreatedAt]           DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]           DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_Doctors_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Doctors_HospitalId]
    ON [Hospital].[Doctors]([HospitalId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Doctors_Name]
    ON [Hospital].[Doctors]([FirstName] ASC, [LastName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Doctors_Search]
    ON [Hospital].[Doctors]([FirstName] ASC, [LastName] ASC, [IsActive] ASC)
    INCLUDE([Qualification], [Biography], [AverageRating]);

