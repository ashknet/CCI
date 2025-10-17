-- =============================================
-- Additional Tables for Search-to-Selection Workflow
-- =============================================

USE MedTravelDb;
GO

-- Create DoctorSpecialties junction table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.DoctorSpecialties') AND type in (N'U'))
BEGIN
    CREATE TABLE [Hospital].[DoctorSpecialties] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [DoctorId]        UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId]     UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary]       BIT              DEFAULT ((0)) NOT NULL,
        [YearsOfExperience] INT            DEFAULT ((0)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Hospital_DoctorSpecialties_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Hospital_DoctorSpecialties_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_DoctorSpecialties_Doctor_Specialty] UNIQUE ([DoctorId], [SpecialtyId])
    );
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorSpecialties_DoctorId]
        ON [Hospital].[DoctorSpecialties]([DoctorId] ASC);
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorSpecialties_SpecialtyId]
        ON [Hospital].[DoctorSpecialties]([SpecialtyId] ASC);
END
GO

-- Create DoctorLanguages table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.DoctorLanguages') AND type in (N'U'))
BEGIN
    CREATE TABLE [Hospital].[DoctorLanguages] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [DoctorId]        UNIQUEIDENTIFIER NOT NULL,
        [LanguageId]      UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary]       BIT              DEFAULT ((0)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Hospital_DoctorLanguages_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Hospital_DoctorLanguages_Language] FOREIGN KEY ([LanguageId]) REFERENCES [Metadata].[Languages] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_DoctorLanguages_Doctor_Language] UNIQUE ([DoctorId], [LanguageId])
    );
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorLanguages_DoctorId]
        ON [Hospital].[DoctorLanguages]([DoctorId] ASC);
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorLanguages_LanguageId]
        ON [Hospital].[DoctorLanguages]([LanguageId] ASC);
END
GO

-- Create Languages table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Metadata.Languages') AND type in (N'U'))
BEGIN
    CREATE TABLE [Metadata].[Languages] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [Name]            NVARCHAR (100)   NOT NULL,
        [Code]            NVARCHAR (10)    NOT NULL,
        [IsActive]        BIT              DEFAULT ((1)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [UQ_Metadata_Languages_Code] UNIQUE ([Code])
    );
    
    CREATE NONCLUSTERED INDEX [IX_Metadata_Languages_Code]
        ON [Metadata].[Languages]([Code] ASC);
END
GO

-- Create DoctorCredentials table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.DoctorCredentials') AND type in (N'U'))
BEGIN
    CREATE TABLE [Hospital].[DoctorCredentials] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [DoctorId]        UNIQUEIDENTIFIER NOT NULL,
        [Type]            NVARCHAR (100)   NOT NULL,
        [Name]            NVARCHAR (200)   NOT NULL,
        [IssuingOrganization] NVARCHAR (200) NOT NULL,
        [IssueDate]       DATETIME2 (7)    NOT NULL,
        [ExpiryDate]      DATETIME2 (7)    NULL,
        [IsVerified]      BIT              DEFAULT ((0)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Hospital_DoctorCredentials_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_DoctorCredentials_DoctorId]
        ON [Hospital].[DoctorCredentials]([DoctorId] ASC);
END
GO

-- Create HospitalSpecialties junction table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.HospitalSpecialties') AND type in (N'U'))
BEGIN
    CREATE TABLE [Hospital].[HospitalSpecialties] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [HospitalId]      UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId]     UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary]       BIT              DEFAULT ((0)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Hospital_HospitalSpecialties_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Hospital_HospitalSpecialties_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_HospitalSpecialties_Hospital_Specialty] UNIQUE ([HospitalId], [SpecialtyId])
    );
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_HospitalSpecialties_HospitalId]
        ON [Hospital].[HospitalSpecialties]([HospitalId] ASC);
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_HospitalSpecialties_SpecialtyId]
        ON [Hospital].[HospitalSpecialties]([SpecialtyId] ASC);
END
GO

-- Create HospitalAmenities table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.HospitalAmenities') AND type in (N'U'))
BEGIN
    CREATE TABLE [Hospital].[HospitalAmenities] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [HospitalId]      UNIQUEIDENTIFIER NOT NULL,
        [Name]            NVARCHAR (100)   NOT NULL,
        [Description]     NVARCHAR (500)   NULL,
        [IsAvailable]     BIT              DEFAULT ((1)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Hospital_HospitalAmenities_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id]) ON DELETE CASCADE
    );
    
    CREATE NONCLUSTERED INDEX [IX_Hospital_HospitalAmenities_HospitalId]
        ON [Hospital].[HospitalAmenities]([HospitalId] ASC);
END
GO

-- Create DiseaseSpecialties junction table (if not exists)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Metadata.DiseaseSpecialties') AND type in (N'U'))
BEGIN
    CREATE TABLE [Metadata].[DiseaseSpecialties] (
        [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
        [DiseaseId]       UNIQUEIDENTIFIER NOT NULL,
        [SpecialtyId]     UNIQUEIDENTIFIER NOT NULL,
        [IsPrimary]       BIT              DEFAULT ((0)) NOT NULL,
        [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Metadata_DiseaseSpecialties_Disease] FOREIGN KEY ([DiseaseId]) REFERENCES [Metadata].[Diseases] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Metadata_DiseaseSpecialties_Specialty] FOREIGN KEY ([SpecialtyId]) REFERENCES [Metadata].[Specialties] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [UQ_DiseaseSpecialties_Disease_Specialty] UNIQUE ([DiseaseId], [SpecialtyId])
    );
    
    CREATE NONCLUSTERED INDEX [IX_Metadata_DiseaseSpecialties_DiseaseId]
        ON [Metadata].[DiseaseSpecialties]([DiseaseId] ASC);
    
    CREATE NONCLUSTERED INDEX [IX_Metadata_DiseaseSpecialties_SpecialtyId]
        ON [Metadata].[DiseaseSpecialties]([SpecialtyId] ASC);
END
GO

-- Insert default languages
IF NOT EXISTS (SELECT 1 FROM [Metadata].[Languages] WHERE [Code] = 'en')
BEGIN
    INSERT INTO [Metadata].[Languages] ([Name], [Code]) VALUES
    ('English', 'en'),
    ('Hindi', 'hi'),
    ('Telugu', 'te'),
    ('Tamil', 'ta'),
    ('Kannada', 'kn'),
    ('Bengali', 'bn'),
    ('Gujarati', 'gu'),
    ('Marathi', 'mr'),
    ('Punjabi', 'pa'),
    ('Urdu', 'ur');
END
GO

-- Insert sample hospital amenities
IF NOT EXISTS (SELECT 1 FROM [Hospital].[HospitalAmenities] WHERE [Name] = 'WiFi')
BEGIN
    -- Get a sample hospital ID to insert amenities
    DECLARE @SampleHospitalId UNIQUEIDENTIFIER;
    SELECT TOP 1 @SampleHospitalId = [Id] FROM [Hospital].[Hospitals];
    
    IF @SampleHospitalId IS NOT NULL
    BEGIN
        INSERT INTO [Hospital].[HospitalAmenities] ([HospitalId], [Name], [Description]) VALUES
        (@SampleHospitalId, 'WiFi', 'Free WiFi available throughout the hospital'),
        (@SampleHospitalId, 'Parking', 'Ample parking space available'),
        (@SampleHospitalId, 'Cafeteria', '24/7 cafeteria with healthy food options'),
        (@SampleHospitalId, 'Pharmacy', 'In-house pharmacy with all medications'),
        (@SampleHospitalId, 'Emergency Services', '24/7 emergency services'),
        (@SampleHospitalId, 'Ambulance', 'Ambulance services available'),
        (@SampleHospitalId, 'Blood Bank', 'Blood bank with all blood groups'),
        (@SampleHospitalId, 'Laboratory', 'Advanced laboratory services'),
        (@SampleHospitalId, 'Radiology', 'Modern radiology and imaging services'),
        (@SampleHospitalId, 'ICU', 'Intensive Care Unit with modern equipment');
    END
END
GO

-- Create indexes for better performance
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Doctors_Search_Enhanced' AND object_id = OBJECT_ID('Hospital.Doctors'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Doctors_Search_Enhanced]
    ON [Hospital].[Doctors]([FirstName] ASC, [LastName] ASC, [IsActive] ASC, [IsAcceptingPatients] ASC)
    INCLUDE([Id], [Qualification], [AverageRating], [ConsultationFee], [YearsOfExperience]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Hospitals_Search_Enhanced' AND object_id = OBJECT_ID('Hospital.Hospitals'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Hospitals_Search_Enhanced]
    ON [Hospital].[Hospitals]([Name] ASC, [IsActive] ASC, [CityId] ASC)
    INCLUDE([Id], [Description], [Address], [AverageRating], [BedCapacity]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Cities_Search_Enhanced' AND object_id = OBJECT_ID('Metadata.Cities'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Cities_Search_Enhanced]
    ON [Metadata].[Cities]([Name] ASC, [IsActive] ASC, [CountryId] ASC)
    INCLUDE([Id], [State]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Diseases_Search_Enhanced' AND object_id = OBJECT_ID('Metadata.Diseases'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Diseases_Search_Enhanced]
    ON [Metadata].[Diseases]([Name] ASC, [Category] ASC)
    INCLUDE([Id], [Description], [Symptoms]);
END
GO

PRINT 'Additional tables and indexes created successfully for search-to-selection workflow!';
PRINT '';
PRINT 'Tables created:';
PRINT '- Hospital.DoctorSpecialties (junction table)';
PRINT '- Hospital.DoctorLanguages (junction table)';
PRINT '- Metadata.Languages (reference table)';
PRINT '- Hospital.DoctorCredentials (doctor credentials)';
PRINT '- Hospital.HospitalSpecialties (junction table)';
PRINT '- Hospital.HospitalAmenities (hospital amenities)';
PRINT '- Metadata.DiseaseSpecialties (junction table)';
PRINT '';
PRINT 'Performance indexes created for all search tables.';
GO
