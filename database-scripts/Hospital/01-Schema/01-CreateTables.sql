-- =============================================
-- MedTravel Platform - Hospital Service Database
-- Schema Creation Script
-- =============================================

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'HospitalDb')
BEGIN
    CREATE DATABASE HospitalDb;
END
GO

USE HospitalDb;
GO

-- =============================================
-- 1. Hospitals Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Hospitals]'))
BEGIN
    CREATE TABLE [dbo].[Hospitals] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(2000),
        [Address] NVARCHAR(500) NOT NULL,
        [City] NVARCHAR(100) NOT NULL,
        [State] NVARCHAR(100),
        [Country] NVARCHAR(100) NOT NULL,
        [PostalCode] NVARCHAR(20),
        [Latitude] DECIMAL(10,7),
        [Longitude] DECIMAL(10,7),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(255),
        [Website] NVARCHAR(500),
        [BedCapacity] INT,
        [YearEstablished] INT,
        [AverageRating] DECIMAL(3,2) DEFAULT 0,
        [TotalReviews] INT DEFAULT 0,
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Hospitals_City ON [dbo].[Hospitals]([City]);
    CREATE INDEX IX_Hospitals_Name ON [dbo].[Hospitals]([Name]);
    CREATE INDEX IX_Hospitals_Rating ON [dbo].[Hospitals]([AverageRating] DESC);
    CREATE INDEX IX_Hospitals_Location ON [dbo].[Hospitals]([Latitude], [Longitude]);
END
GO

-- =============================================
-- 2. Specialties Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Specialties]'))
BEGIN
    CREATE TABLE [dbo].[Specialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL UNIQUE,
        [Description] NVARCHAR(1000),
        [IconUrl] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    
    CREATE UNIQUE INDEX IX_Specialties_Name ON [dbo].[Specialties]([Name]);
END
GO

-- =============================================
-- 3. Languages Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Languages]'))
BEGIN
    CREATE TABLE [dbo].[Languages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(50) NOT NULL UNIQUE,
        [Code] NVARCHAR(10) NOT NULL UNIQUE,
        [IsActive] BIT DEFAULT 1
    );
    
    CREATE UNIQUE INDEX IX_Languages_Code ON [dbo].[Languages]([Code]);
END
GO

-- =============================================
-- 4. Departments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Departments]'))
BEGIN
    CREATE TABLE [dbo].[Departments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NOT NULL,
        [Name] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(1000),
        [HeadOfDepartment] NVARCHAR(200),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(255),
        [FloorNumber] INT,
        [BedCount] INT,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Departments_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [dbo].[Hospitals]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Departments_HospitalId ON [dbo].[Departments]([HospitalId]);
END
GO

-- =============================================
-- 5. Doctors Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Doctors]'))
BEGIN
    CREATE TABLE [dbo].[Doctors] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NOT NULL,
        [FirstName] NVARCHAR(100) NOT NULL,
        [LastName] NVARCHAR(100) NOT NULL,
        [Email] NVARCHAR(255) NOT NULL,
        [Phone] NVARCHAR(20),
        [Qualification] NVARCHAR(200),
        [YearsOfExperience] INT,
        [Biography] NVARCHAR(2000),
        [ProfileImageUrl] NVARCHAR(500),
        [ConsultationFee] DECIMAL(18,2),
        [AverageRating] DECIMAL(3,2) DEFAULT 0,
        [TotalReviews] INT DEFAULT 0,
        [IsAcceptingPatients] BIT DEFAULT 1,
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_Doctors_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [dbo].[Hospitals]([Id])
    );
    
    CREATE INDEX IX_Doctors_HospitalId ON [dbo].[Doctors]([HospitalId]);
    CREATE INDEX IX_Doctors_Name ON [dbo].[Doctors]([FirstName], [LastName]);
    CREATE INDEX IX_Doctors_Rating ON [dbo].[Doctors]([AverageRating] DESC);
END
GO

-- =============================================
-- 6. DoctorSpecialties Table (Many-to-Many)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoctorSpecialties]'))
BEGIN
    CREATE TABLE [dbo].[DoctorSpecialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary] BIT DEFAULT 0,
        [YearsOfExperience] INT,
        CONSTRAINT FK_DoctorSpecialties_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_DoctorSpecialties_Specialty FOREIGN KEY ([SpecialtyId]) REFERENCES [dbo].[Specialties]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_DoctorSpecialty UNIQUE ([DoctorId], [SpecialtyId])
    );
    
    CREATE INDEX IX_DoctorSpecialties_DoctorId ON [dbo].[DoctorSpecialties]([DoctorId]);
    CREATE INDEX IX_DoctorSpecialties_SpecialtyId ON [dbo].[DoctorSpecialties]([SpecialtyId]);
END
GO

-- =============================================
-- 7. DoctorLanguages Table (Many-to-Many)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoctorLanguages]'))
BEGIN
    CREATE TABLE [dbo].[DoctorLanguages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [LanguageId] UNIQUEIDENTIFIER NOT NULL,
        [ProficiencyLevel] NVARCHAR(20) DEFAULT 'Fluent',
        CONSTRAINT FK_DoctorLanguages_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_DoctorLanguages_Language FOREIGN KEY ([LanguageId]) REFERENCES [dbo].[Languages]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_DoctorLanguage UNIQUE ([DoctorId], [LanguageId])
    );
    
    CREATE INDEX IX_DoctorLanguages_DoctorId ON [dbo].[DoctorLanguages]([DoctorId]);
END
GO

-- =============================================
-- 8. Credentials Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Credentials]'))
BEGIN
    CREATE TABLE [dbo].[Credentials] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [Type] NVARCHAR(50) NOT NULL,
        [Name] NVARCHAR(200) NOT NULL,
        [IssuingOrganization] NVARCHAR(200),
        [IssueDate] DATE,
        [ExpiryDate] DATE,
        [CredentialNumber] NVARCHAR(100),
        [DocumentUrl] NVARCHAR(500),
        [IsVerified] BIT DEFAULT 0,
        [VerifiedBy] NVARCHAR(200),
        [VerifiedAt] DATETIME2,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Credentials_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Credentials_DoctorId ON [dbo].[Credentials]([DoctorId]);
END
GO

-- =============================================
-- 9. Appointments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Appointments]'))
BEGIN
    CREATE TABLE [dbo].[Appointments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [PatientId] UNIQUEIDENTIFIER NOT NULL,
        [ScheduledDate] DATE NOT NULL,
        [ScheduledTime] TIME NOT NULL,
        [DurationMinutes] INT DEFAULT 30,
        [Status] NVARCHAR(20) DEFAULT 'scheduled', -- scheduled, confirmed, cancelled, completed
        [ReasonForVisit] NVARCHAR(500),
        [Notes] NVARCHAR(2000),
        [Fee] DECIMAL(18,2),
        [IsPaid] BIT DEFAULT 0,
        [PaidAt] DATETIME2 NULL,
        [CancellationReason] NVARCHAR(500),
        [CancelledAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_Appointments_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id])
    );
    
    CREATE INDEX IX_Appointments_DoctorId ON [dbo].[Appointments]([DoctorId]);
    CREATE INDEX IX_Appointments_PatientId ON [dbo].[Appointments]([PatientId]);
    CREATE INDEX IX_Appointments_Date_Status ON [dbo].[Appointments]([ScheduledDate], [Status]);
    CREATE INDEX IX_Appointments_Status ON [dbo].[Appointments]([Status]);
END
GO

-- =============================================
-- 10. DoctorAvailability Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DoctorAvailability]'))
BEGIN
    CREATE TABLE [dbo].[DoctorAvailability] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [DayOfWeek] INT NOT NULL, -- 0=Sunday, 6=Saturday
        [StartTime] TIME NOT NULL,
        [EndTime] TIME NOT NULL,
        [SlotDurationMinutes] INT DEFAULT 30,
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_DoctorAvailability_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_DoctorAvailability_DoctorId ON [dbo].[DoctorAvailability]([DoctorId]);
END
GO

-- =============================================
-- 11. Reviews Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reviews]'))
BEGIN
    CREATE TABLE [dbo].[Reviews] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NULL,
        [DoctorId] UNIQUEIDENTIFIER NULL,
        [PatientId] UNIQUEIDENTIFIER NOT NULL,
        [Rating] INT NOT NULL CHECK ([Rating] BETWEEN 1 AND 5),
        [Title] NVARCHAR(200),
        [Comment] NVARCHAR(2000),
        [TreatmentDate] DATE,
        [IsVerified] BIT DEFAULT 0,
        [IsApproved] BIT DEFAULT 0,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Reviews_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [dbo].[Hospitals]([Id]) ON DELETE NO ACTION,
        CONSTRAINT FK_Reviews_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctors]([Id]) ON DELETE NO ACTION
    );
    
    CREATE INDEX IX_Reviews_HospitalId ON [dbo].[Reviews]([HospitalId]);
    CREATE INDEX IX_Reviews_DoctorId ON [dbo].[Reviews]([DoctorId]);
    CREATE INDEX IX_Reviews_PatientId ON [dbo].[Reviews]([PatientId]);
    CREATE INDEX IX_Reviews_Rating ON [dbo].[Reviews]([Rating] DESC);
END
GO

-- =============================================
-- 12. HospitalAccreditations Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HospitalAccreditations]'))
BEGIN
    CREATE TABLE [dbo].[HospitalAccreditations] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NOT NULL,
        [AccreditationBody] NVARCHAR(200) NOT NULL,
        [AccreditationType] NVARCHAR(100) NOT NULL,
        [CertificateNumber] NVARCHAR(100),
        [IssuedDate] DATE,
        [ExpiryDate] DATE,
        [Status] NVARCHAR(20) DEFAULT 'active',
        [DocumentUrl] NVARCHAR(500),
        CONSTRAINT FK_HospitalAccreditations_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [dbo].[Hospitals]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_HospitalAccreditations_HospitalId ON [dbo].[HospitalAccreditations]([HospitalId]);
END
GO

-- =============================================
-- 13. Diseases Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Diseases]'))
BEGIN
    CREATE TABLE [dbo].[Diseases] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(200) NOT NULL,
        [Category] NVARCHAR(100),
        [Description] NVARCHAR(2000),
        [Symptoms] NVARCHAR(MAX), -- JSON array
        [ICD10Code] NVARCHAR(20),
        [TreatmentOptions] NVARCHAR(MAX), -- JSON array
        [AverageTreatmentCost] DECIMAL(18,2),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
    );
    
    CREATE INDEX IX_Diseases_Name ON [dbo].[Diseases]([Name]);
    CREATE INDEX IX_Diseases_Category ON [dbo].[Diseases]([Category]);
END
GO

-- =============================================
-- 14. DiseaseSpecialties Table (Many-to-Many)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DiseaseSpecialties]'))
BEGIN
    CREATE TABLE [dbo].[DiseaseSpecialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DiseaseId] UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_DiseaseSpecialties_Disease FOREIGN KEY ([DiseaseId]) REFERENCES [dbo].[Diseases]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_DiseaseSpecialties_Specialty FOREIGN KEY ([SpecialtyId]) REFERENCES [dbo].[Specialties]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_DiseaseSpecialty UNIQUE ([DiseaseId], [SpecialtyId])
    );
END
GO

-- =============================================
-- 15. AppointmentReminders Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppointmentReminders]'))
BEGIN
    CREATE TABLE [dbo].[AppointmentReminders] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [AppointmentId] UNIQUEIDENTIFIER NOT NULL,
        [ReminderType] NVARCHAR(20) NOT NULL, -- email, sms, push
        [ScheduledFor] DATETIME2 NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [SentAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_AppointmentReminders_Appointment FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[Appointments]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_AppointmentReminders_AppointmentId ON [dbo].[AppointmentReminders]([AppointmentId]);
    CREATE INDEX IX_AppointmentReminders_ScheduledFor ON [dbo].[AppointmentReminders]([ScheduledFor]);
    CREATE INDEX IX_AppointmentReminders_Status ON [dbo].[AppointmentReminders]([Status]);
END
GO

PRINT 'Hospital Service schema created successfully';
GO
