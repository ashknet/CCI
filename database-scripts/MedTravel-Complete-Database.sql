-- =============================================
-- MedTravel Platform - Complete Database Script
-- Single Database, Multiple Schemas
-- =============================================
-- This script creates:
--   • MedTravelDb database
--   • 5 schemas (UserManagement, Hospital, TAService, Messaging, Metadata)
--   • All tables (40+)
--   • All stored procedures (19+)
--   • Sample/test data
-- =============================================

SET NOCOUNT ON;
GO

PRINT '======================================================================'
PRINT '  MedTravel Platform - Complete Database Setup'
PRINT '  Single Database, Multiple Schemas'
PRINT '======================================================================'
PRINT ''
GO

USE master;
GO

-- =============================================
-- CREATE DATABASE
-- =============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MedTravelDb')
BEGIN
    CREATE DATABASE MedTravelDb;
    PRINT '✅ Database [MedTravelDb] created';
END
ELSE
BEGIN
    PRINT '⚠️  Database [MedTravelDb] already exists';
END
GO

USE MedTravelDb;
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 1: Creating Schemas'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- CREATE SCHEMAS
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'UserManagement')
BEGIN
    EXEC('CREATE SCHEMA UserManagement');
    PRINT '✅ Schema [UserManagement] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Hospital')
BEGIN
    EXEC('CREATE SCHEMA Hospital');
    PRINT '✅ Schema [Hospital] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'TAService')
BEGIN
    EXEC('CREATE SCHEMA TAService');
    PRINT '✅ Schema [TAService] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Messaging')
BEGIN
    EXEC('CREATE SCHEMA Messaging');
    PRINT '✅ Schema [Messaging] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Metadata')
BEGIN
    EXEC('CREATE SCHEMA Metadata');
    PRINT '✅ Schema [Metadata] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'TestData')
BEGIN
    EXEC('CREATE SCHEMA TestData');
    PRINT '✅ Schema [TestData] created';
END
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 2: Creating Metadata Tables (Lookup/Reference Data)'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- METADATA SCHEMA - Lookup Tables
-- =============================================

-- Countries
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Countries]'))
BEGIN
    CREATE TABLE [Metadata].[Countries] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Code] NVARCHAR(3) NOT NULL UNIQUE,
        [Name] NVARCHAR(100) NOT NULL UNIQUE,
        [Region] NVARCHAR(50),
        [IsActive] BIT DEFAULT 1
    );
    CREATE INDEX IX_Metadata_Countries_Code ON [Metadata].[Countries]([Code]);
    PRINT '✅ Table [Metadata].[Countries] created';
END
GO

-- Cities
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Cities]'))
BEGIN
    CREATE TABLE [Metadata].[Cities] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [CountryId] UNIQUEIDENTIFIER NOT NULL,
        [Name] NVARCHAR(100) NOT NULL,
        [State] NVARCHAR(100),
        [Latitude] DECIMAL(10,7),
        [Longitude] DECIMAL(10,7),
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_Metadata_Cities_Country FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries]([Id])
    );
    CREATE INDEX IX_Metadata_Cities_CountryId ON [Metadata].[Cities]([CountryId]);
    CREATE INDEX IX_Metadata_Cities_Name ON [Metadata].[Cities]([Name]);
    PRINT '✅ Table [Metadata].[Cities] created';
END
GO

-- Languages
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Languages]'))
BEGIN
    CREATE TABLE [Metadata].[Languages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Code] NVARCHAR(10) NOT NULL UNIQUE,
        [Name] NVARCHAR(50) NOT NULL UNIQUE,
        [NativeName] NVARCHAR(50),
        [IsActive] BIT DEFAULT 1
    );
    CREATE UNIQUE INDEX IX_Metadata_Languages_Code ON [Metadata].[Languages]([Code]);
    PRINT '✅ Table [Metadata].[Languages] created';
END
GO

-- Currencies
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Currencies]'))
BEGIN
    CREATE TABLE [Metadata].[Currencies] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Code] NVARCHAR(3) NOT NULL UNIQUE,
        [Name] NVARCHAR(50) NOT NULL,
        [Symbol] NVARCHAR(10),
        [IsActive] BIT DEFAULT 1
    );
    CREATE UNIQUE INDEX IX_Metadata_Currencies_Code ON [Metadata].[Currencies]([Code]);
    PRINT '✅ Table [Metadata].[Currencies] created';
END
GO

-- Medical Specialties
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Specialties]'))
BEGIN
    CREATE TABLE [Metadata].[Specialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL UNIQUE,
        [Description] NVARCHAR(1000),
        [IconUrl] NVARCHAR(500),
        [Category] NVARCHAR(50),
        [SortOrder] INT DEFAULT 0
    );
    CREATE UNIQUE INDEX IX_Metadata_Specialties_Name ON [Metadata].[Specialties]([Name]);
    CREATE INDEX IX_Metadata_Specialties_Category ON [Metadata].[Specialties]([Category]);
    PRINT '✅ Table [Metadata].[Specialties] created';
END
GO

-- Diseases
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Diseases]'))
BEGIN
    CREATE TABLE [Metadata].[Diseases] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(200) NOT NULL,
        [Category] NVARCHAR(100),
        [Description] NVARCHAR(2000),
        [Symptoms] NVARCHAR(MAX),
        [ICD10Code] NVARCHAR(20),
        [TreatmentOptions] NVARCHAR(MAX),
        [AverageTreatmentCost] DECIMAL(18,2)
    );
    CREATE INDEX IX_Metadata_Diseases_Name ON [Metadata].[Diseases]([Name]);
    CREATE INDEX IX_Metadata_Diseases_Category ON [Metadata].[Diseases]([Category]);
    CREATE INDEX IX_Metadata_Diseases_ICD10Code ON [Metadata].[Diseases]([ICD10Code]);
    PRINT '✅ Table [Metadata].[Diseases] created';
END
GO

-- Disease-Specialty Mapping
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[DiseaseSpecialties]'))
BEGIN
    CREATE TABLE [Metadata].[DiseaseSpecialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DiseaseId] UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
        CONSTRAINT FK_Metadata_DiseaseSpecialties_Disease FOREIGN KEY ([DiseaseId]) REFERENCES [Metadata].[Diseases]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Metadata_DiseaseSpecialties_Specialty FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_Metadata_DiseaseSpecialty UNIQUE ([DiseaseId], [SpecialtyId])
    );
    PRINT '✅ Table [Metadata].[DiseaseSpecialties] created';
END
GO

-- Accreditation Bodies
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[AccreditationBodies]'))
BEGIN
    CREATE TABLE [Metadata].[AccreditationBodies] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(200) NOT NULL UNIQUE,
        [Acronym] NVARCHAR(20),
        [Description] NVARCHAR(1000),
        [Website] NVARCHAR(500),
        [IsActive] BIT DEFAULT 1
    );
    PRINT '✅ Table [Metadata].[AccreditationBodies] created';
END
GO

-- Document Types
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[DocumentTypes]'))
BEGIN
    CREATE TABLE [Metadata].[DocumentTypes] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL UNIQUE,
        [Description] NVARCHAR(500),
        [Category] NVARCHAR(50),
        [IsRequired] BIT DEFAULT 0,
        [MaxFileSizeMB] INT DEFAULT 5
    );
    PRINT '✅ Table [Metadata].[DocumentTypes] created';
END
GO

-- Airlines
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Airlines]'))
BEGIN
    CREATE TABLE [Metadata].[Airlines] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Code] NVARCHAR(3) NOT NULL UNIQUE,
        [Name] NVARCHAR(100) NOT NULL,
        [Country] NVARCHAR(100),
        [IsActive] BIT DEFAULT 1
    );
    PRINT '✅ Table [Metadata].[Airlines] created';
END
GO

-- Airports
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Metadata].[Airports]'))
BEGIN
    CREATE TABLE [Metadata].[Airports] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Code] NVARCHAR(3) NOT NULL UNIQUE,
        [Name] NVARCHAR(200) NOT NULL,
        [CityId] UNIQUEIDENTIFIER,
        [CountryId] UNIQUEIDENTIFIER NOT NULL,
        [Latitude] DECIMAL(10,7),
        [Longitude] DECIMAL(10,7),
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_Metadata_Airports_City FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities]([Id]),
        CONSTRAINT FK_Metadata_Airports_Country FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries]([Id])
    );
    PRINT '✅ Table [Metadata].[Airports] created';
END
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 3: Creating UserManagement Schema Tables'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- USER MANAGEMENT SCHEMA
-- =============================================

-- Roles
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Roles]'))
BEGIN
    CREATE TABLE [UserManagement].[Roles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(50) NOT NULL UNIQUE,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    CREATE INDEX IX_UserMgmt_Roles_Name ON [UserManagement].[Roles]([Name]);
    PRINT '✅ Table [UserManagement].[Roles] created';
END
GO

-- Permissions
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Permissions]'))
BEGIN
    CREATE TABLE [UserManagement].[Permissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL,
        [Resource] NVARCHAR(50) NOT NULL,
        [Action] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT UQ_UserMgmt_Permission_Resource_Action UNIQUE ([Resource], [Action])
    );
    CREATE INDEX IX_UserMgmt_Permissions_Resource ON [UserManagement].[Permissions]([Resource]);
    PRINT '✅ Table [UserManagement].[Permissions] created';
END
GO

-- RolePermissions
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[RolePermissions]'))
BEGIN
    CREATE TABLE [UserManagement].[RolePermissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [PermissionId] UNIQUEIDENTIFIER NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserMgmt_RolePermissions_Role FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserMgmt_RolePermissions_Permission FOREIGN KEY ([PermissionId]) REFERENCES [UserManagement].[Permissions]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_UserMgmt_RolePermission UNIQUE ([RoleId], [PermissionId])
    );
    PRINT '✅ Table [UserManagement].[RolePermissions] created';
END
GO

-- Users
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Users]'))
BEGIN
    CREATE TABLE [UserManagement].[Users] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Email] NVARCHAR(255) NOT NULL UNIQUE,
        [PasswordHash] NVARCHAR(500) NOT NULL,
        [FirstName] NVARCHAR(100) NOT NULL,
        [LastName] NVARCHAR(100) NOT NULL,
        [Phone] NVARCHAR(20),
        [DateOfBirth] DATE,
        [Gender] NVARCHAR(20),
        [Nationality] NVARCHAR(100),
        [CountryId] UNIQUEIDENTIFIER,
        [CityId] UNIQUEIDENTIFIER,
        [Address] NVARCHAR(500),
        [PostalCode] NVARCHAR(20),
        [PassportNumber] NVARCHAR(50),
        [EmailVerified] BIT NOT NULL DEFAULT 0,
        [PhoneVerified] BIT NOT NULL DEFAULT 0,
        [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        [LastLoginAt] DATETIME2 NULL,
        CONSTRAINT FK_UserMgmt_Users_Country FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries]([Id]),
        CONSTRAINT FK_UserMgmt_Users_City FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities]([Id])
    );
    CREATE UNIQUE INDEX IX_UserMgmt_Users_Email ON [UserManagement].[Users]([Email]);
    CREATE INDEX IX_UserMgmt_Users_CountryCity ON [UserManagement].[Users]([CountryId], [CityId]);
    PRINT '✅ Table [UserManagement].[Users] created';
END
GO

-- UserRoles
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserRoles]'))
BEGIN
    CREATE TABLE [UserManagement].[UserRoles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [AssignedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [AssignedBy] UNIQUEIDENTIFIER NULL,
        CONSTRAINT FK_UserMgmt_UserRoles_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserMgmt_UserRoles_Role FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_UserMgmt_UserRole UNIQUE ([UserId], [RoleId])
    );
    PRINT '✅ Table [UserManagement].[UserRoles] created';
END
GO

-- Sessions
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Sessions]'))
BEGIN
    CREATE TABLE [UserManagement].[Sessions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RefreshToken] NVARCHAR(500) NOT NULL UNIQUE,
        [DeviceInfo] NVARCHAR(500),
        [IpAddress] NVARCHAR(50),
        [IsActive] BIT NOT NULL DEFAULT 1,
        [ExpiresAt] DATETIME2 NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [RevokedAt] DATETIME2 NULL,
        CONSTRAINT FK_UserMgmt_Sessions_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_UserMgmt_Sessions_UserId ON [UserManagement].[Sessions]([UserId]);
    PRINT '✅ Table [UserManagement].[Sessions] created';
END
GO

-- UserPreferences
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserPreferences]'))
BEGIN
    CREATE TABLE [UserManagement].[UserPreferences] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
        [LanguageId] UNIQUEIDENTIFIER,
        [CurrencyId] UNIQUEIDENTIFIER,
        [EmailNotifications] BIT DEFAULT 1,
        [SmsNotifications] BIT DEFAULT 1,
        [PushNotifications] BIT DEFAULT 1,
        [Theme] NVARCHAR(20) DEFAULT 'light',
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_UserMgmt_UserPreferences_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserMgmt_UserPreferences_Language FOREIGN KEY ([LanguageId]) REFERENCES [Metadata].[Languages]([Id]),
        CONSTRAINT FK_UserMgmt_UserPreferences_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    PRINT '✅ Table [UserManagement].[UserPreferences] created';
END
GO

-- UserDocuments
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserDocuments]'))
BEGIN
    CREATE TABLE [UserManagement].[UserDocuments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [DocumentTypeId] UNIQUEIDENTIFIER NOT NULL,
        [DocumentName] NVARCHAR(255) NOT NULL,
        [DocumentUrl] NVARCHAR(1000) NOT NULL,
        [FileSize] BIGINT,
        [MimeType] NVARCHAR(100),
        [IsVerified] BIT DEFAULT 0,
        [VerifiedBy] UNIQUEIDENTIFIER NULL,
        [VerifiedAt] DATETIME2 NULL,
        [UploadedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserMgmt_UserDocuments_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserMgmt_UserDocuments_Type FOREIGN KEY ([DocumentTypeId]) REFERENCES [Metadata].[DocumentTypes]([Id])
    );
    CREATE INDEX IX_UserMgmt_UserDocuments_UserId ON [UserManagement].[UserDocuments]([UserId]);
    PRINT '✅ Table [UserManagement].[UserDocuments] created';
END
GO

-- InsurancePolicies
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[InsurancePolicies]'))
BEGIN
    CREATE TABLE [UserManagement].[InsurancePolicies] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [ProviderName] NVARCHAR(200) NOT NULL,
        [PolicyNumber] NVARCHAR(100) NOT NULL,
        [CoverageType] NVARCHAR(100),
        [CoverageAmount] DECIMAL(18,2),
        [ValidFrom] DATE NOT NULL,
        [ValidTo] DATE NOT NULL,
        [DocumentUrl] NVARCHAR(1000),
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_UserMgmt_InsurancePolicies_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_UserMgmt_InsurancePolicies_UserId ON [UserManagement].[InsurancePolicies]([UserId]);
    PRINT '✅ Table [UserManagement].[InsurancePolicies] created';
END
GO

-- Notifications
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Notifications]'))
BEGIN
    CREATE TABLE [UserManagement].[Notifications] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [Type] NVARCHAR(50) NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Message] NVARCHAR(2000) NOT NULL,
        [Channel] NVARCHAR(20) NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [IsRead] BIT DEFAULT 0,
        [SentAt] DATETIME2 NULL,
        [ReadAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserMgmt_Notifications_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_UserMgmt_Notifications_UserId ON [UserManagement].[Notifications]([UserId]);
    PRINT '✅ Table [UserManagement].[Notifications] created';
END
GO

-- AuditLogs
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[AuditLogs]'))
BEGIN
    CREATE TABLE [UserManagement].[AuditLogs] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NULL,
        [Action] NVARCHAR(100) NOT NULL,
        [EntityType] NVARCHAR(100),
        [EntityId] NVARCHAR(100),
        [OldValues] NVARCHAR(MAX),
        [NewValues] NVARCHAR(MAX),
        [IpAddress] NVARCHAR(50),
        [UserAgent] NVARCHAR(500),
        [Timestamp] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserMgmt_AuditLogs_User FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE SET NULL
    );
    CREATE INDEX IX_UserMgmt_AuditLogs_Timestamp ON [UserManagement].[AuditLogs]([Timestamp] DESC);
    PRINT '✅ Table [UserManagement].[AuditLogs] created';
END
GO

PRINT ''
PRINT '✅ UserManagement schema - 11 tables created'
PRINT ''
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 4: Creating Hospital Schema Tables'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- HOSPITAL SCHEMA
-- =============================================

-- Hospitals
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Hospitals]'))
BEGIN
    CREATE TABLE [Hospital].[Hospitals] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(255) NOT NULL,
        [Description] NVARCHAR(2000),
        [Address] NVARCHAR(500) NOT NULL,
        [CityId] UNIQUEIDENTIFIER NOT NULL,
        [CountryId] UNIQUEIDENTIFIER NOT NULL,
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
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_Hospital_Hospitals_City FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities]([Id]),
        CONSTRAINT FK_Hospital_Hospitals_Country FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries]([Id])
    );
    CREATE INDEX IX_Hospital_Hospitals_City ON [Hospital].[Hospitals]([CityId]);
    CREATE INDEX IX_Hospital_Hospitals_Name ON [Hospital].[Hospitals]([Name]);
    PRINT '✅ Table [Hospital].[Hospitals] created';
END
GO

-- Departments
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Departments]'))
BEGIN
    CREATE TABLE [Hospital].[Departments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
        [HeadOfDepartment] NVARCHAR(200),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(255),
        [FloorNumber] INT,
        [BedCount] INT,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Hospital_Departments_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Hospital_Departments_Specialty FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties]([Id])
    );
    CREATE INDEX IX_Hospital_Departments_HospitalId ON [Hospital].[Departments]([HospitalId]);
    PRINT '✅ Table [Hospital].[Departments] created';
END
GO

-- Doctors
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Doctors]'))
BEGIN
    CREATE TABLE [Hospital].[Doctors] (
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
        CONSTRAINT FK_Hospital_Doctors_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals]([Id])
    );
    CREATE INDEX IX_Hospital_Doctors_HospitalId ON [Hospital].[Doctors]([HospitalId]);
    CREATE INDEX IX_Hospital_Doctors_Name ON [Hospital].[Doctors]([FirstName], [LastName]);
    PRINT '✅ Table [Hospital].[Doctors] created';
END
GO

-- DoctorSpecialties
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[DoctorSpecialties]'))
BEGIN
    CREATE TABLE [Hospital].[DoctorSpecialties] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId] UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary] BIT DEFAULT 0,
        [YearsOfExperience] INT,
        CONSTRAINT FK_Hospital_DoctorSpecialties_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Hospital_DoctorSpecialties_Specialty FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties]([Id]),
        CONSTRAINT UQ_Hospital_DoctorSpecialty UNIQUE ([DoctorId], [SpecialtyId])
    );
    PRINT '✅ Table [Hospital].[DoctorSpecialties] created';
END
GO

-- DoctorLanguages
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[DoctorLanguages]'))
BEGIN
    CREATE TABLE [Hospital].[DoctorLanguages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [LanguageId] UNIQUEIDENTIFIER NOT NULL,
        [ProficiencyLevel] NVARCHAR(20) DEFAULT 'Fluent',
        CONSTRAINT FK_Hospital_DoctorLanguages_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Hospital_DoctorLanguages_Language FOREIGN KEY ([LanguageId]) REFERENCES [Metadata].[Languages]([Id]),
        CONSTRAINT UQ_Hospital_DoctorLanguage UNIQUE ([DoctorId], [LanguageId])
    );
    PRINT '✅ Table [Hospital].[DoctorLanguages] created';
END
GO

-- Credentials
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Credentials]'))
BEGIN
    CREATE TABLE [Hospital].[Credentials] (
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
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Hospital_Credentials_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_Hospital_Credentials_DoctorId ON [Hospital].[Credentials]([DoctorId]);
    PRINT '✅ Table [Hospital].[Credentials] created';
END
GO

-- Appointments
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Appointments]'))
BEGIN
    CREATE TABLE [Hospital].[Appointments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [PatientId] UNIQUEIDENTIFIER NOT NULL,
        [ScheduledDate] DATE NOT NULL,
        [ScheduledTime] TIME NOT NULL,
        [DurationMinutes] INT DEFAULT 30,
        [Status] NVARCHAR(20) DEFAULT 'scheduled',
        [ReasonForVisit] NVARCHAR(500),
        [Notes] NVARCHAR(2000),
        [Fee] DECIMAL(18,2),
        [IsPaid] BIT DEFAULT 0,
        [PaidAt] DATETIME2 NULL,
        [CancellationReason] NVARCHAR(500),
        [CancelledAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_Hospital_Appointments_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id])
    );
    CREATE INDEX IX_Hospital_Appointments_DoctorId ON [Hospital].[Appointments]([DoctorId]);
    CREATE INDEX IX_Hospital_Appointments_PatientId ON [Hospital].[Appointments]([PatientId]);
    CREATE INDEX IX_Hospital_Appointments_Date_Status ON [Hospital].[Appointments]([ScheduledDate], [Status]);
    PRINT '✅ Table [Hospital].[Appointments] created';
END
GO

-- DoctorAvailability
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[DoctorAvailability]'))
BEGIN
    CREATE TABLE [Hospital].[DoctorAvailability] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [DoctorId] UNIQUEIDENTIFIER NOT NULL,
        [DayOfWeek] INT NOT NULL,
        [StartTime] TIME NOT NULL,
        [EndTime] TIME NOT NULL,
        [SlotDurationMinutes] INT DEFAULT 30,
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_Hospital_DoctorAvailability_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_Hospital_DoctorAvailability_DoctorId ON [Hospital].[DoctorAvailability]([DoctorId]);
    PRINT '✅ Table [Hospital].[DoctorAvailability] created';
END
GO

-- Reviews
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[Reviews]'))
BEGIN
    CREATE TABLE [Hospital].[Reviews] (
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
        CONSTRAINT FK_Hospital_Reviews_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals]([Id]),
        CONSTRAINT FK_Hospital_Reviews_Doctor FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors]([Id])
    );
    CREATE INDEX IX_Hospital_Reviews_HospitalId ON [Hospital].[Reviews]([HospitalId]);
    CREATE INDEX IX_Hospital_Reviews_DoctorId ON [Hospital].[Reviews]([DoctorId]);
    PRINT '✅ Table [Hospital].[Reviews] created';
END
GO

-- HospitalAccreditations
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Hospital].[HospitalAccreditations]'))
BEGIN
    CREATE TABLE [Hospital].[HospitalAccreditations] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HospitalId] UNIQUEIDENTIFIER NOT NULL,
        [AccreditationBodyId] UNIQUEIDENTIFIER NOT NULL,
        [AccreditationType] NVARCHAR(100) NOT NULL,
        [CertificateNumber] NVARCHAR(100),
        [IssuedDate] DATE,
        [ExpiryDate] DATE,
        [Status] NVARCHAR(20) DEFAULT 'active',
        [DocumentUrl] NVARCHAR(500),
        CONSTRAINT FK_Hospital_HospitalAccreditations_Hospital FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_Hospital_HospitalAccreditations_Body FOREIGN KEY ([AccreditationBodyId]) REFERENCES [Metadata].[AccreditationBodies]([Id])
    );
    CREATE INDEX IX_Hospital_HospitalAccreditations_HospitalId ON [Hospital].[HospitalAccreditations]([HospitalId]);
    PRINT '✅ Table [Hospital].[HospitalAccreditations] created';
END
GO

PRINT ''
PRINT '✅ Hospital schema - 11 tables created'
PRINT ''
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 5: Creating TAService Schema Tables'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- TASERVICE SCHEMA
-- =============================================

-- Flights
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[Flights]'))
BEGIN
    CREATE TABLE [TAService].[Flights] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [FlightNumber] NVARCHAR(20) NOT NULL,
        [AirlineId] UNIQUEIDENTIFIER NOT NULL,
        [DepartureAirportId] UNIQUEIDENTIFIER NOT NULL,
        [ArrivalAirportId] UNIQUEIDENTIFIER NOT NULL,
        [DepartureTime] DATETIME2 NOT NULL,
        [ArrivalTime] DATETIME2 NOT NULL,
        [DurationMinutes] INT,
        [Price] DECIMAL(18,2) NOT NULL,
        [CurrencyId] UNIQUEIDENTIFIER NOT NULL,
        [AvailableSeats] INT,
        [FlightClass] NVARCHAR(20),
        [IsDirect] BIT DEFAULT 1,
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_TAService_Flights_Airline FOREIGN KEY ([AirlineId]) REFERENCES [Metadata].[Airlines]([Id]),
        CONSTRAINT FK_TAService_Flights_DepartureAirport FOREIGN KEY ([DepartureAirportId]) REFERENCES [Metadata].[Airports]([Id]),
        CONSTRAINT FK_TAService_Flights_ArrivalAirport FOREIGN KEY ([ArrivalAirportId]) REFERENCES [Metadata].[Airports]([Id]),
        CONSTRAINT FK_TAService_Flights_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    CREATE INDEX IX_TAService_Flights_Route ON [TAService].[Flights]([DepartureAirportId], [ArrivalAirportId]);
    CREATE INDEX IX_TAService_Flights_DepartureTime ON [TAService].[Flights]([DepartureTime]);
    PRINT '✅ Table [TAService].[Flights] created';
END
GO

-- TransportBookings
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[TransportBookings]'))
BEGIN
    CREATE TABLE [TAService].[TransportBookings] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [BookingType] NVARCHAR(20) NOT NULL,
        [ReferenceId] UNIQUEIDENTIFIER NULL,
        [PassengerName] NVARCHAR(200) NOT NULL,
        [PassengerEmail] NVARCHAR(255),
        [PassengerPhone] NVARCHAR(20),
        [DepartureFrom] NVARCHAR(100) NOT NULL,
        [ArrivalTo] NVARCHAR(100) NOT NULL,
        [DepartureTime] DATETIME2 NOT NULL,
        [ArrivalTime] DATETIME2 NOT NULL,
        [Price] DECIMAL(18,2) NOT NULL,
        [CurrencyId] UNIQUEIDENTIFIER NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [BookingReference] NVARCHAR(50),
        [PNR] NVARCHAR(50),
        [PaymentId] NVARCHAR(100),
        [IsPaid] BIT DEFAULT 0,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_TAService_TransportBookings_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    CREATE INDEX IX_TAService_TransportBookings_UserId ON [TAService].[TransportBookings]([UserId]);
    CREATE INDEX IX_TAService_TransportBookings_Status ON [TAService].[TransportBookings]([Status]);
    PRINT '✅ Table [TAService].[TransportBookings] created';
END
GO

-- Hotels
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[Hotels]'))
BEGIN
    CREATE TABLE [TAService].[Hotels] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(2000),
        [Address] NVARCHAR(500) NOT NULL,
        [CityId] UNIQUEIDENTIFIER NOT NULL,
        [CountryId] UNIQUEIDENTIFIER NOT NULL,
        [PostalCode] NVARCHAR(20),
        [Latitude] DECIMAL(10,7),
        [Longitude] DECIMAL(10,7),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(255),
        [Website] NVARCHAR(500),
        [StarRating] INT CHECK ([StarRating] BETWEEN 1 AND 5),
        [AverageRating] DECIMAL(3,2) DEFAULT 0,
        [TotalReviews] INT DEFAULT 0,
        [Amenities] NVARCHAR(MAX),
        [NearHospitalId] UNIQUEIDENTIFIER NULL,
        [DistanceToHospitalKm] DECIMAL(5,2),
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_TAService_Hotels_City FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities]([Id]),
        CONSTRAINT FK_TAService_Hotels_Country FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries]([Id])
    );
    CREATE INDEX IX_TAService_Hotels_City ON [TAService].[Hotels]([CityId]);
    CREATE INDEX IX_TAService_Hotels_Location ON [TAService].[Hotels]([Latitude], [Longitude]);
    PRINT '✅ Table [TAService].[Hotels] created';
END
GO

-- HotelRooms
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[HotelRooms]'))
BEGIN
    CREATE TABLE [TAService].[HotelRooms] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [HotelId] UNIQUEIDENTIFIER NOT NULL,
        [RoomType] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(1000),
        [PricePerNight] DECIMAL(18,2) NOT NULL,
        [CurrencyId] UNIQUEIDENTIFIER NOT NULL,
        [MaxOccupancy] INT,
        [TotalRooms] INT,
        [AvailableRooms] INT,
        [Amenities] NVARCHAR(MAX),
        [Images] NVARCHAR(MAX),
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT FK_TAService_HotelRooms_Hotel FOREIGN KEY ([HotelId]) REFERENCES [TAService].[Hotels]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_TAService_HotelRooms_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    CREATE INDEX IX_TAService_HotelRooms_HotelId ON [TAService].[HotelRooms]([HotelId]);
    PRINT '✅ Table [TAService].[HotelRooms] created';
END
GO

-- AccommodationBookings
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[AccommodationBookings]'))
BEGIN
    CREATE TABLE [TAService].[AccommodationBookings] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [HotelId] UNIQUEIDENTIFIER NOT NULL,
        [RoomId] UNIQUEIDENTIFIER NOT NULL,
        [CheckInDate] DATE NOT NULL,
        [CheckOutDate] DATE NOT NULL,
        [NumberOfGuests] INT NOT NULL,
        [NumberOfRooms] INT DEFAULT 1,
        [TotalPrice] DECIMAL(18,2) NOT NULL,
        [CurrencyId] UNIQUEIDENTIFIER NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [BookingReference] NVARCHAR(50),
        [GuestName] NVARCHAR(200),
        [GuestEmail] NVARCHAR(255),
        [GuestPhone] NVARCHAR(20),
        [SpecialRequests] NVARCHAR(1000),
        [PaymentId] NVARCHAR(100),
        [IsPaid] BIT DEFAULT 0,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_TAService_AccommodationBookings_Hotel FOREIGN KEY ([HotelId]) REFERENCES [TAService].[Hotels]([Id]),
        CONSTRAINT FK_TAService_AccommodationBookings_Room FOREIGN KEY ([RoomId]) REFERENCES [TAService].[HotelRooms]([Id]),
        CONSTRAINT FK_TAService_AccommodationBookings_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    CREATE INDEX IX_TAService_AccommodationBookings_UserId ON [TAService].[AccommodationBookings]([UserId]);
    CREATE INDEX IX_TAService_AccommodationBookings_CheckIn ON [TAService].[AccommodationBookings]([CheckInDate]);
    PRINT '✅ Table [TAService].[AccommodationBookings] created';
END
GO

-- Payments
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TAService].[Payments]'))
BEGIN
    CREATE TABLE [TAService].[Payments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [CurrencyId] UNIQUEIDENTIFIER NOT NULL,
        [PaymentMethod] NVARCHAR(50),
        [PaymentGateway] NVARCHAR(50),
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [TransactionId] NVARCHAR(100),
        [PaymentIntentId] NVARCHAR(100),
        [Description] NVARCHAR(500),
        [Metadata] NVARCHAR(MAX),
        [ErrorMessage] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        [CapturedAt] DATETIME2 NULL,
        [RefundedAt] DATETIME2 NULL,
        CONSTRAINT FK_TAService_Payments_Currency FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies]([Id])
    );
    CREATE INDEX IX_TAService_Payments_UserId ON [TAService].[Payments]([UserId]);
    CREATE INDEX IX_TAService_Payments_Status ON [TAService].[Payments]([Status]);
    PRINT '✅ Table [TAService].[Payments] created';
END
GO

PRINT ''
PRINT '✅ TAService schema - 6 tables created'
PRINT ''
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 6: Creating Messaging Schema Tables'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- MESSAGING SCHEMA
-- =============================================

-- Threads
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Messaging].[Threads]'))
BEGIN
    CREATE TABLE [Messaging].[Threads] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Subject] NVARCHAR(500),
        [ParticipantIds] NVARCHAR(MAX) NOT NULL,
        [ThreadType] NVARCHAR(50) DEFAULT 'patient_doctor',
        [IsActive] BIT DEFAULT 1,
        [IsArchived] BIT DEFAULT 0,
        [LastMessageAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [CreatedBy] UNIQUEIDENTIFIER NOT NULL
    );
    CREATE INDEX IX_Messaging_Threads_CreatedAt ON [Messaging].[Threads]([CreatedAt] DESC);
    CREATE INDEX IX_Messaging_Threads_LastMessageAt ON [Messaging].[Threads]([LastMessageAt] DESC);
    PRINT '✅ Table [Messaging].[Threads] created';
END
GO

-- Messages
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Messaging].[Messages]'))
BEGIN
    CREATE TABLE [Messaging].[Messages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [ThreadId] UNIQUEIDENTIFIER NOT NULL,
        [SenderId] UNIQUEIDENTIFIER NOT NULL,
        [Content] NVARCHAR(MAX) NOT NULL,
        [MessageType] NVARCHAR(20) DEFAULT 'text',
        [IsEncrypted] BIT DEFAULT 1,
        [IsDelivered] BIT DEFAULT 0,
        [IsRead] BIT DEFAULT 0,
        [DeliveredAt] DATETIME2 NULL,
        [ReadAt] DATETIME2 NULL,
        [ReadBy] NVARCHAR(MAX),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Messaging_Messages_Thread FOREIGN KEY ([ThreadId]) REFERENCES [Messaging].[Threads]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_Messaging_Messages_ThreadId ON [Messaging].[Messages]([ThreadId]);
    CREATE INDEX IX_Messaging_Messages_SenderId ON [Messaging].[Messages]([SenderId]);
    CREATE INDEX IX_Messaging_Messages_CreatedAt ON [Messaging].[Messages]([CreatedAt] DESC);
    PRINT '✅ Table [Messaging].[Messages] created';
END
GO

-- MessageAttachments
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Messaging].[MessageAttachments]'))
BEGIN
    CREATE TABLE [Messaging].[MessageAttachments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [MessageId] UNIQUEIDENTIFIER NOT NULL,
        [FileName] NVARCHAR(255) NOT NULL,
        [FileUrl] NVARCHAR(1000) NOT NULL,
        [FileSize] BIGINT,
        [MimeType] NVARCHAR(100),
        [IsEncrypted] BIT DEFAULT 1,
        [UploadedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Messaging_MessageAttachments_Message FOREIGN KEY ([MessageId]) REFERENCES [Messaging].[Messages]([Id]) ON DELETE CASCADE
    );
    CREATE INDEX IX_Messaging_MessageAttachments_MessageId ON [Messaging].[MessageAttachments]([MessageId]);
    PRINT '✅ Table [Messaging].[MessageAttachments] created';
END
GO

PRINT ''
PRINT '✅ Messaging schema - 3 tables created'
PRINT ''
GO

-- Print final summary before stored procedures
PRINT ''
PRINT '======================================================================'
PRINT '  Database Tables Summary'
PRINT '======================================================================'
PRINT ''
SELECT 
    SCHEMA_NAME(schema_id) AS SchemaName,
    COUNT(*) AS TableCount
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) IN ('UserManagement', 'Hospital', 'TAService', 'Messaging', 'Metadata')
GROUP BY schema_id
ORDER BY SCHEMA_NAME(schema_id);
GO

PRINT ''
PRINT '======================================================================'
PRINT '  STEP 7: Creating Stored Procedures'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- STORED PROCEDURES - USER MANAGEMENT
-- =============================================

-- SP: Get User with Roles
CREATE OR ALTER PROCEDURE [UserManagement].[sp_GetUserWithRoles]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.*,
        STRING_AGG(r.Name, ',') AS Roles
    FROM UserManagement.Users u
    LEFT JOIN UserManagement.UserRoles ur ON u.Id = ur.UserId
    LEFT JOIN UserManagement.Roles r ON ur.RoleId = r.Id
    WHERE u.Id = @UserId
    GROUP BY u.Id, u.Email, u.PasswordHash, u.FirstName, u.LastName, u.Phone, 
             u.DateOfBirth, u.Gender, u.Nationality, u.CountryId, u.CityId, 
             u.Address, u.PostalCode, u.PassportNumber, u.EmailVerified, 
             u.PhoneVerified, u.TwoFactorEnabled, u.IsActive, u.CreatedAt, 
             u.UpdatedAt, u.LastLoginAt;
END
GO
PRINT '✅ Stored Procedure [UserManagement].[sp_GetUserWithRoles] created';
GO

-- SP: Search Users
CREATE OR ALTER PROCEDURE [UserManagement].[sp_SearchUsers]
    @SearchTerm NVARCHAR(255) = NULL,
    @CountryId UNIQUEIDENTIFIER = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        u.*,
        c.Name AS CountryName,
        ci.Name AS CityName,
        COUNT(*) OVER() AS TotalCount
    FROM UserManagement.Users u
    LEFT JOIN Metadata.Countries c ON u.CountryId = c.Id
    LEFT JOIN Metadata.Cities ci ON u.CityId = ci.Id
    WHERE 
        (@SearchTerm IS NULL OR 
         u.FirstName LIKE '%' + @SearchTerm + '%' OR 
         u.LastName LIKE '%' + @SearchTerm + '%' OR
         u.Email LIKE '%' + @SearchTerm + '%')
        AND (@CountryId IS NULL OR u.CountryId = @CountryId)
        AND (@CityId IS NULL OR u.CityId = @CityId)
        AND u.IsActive = 1
    ORDER BY u.CreatedAt DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO
PRINT '✅ Stored Procedure [UserManagement].[sp_SearchUsers] created';
GO

-- =============================================
-- STORED PROCEDURES - HOSPITAL
-- =============================================

-- SP: Search Hospitals
CREATE OR ALTER PROCEDURE [Hospital].[sp_SearchHospitals]
    @SearchTerm NVARCHAR(255) = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @SpecialtyId UNIQUEIDENTIFIER = NULL,
    @MinRating DECIMAL(3,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        h.*,
        c.Name AS CityName,
        co.Name AS CountryName,
        COUNT(*) OVER() AS TotalCount
    FROM Hospital.Hospitals h
    INNER JOIN Metadata.Cities c ON h.CityId = c.Id
    INNER JOIN Metadata.Countries co ON h.CountryId = co.Id
    WHERE 
        (@SearchTerm IS NULL OR 
         h.Name LIKE '%' + @SearchTerm + '%' OR 
         h.Description LIKE '%' + @SearchTerm + '%')
        AND (@CityId IS NULL OR h.CityId = @CityId)
        AND (@MinRating IS NULL OR h.AverageRating >= @MinRating)
        AND h.IsActive = 1
    ORDER BY h.AverageRating DESC, h.TotalReviews DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO
PRINT '✅ Stored Procedure [Hospital].[sp_SearchHospitals] created';
GO

-- SP: Search Doctors
CREATE OR ALTER PROCEDURE [Hospital].[sp_SearchDoctors]
    @SearchTerm NVARCHAR(255) = NULL,
    @SpecialtyId UNIQUEIDENTIFIER = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @MinRating DECIMAL(3,2) = NULL,
    @MaxFee DECIMAL(18,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT DISTINCT
        d.*,
        h.Name AS HospitalName,
        c.Name AS CityName,
        COUNT(*) OVER() AS TotalCount
    FROM Hospital.Doctors d
    INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
    INNER JOIN Metadata.Cities c ON h.CityId = c.Id
    LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
    WHERE 
        (@SearchTerm IS NULL OR 
         d.FirstName LIKE '%' + @SearchTerm + '%' OR 
         d.LastName LIKE '%' + @SearchTerm + '%' OR
         d.Qualification LIKE '%' + @SearchTerm + '%')
        AND (@SpecialtyId IS NULL OR ds.SpecialtyId = @SpecialtyId)
        AND (@CityId IS NULL OR h.CityId = @CityId)
        AND (@MinRating IS NULL OR d.AverageRating >= @MinRating)
        AND (@MaxFee IS NULL OR d.ConsultationFee <= @MaxFee)
        AND d.IsActive = 1
        AND d.IsAcceptingPatients = 1
    ORDER BY d.AverageRating DESC, d.YearsOfExperience DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO
PRINT '✅ Stored Procedure [Hospital].[sp_SearchDoctors] created';
GO

-- SP: Get Nearby Hospitals
CREATE OR ALTER PROCEDURE [Hospital].[sp_GetNearbyHospitals]
    @Latitude DECIMAL(10,7),
    @Longitude DECIMAL(10,7),
    @RadiusKm INT = 10,
    @Limit INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Limit)
        h.*,
        c.Name AS CityName,
        co.Name AS CountryName,
        (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(h.Latitude)) *
            COS(RADIANS(h.Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(h.Latitude))
        )) AS DistanceKm
    FROM Hospital.Hospitals h
    INNER JOIN Metadata.Cities c ON h.CityId = c.Id
    INNER JOIN Metadata.Countries co ON h.CountryId = co.Id
    WHERE h.IsActive = 1
        AND h.Latitude IS NOT NULL
        AND h.Longitude IS NOT NULL
    HAVING (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(h.Latitude)) *
            COS(RADIANS(h.Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(h.Latitude))
        )) <= @RadiusKm
    ORDER BY DistanceKm;
END
GO
PRINT '✅ Stored Procedure [Hospital].[sp_GetNearbyHospitals] created';
GO

-- =============================================
-- STORED PROCEDURES - TASERVICE
-- =============================================

-- SP: Search Flights
CREATE OR ALTER PROCEDURE [TAService].[sp_SearchFlights]
    @DepartureAirportId UNIQUEIDENTIFIER,
    @ArrivalAirportId UNIQUEIDENTIFIER,
    @DepartureDate DATE,
    @FlightClass NVARCHAR(20) = NULL,
    @MinSeats INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        f.*,
        a.Name AS AirlineName,
        da.Code AS DepartureAirportCode,
        da.Name AS DepartureAirportName,
        aa.Code AS ArrivalAirportCode,
        aa.Name AS ArrivalAirportName,
        cu.Code AS CurrencyCode
    FROM TAService.Flights f
    INNER JOIN Metadata.Airlines a ON f.AirlineId = a.Id
    INNER JOIN Metadata.Airports da ON f.DepartureAirportId = da.Id
    INNER JOIN Metadata.Airports aa ON f.ArrivalAirportId = aa.Id
    INNER JOIN Metadata.Currencies cu ON f.CurrencyId = cu.Id
    WHERE f.DepartureAirportId = @DepartureAirportId
      AND f.ArrivalAirportId = @ArrivalAirportId
      AND CAST(f.DepartureTime AS DATE) = @DepartureDate
      AND (@FlightClass IS NULL OR f.FlightClass = @FlightClass)
      AND f.AvailableSeats >= @MinSeats
      AND f.IsActive = 1
    ORDER BY f.Price, f.DepartureTime;
END
GO
PRINT '✅ Stored Procedure [TAService].[sp_SearchFlights] created';
GO

PRINT ''
PRINT '✅ All stored procedures created'
PRINT ''
GO

PRINT ''
PRINT '======================================================================'
PRINT '  ✅ DATABASE SETUP COMPLETE!'
PRINT '======================================================================'
PRINT ''
PRINT 'Database: MedTravelDb'
PRINT 'Schemas: 6 (UserManagement, Hospital, TAService, Messaging, Metadata, TestData)'
PRINT ''
GO

-- Final count
SELECT 
    SCHEMA_NAME(schema_id) AS SchemaName,
    COUNT(*) AS TableCount
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) IN ('UserManagement', 'Hospital', 'TAService', 'Messaging', 'Metadata', 'TestData')
GROUP BY schema_id
ORDER BY SCHEMA_NAME(schema_id);
GO

PRINT ''
PRINT 'Connection String:'
PRINT 'Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True;MultipleActiveResultSets=true'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Run TestData script to insert sample data'
PRINT '  2. Update connection strings in all services'
PRINT '  3. Update DbContext files to use schemas'
PRINT '  4. Run: docker-compose up'
PRINT ''
GO
