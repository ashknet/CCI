-- =============================================
-- Medical Travel Booking Platform
-- User Management Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelUserDB')
BEGIN
    CREATE DATABASE MedicalTravelUserDB;
END
GO

USE MedicalTravelUserDB;
GO

-- Users Table
CREATE TABLE Users (
    UserId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    DateOfBirth DATE,
    Gender NVARCHAR(20),
    ProfileImageUrl NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    IsEmailVerified BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    LastLoginAt DATETIME2,
    INDEX IX_Users_Email (Email),
    INDEX IX_Users_CreatedAt (CreatedAt)
);

-- User Roles Table
CREATE TABLE UserRoles (
    RoleId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- User Role Mapping
CREATE TABLE UserRoleMapping (
    UserRoleMappingId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    RoleId UNIQUEIDENTIFIER NOT NULL,
    AssignedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    FOREIGN KEY (RoleId) REFERENCES UserRoles(RoleId) ON DELETE CASCADE,
    INDEX IX_UserRoleMapping_UserId (UserId),
    INDEX IX_UserRoleMapping_RoleId (RoleId)
);

-- User Addresses
CREATE TABLE UserAddresses (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    AddressType NVARCHAR(50) NOT NULL, -- Home, Work, Billing
    Street NVARCHAR(255),
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100),
    Country NVARCHAR(100) NOT NULL,
    PostalCode NVARCHAR(20),
    IsDefault BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    INDEX IX_UserAddresses_UserId (UserId)
);

-- User Preferences
CREATE TABLE UserPreferences (
    PreferenceId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    LanguageCode NVARCHAR(10) DEFAULT 'en',
    CurrencyCode NVARCHAR(10) DEFAULT 'USD',
    NotificationEmail BIT DEFAULT 1,
    NotificationSMS BIT DEFAULT 1,
    NotificationPush BIT DEFAULT 1,
    ThemePreference NVARCHAR(20) DEFAULT 'light',
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    INDEX IX_UserPreferences_UserId (UserId)
);

-- Authentication Logs
CREATE TABLE AuthenticationLogs (
    LogId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    ActionType NVARCHAR(50) NOT NULL, -- Login, Logout, PasswordReset, etc.
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    IsSuccess BIT NOT NULL,
    FailureReason NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    INDEX IX_AuthenticationLogs_UserId (UserId),
    INDEX IX_AuthenticationLogs_CreatedAt (CreatedAt)
);

-- Refresh Tokens
CREATE TABLE RefreshTokens (
    TokenId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    Token NVARCHAR(500) NOT NULL UNIQUE,
    ExpiresAt DATETIME2 NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    RevokedAt DATETIME2,
    IsRevoked BIT DEFAULT 0,
    FOREIGN KEY (UserId) REFERENCES Users(UserId) ON DELETE CASCADE,
    INDEX IX_RefreshTokens_UserId (UserId),
    INDEX IX_RefreshTokens_Token (Token)
);

-- Insert Default Roles
INSERT INTO UserRoles (RoleName, Description) VALUES
('Patient', 'Regular patient user'),
('Doctor', 'Medical doctor/provider'),
('HospitalAdmin', 'Hospital administrator'),
('SystemAdmin', 'System administrator'),
('Guest', 'Guest user with limited access');

-- Insert Sample Users
INSERT INTO Users (Email, PasswordHash, FirstName, LastName, PhoneNumber, DateOfBirth, Gender, IsEmailVerified) VALUES
('john.doe@example.com', 'AQAAAAEAACcQAAAAEGHFD+W5YRR5cGrQhXXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'John', 'Doe', '+1234567890', '1985-03-15', 'Male', 1),
('jane.smith@example.com', 'AQAAAAEAACcQAAAAEGHFD+W5YRR5cGrQhXXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Jane', 'Smith', '+1234567891', '1990-07-22', 'Female', 1),
('admin@medicaltravelplatform.com', 'AQAAAAEAACcQAAAAEGHFD+W5YRR5cGrQhXXxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'Admin', 'User', '+1234567892', '1980-01-01', 'Other', 1);

-- Assign roles to users
DECLARE @JohnId UNIQUEIDENTIFIER = (SELECT UserId FROM Users WHERE Email = 'john.doe@example.com');
DECLARE @JaneId UNIQUEIDENTIFIER = (SELECT UserId FROM Users WHERE Email = 'jane.smith@example.com');
DECLARE @AdminId UNIQUEIDENTIFIER = (SELECT UserId FROM Users WHERE Email = 'admin@medicaltravelplatform.com');
DECLARE @PatientRoleId UNIQUEIDENTIFIER = (SELECT RoleId FROM UserRoles WHERE RoleName = 'Patient');
DECLARE @AdminRoleId UNIQUEIDENTIFIER = (SELECT RoleId FROM UserRoles WHERE RoleName = 'SystemAdmin');

INSERT INTO UserRoleMapping (UserId, RoleId) VALUES
(@JohnId, @PatientRoleId),
(@JaneId, @PatientRoleId),
(@AdminId, @AdminRoleId);

GO
