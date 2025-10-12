-- =============================================
-- Medical Travel Booking Platform
-- Provider Directory Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelProviderDB')
BEGIN
    CREATE DATABASE MedicalTravelProviderDB;
END
GO

USE MedicalTravelProviderDB;
GO

-- Hospitals Table
CREATE TABLE Hospitals (
    HospitalId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    HospitalName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Email NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    Website NVARCHAR(500),
    AccreditationInfo NVARCHAR(MAX),
    ImageUrl NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    Rating DECIMAL(3,2) DEFAULT 0.0,
    TotalReviews INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_Hospitals_HospitalName (HospitalName),
    INDEX IX_Hospitals_Rating (Rating),
    INDEX IX_Hospitals_IsActive (IsActive)
);

-- Hospital Addresses
CREATE TABLE HospitalAddresses (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    HospitalId UNIQUEIDENTIFIER NOT NULL,
    Street NVARCHAR(255),
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100),
    Country NVARCHAR(100) NOT NULL,
    PostalCode NVARCHAR(20),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    IsMainBranch BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId) ON DELETE CASCADE,
    INDEX IX_HospitalAddresses_HospitalId (HospitalId),
    INDEX IX_HospitalAddresses_City (City),
    INDEX IX_HospitalAddresses_Country (Country)
);

-- Specialties
CREATE TABLE Specialties (
    SpecialtyId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    SpecialtyName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    IconUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    HospitalId UNIQUEIDENTIFIER NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20),
    ProfileImageUrl NVARCHAR(500),
    Biography NVARCHAR(MAX),
    YearsOfExperience INT DEFAULT 0,
    LicenseNumber NVARCHAR(100),
    Degree NVARCHAR(255),
    Rating DECIMAL(3,2) DEFAULT 0.0,
    TotalReviews INT DEFAULT 0,
    ConsultationFee DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId),
    INDEX IX_Doctors_HospitalId (HospitalId),
    INDEX IX_Doctors_Name (FirstName, LastName),
    INDEX IX_Doctors_Rating (Rating),
    INDEX IX_Doctors_IsActive (IsActive)
);

-- Doctor Specialties (Many-to-Many)
CREATE TABLE DoctorSpecialties (
    DoctorSpecialtyId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DoctorId UNIQUEIDENTIFIER NOT NULL,
    SpecialtyId UNIQUEIDENTIFIER NOT NULL,
    IsPrimary BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId) ON DELETE CASCADE,
    FOREIGN KEY (SpecialtyId) REFERENCES Specialties(SpecialtyId) ON DELETE CASCADE,
    INDEX IX_DoctorSpecialties_DoctorId (DoctorId),
    INDEX IX_DoctorSpecialties_SpecialtyId (SpecialtyId)
);

-- Languages Spoken by Doctors
CREATE TABLE DoctorLanguages (
    DoctorLanguageId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DoctorId UNIQUEIDENTIFIER NOT NULL,
    LanguageCode NVARCHAR(10) NOT NULL,
    LanguageName NVARCHAR(50) NOT NULL,
    ProficiencyLevel NVARCHAR(20), -- Native, Fluent, Intermediate, Basic
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId) ON DELETE CASCADE,
    INDEX IX_DoctorLanguages_DoctorId (DoctorId)
);

-- Hospital Facilities
CREATE TABLE HospitalFacilities (
    FacilityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    HospitalId UNIQUEIDENTIFIER NOT NULL,
    FacilityName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    IsAvailable BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (HospitalId) REFERENCES Hospitals(HospitalId) ON DELETE CASCADE,
    INDEX IX_HospitalFacilities_HospitalId (HospitalId)
);

-- Diseases/Conditions
CREATE TABLE Diseases (
    DiseaseId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DiseaseName NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Symptoms NVARCHAR(MAX),
    Category NVARCHAR(100),
    ICD10Code NVARCHAR(20),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_Diseases_DiseaseName (DiseaseName),
    INDEX IX_Diseases_Category (Category)
);

-- Doctor Disease Specialization
CREATE TABLE DoctorDiseases (
    DoctorDiseaseId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DoctorId UNIQUEIDENTIFIER NOT NULL,
    DiseaseId UNIQUEIDENTIFIER NOT NULL,
    ExperienceYears INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId) ON DELETE CASCADE,
    FOREIGN KEY (DiseaseId) REFERENCES Diseases(DiseaseId) ON DELETE CASCADE,
    INDEX IX_DoctorDiseases_DoctorId (DoctorId),
    INDEX IX_DoctorDiseases_DiseaseId (DiseaseId)
);

-- Insert Sample Specialties
INSERT INTO Specialties (SpecialtyName, Description) VALUES
('Cardiology', 'Heart and cardiovascular system'),
('Neurology', 'Brain and nervous system'),
('Orthopedics', 'Bones, joints, and muscles'),
('Oncology', 'Cancer treatment'),
('Pediatrics', 'Children''s healthcare'),
('Dermatology', 'Skin conditions'),
('Gastroenterology', 'Digestive system'),
('Endocrinology', 'Hormones and metabolism'),
('Nephrology', 'Kidney diseases'),
('Pulmonology', 'Respiratory system');

-- Insert Sample Hospitals
INSERT INTO Hospitals (HospitalName, Description, Email, PhoneNumber, Website, AccreditationInfo, Rating) VALUES
('Global Medical Center', 'Leading international healthcare provider', 'info@globalmedical.com', '+1-555-0001', 'www.globalmedical.com', 'JCI Accredited, ISO 9001:2015', 4.8),
('International Healthcare Institute', 'Specialized in complex medical procedures', 'contact@ihi.com', '+1-555-0002', 'www.ihi.com', 'JCI Accredited, NABH', 4.6),
('Advanced Surgical Center', 'State-of-the-art surgical facilities', 'info@asc.com', '+1-555-0003', 'www.asc.com', 'JCI Accredited', 4.7);

-- Insert Hospital Addresses
DECLARE @Hospital1 UNIQUEIDENTIFIER = (SELECT TOP 1 HospitalId FROM Hospitals WHERE HospitalName = 'Global Medical Center');
DECLARE @Hospital2 UNIQUEIDENTIFIER = (SELECT TOP 1 HospitalId FROM Hospitals WHERE HospitalName = 'International Healthcare Institute');
DECLARE @Hospital3 UNIQUEIDENTIFIER = (SELECT TOP 1 HospitalId FROM Hospitals WHERE HospitalName = 'Advanced Surgical Center');

INSERT INTO HospitalAddresses (HospitalId, Street, City, State, Country, PostalCode, Latitude, Longitude) VALUES
(@Hospital1, '123 Medical Plaza', 'New York', 'NY', 'USA', '10001', 40.7128, -74.0060),
(@Hospital2, '456 Health Avenue', 'Singapore', NULL, 'Singapore', '238880', 1.3521, 103.8198),
(@Hospital3, '789 Care Boulevard', 'Dubai', NULL, 'UAE', '00000', 25.2048, 55.2708);

-- Insert Sample Doctors
INSERT INTO Doctors (HospitalId, FirstName, LastName, Email, PhoneNumber, Biography, YearsOfExperience, Degree, Rating, ConsultationFee) VALUES
(@Hospital1, 'Sarah', 'Johnson', 'sarah.johnson@globalmedical.com', '+1-555-1001', 'Board-certified cardiologist with 15+ years experience', 15, 'MD, FACC', 4.9, 250.00),
(@Hospital1, 'Michael', 'Chen', 'michael.chen@globalmedical.com', '+1-555-1002', 'Renowned neurologist specializing in stroke care', 20, 'MD, PhD, FAAN', 4.8, 300.00),
(@Hospital2, 'Priya', 'Sharma', 'priya.sharma@ihi.com', '+65-555-2001', 'Expert orthopedic surgeon', 12, 'MBBS, MS Orthopedics', 4.7, 200.00),
(@Hospital3, 'Ahmed', 'Al-Mansoori', 'ahmed.almansoori@asc.com', '+971-555-3001', 'Leading oncologist in the Middle East', 18, 'MD, FRCP', 4.9, 350.00);

-- Link Doctors to Specialties
DECLARE @Doctor1 UNIQUEIDENTIFIER = (SELECT TOP 1 DoctorId FROM Doctors WHERE Email = 'sarah.johnson@globalmedical.com');
DECLARE @Doctor2 UNIQUEIDENTIFIER = (SELECT TOP 1 DoctorId FROM Doctors WHERE Email = 'michael.chen@globalmedical.com');
DECLARE @Doctor3 UNIQUEIDENTIFIER = (SELECT TOP 1 DoctorId FROM Doctors WHERE Email = 'priya.sharma@ihi.com');
DECLARE @Doctor4 UNIQUEIDENTIFIER = (SELECT TOP 1 DoctorId FROM Doctors WHERE Email = 'ahmed.almansoori@asc.com');

DECLARE @CardiologyId UNIQUEIDENTIFIER = (SELECT TOP 1 SpecialtyId FROM Specialties WHERE SpecialtyName = 'Cardiology');
DECLARE @NeurologyId UNIQUEIDENTIFIER = (SELECT TOP 1 SpecialtyId FROM Specialties WHERE SpecialtyName = 'Neurology');
DECLARE @OrthopedicsId UNIQUEIDENTIFIER = (SELECT TOP 1 SpecialtyId FROM Specialties WHERE SpecialtyName = 'Orthopedics');
DECLARE @OncologyId UNIQUEIDENTIFIER = (SELECT TOP 1 SpecialtyId FROM Specialties WHERE SpecialtyName = 'Oncology');

INSERT INTO DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary) VALUES
(@Doctor1, @CardiologyId, 1),
(@Doctor2, @NeurologyId, 1),
(@Doctor3, @OrthopedicsId, 1),
(@Doctor4, @OncologyId, 1);

-- Insert Doctor Languages
INSERT INTO DoctorLanguages (DoctorId, LanguageCode, LanguageName, ProficiencyLevel) VALUES
(@Doctor1, 'en', 'English', 'Native'),
(@Doctor1, 'es', 'Spanish', 'Fluent'),
(@Doctor2, 'en', 'English', 'Fluent'),
(@Doctor2, 'zh', 'Mandarin', 'Native'),
(@Doctor3, 'en', 'English', 'Fluent'),
(@Doctor3, 'hi', 'Hindi', 'Native'),
(@Doctor4, 'en', 'English', 'Fluent'),
(@Doctor4, 'ar', 'Arabic', 'Native');

GO
