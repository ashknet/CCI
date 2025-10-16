-- =============================================
-- MedTravel Platform - User Management Database
-- Schema Creation Script
-- =============================================

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'UserManagementDb')
BEGIN
    CREATE DATABASE UserManagementDb;
END
GO

USE UserManagementDb;
GO

-- =============================================
-- 1. Roles Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Roles]'))
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(50) NOT NULL UNIQUE,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Roles_Name ON [dbo].[Roles]([Name]);
END
GO

-- =============================================
-- 2. Permissions Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Permissions]'))
BEGIN
    CREATE TABLE [dbo].[Permissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL,
        [Resource] NVARCHAR(50) NOT NULL,
        [Action] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT UQ_Permission_Resource_Action UNIQUE ([Resource], [Action])
    );
    
    CREATE INDEX IX_Permissions_Resource ON [dbo].[Permissions]([Resource]);
END
GO

-- =============================================
-- 3. RolePermissions Table (Many-to-Many)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RolePermissions]'))
BEGIN
    CREATE TABLE [dbo].[RolePermissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [PermissionId] UNIQUEIDENTIFIER NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_RolePermissions_Role FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_RolePermissions_Permission FOREIGN KEY ([PermissionId]) REFERENCES [dbo].[Permissions]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_RolePermission UNIQUE ([RoleId], [PermissionId])
    );
    
    CREATE INDEX IX_RolePermissions_RoleId ON [dbo].[RolePermissions]([RoleId]);
    CREATE INDEX IX_RolePermissions_PermissionId ON [dbo].[RolePermissions]([PermissionId]);
END
GO

-- =============================================
-- 4. Users Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]'))
BEGIN
    CREATE TABLE [dbo].[Users] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Email] NVARCHAR(255) NOT NULL UNIQUE,
        [PasswordHash] NVARCHAR(500) NOT NULL,
        [FirstName] NVARCHAR(100) NOT NULL,
        [LastName] NVARCHAR(100) NOT NULL,
        [Phone] NVARCHAR(20),
        [DateOfBirth] DATE,
        [Gender] NVARCHAR(20),
        [Nationality] NVARCHAR(100),
        [Country] NVARCHAR(100),
        [City] NVARCHAR(100),
        [Address] NVARCHAR(500),
        [PostalCode] NVARCHAR(20),
        [PassportNumber] NVARCHAR(50),
        [EmailVerified] BIT NOT NULL DEFAULT 0,
        [PhoneVerified] BIT NOT NULL DEFAULT 0,
        [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        [LastLoginAt] DATETIME2 NULL
    );
    
    CREATE UNIQUE INDEX IX_Users_Email ON [dbo].[Users]([Email]);
    CREATE INDEX IX_Users_Country_City ON [dbo].[Users]([Country], [City]);
    CREATE INDEX IX_Users_CreatedAt ON [dbo].[Users]([CreatedAt] DESC);
END
GO

-- =============================================
-- 5. UserRoles Table (Many-to-Many)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRoles]'))
BEGIN
    CREATE TABLE [dbo].[UserRoles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [AssignedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [AssignedBy] UNIQUEIDENTIFIER NULL,
        CONSTRAINT FK_UserRoles_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserRoles_Role FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_UserRole UNIQUE ([UserId], [RoleId])
    );
    
    CREATE INDEX IX_UserRoles_UserId ON [dbo].[UserRoles]([UserId]);
    CREATE INDEX IX_UserRoles_RoleId ON [dbo].[UserRoles]([RoleId]);
END
GO

-- =============================================
-- 6. Sessions Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sessions]'))
BEGIN
    CREATE TABLE [dbo].[Sessions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RefreshToken] NVARCHAR(500) NOT NULL UNIQUE,
        [DeviceInfo] NVARCHAR(500),
        [IpAddress] NVARCHAR(50),
        [IsActive] BIT NOT NULL DEFAULT 1,
        [ExpiresAt] DATETIME2 NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [RevokedAt] DATETIME2 NULL,
        CONSTRAINT FK_Sessions_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE UNIQUE INDEX IX_Sessions_RefreshToken ON [dbo].[Sessions]([RefreshToken]);
    CREATE INDEX IX_Sessions_UserId ON [dbo].[Sessions]([UserId]);
    CREATE INDEX IX_Sessions_ExpiresAt ON [dbo].[Sessions]([ExpiresAt]);
END
GO

-- =============================================
-- 7. UserPreferences Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPreferences]'))
BEGIN
    CREATE TABLE [dbo].[UserPreferences] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL UNIQUE,
        [PreferredLanguage] NVARCHAR(10) DEFAULT 'en',
        [PreferredCurrency] NVARCHAR(10) DEFAULT 'USD',
        [EmailNotifications] BIT DEFAULT 1,
        [SmsNotifications] BIT DEFAULT 1,
        [PushNotifications] BIT DEFAULT 1,
        [Theme] NVARCHAR(20) DEFAULT 'light',
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL,
        CONSTRAINT FK_UserPreferences_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserPreferences_UserId ON [dbo].[UserPreferences]([UserId]);
END
GO

-- =============================================
-- 8. UserDocuments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserDocuments]'))
BEGIN
    CREATE TABLE [dbo].[UserDocuments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [DocumentType] NVARCHAR(50) NOT NULL,
        [DocumentName] NVARCHAR(255) NOT NULL,
        [DocumentUrl] NVARCHAR(1000) NOT NULL,
        [FileSize] BIGINT,
        [MimeType] NVARCHAR(100),
        [IsVerified] BIT DEFAULT 0,
        [VerifiedBy] UNIQUEIDENTIFIER NULL,
        [VerifiedAt] DATETIME2 NULL,
        [UploadedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserDocuments_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserDocuments_UserId ON [dbo].[UserDocuments]([UserId]);
    CREATE INDEX IX_UserDocuments_Type ON [dbo].[UserDocuments]([DocumentType]);
END
GO

-- =============================================
-- 9. InsurancePolicies Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicies]'))
BEGIN
    CREATE TABLE [dbo].[InsurancePolicies] (
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
        CONSTRAINT FK_InsurancePolicies_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_InsurancePolicies_UserId ON [dbo].[InsurancePolicies]([UserId]);
    CREATE INDEX IX_InsurancePolicies_PolicyNumber ON [dbo].[InsurancePolicies]([PolicyNumber]);
END
GO

-- =============================================
-- 10. Notifications Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]'))
BEGIN
    CREATE TABLE [dbo].[Notifications] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [Type] NVARCHAR(50) NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Message] NVARCHAR(2000) NOT NULL,
        [Channel] NVARCHAR(20) NOT NULL, -- email, sms, push
        [Status] NVARCHAR(20) DEFAULT 'pending', -- pending, sent, failed
        [IsRead] BIT DEFAULT 0,
        [SentAt] DATETIME2 NULL,
        [ReadAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Notifications_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Notifications_UserId ON [dbo].[Notifications]([UserId]);
    CREATE INDEX IX_Notifications_Status ON [dbo].[Notifications]([Status]);
    CREATE INDEX IX_Notifications_CreatedAt ON [dbo].[Notifications]([CreatedAt] DESC);
END
GO

-- =============================================
-- 11. AuditLogs Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditLogs]'))
BEGIN
    CREATE TABLE [dbo].[AuditLogs] (
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
        CONSTRAINT FK_AuditLogs_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_AuditLogs_UserId ON [dbo].[AuditLogs]([UserId]);
    CREATE INDEX IX_AuditLogs_EntityType ON [dbo].[AuditLogs]([EntityType]);
    CREATE INDEX IX_AuditLogs_Timestamp ON [dbo].[AuditLogs]([Timestamp] DESC);
END
GO

-- =============================================
-- 12. NotificationTemplates Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationTemplates]'))
BEGIN
    CREATE TABLE [dbo].[NotificationTemplates] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL UNIQUE,
        [Type] NVARCHAR(50) NOT NULL,
        [Channel] NVARCHAR(20) NOT NULL,
        [Subject] NVARCHAR(200),
        [Body] NVARCHAR(MAX) NOT NULL,
        [IsActive] BIT DEFAULT 1,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_NotificationTemplates_Type ON [dbo].[NotificationTemplates]([Type]);
END
GO

-- =============================================
-- 13. NotificationSchedules Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationSchedules]'))
BEGIN
    CREATE TABLE [dbo].[NotificationSchedules] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [TemplateId] UNIQUEIDENTIFIER NOT NULL,
        [ScheduledFor] DATETIME2 NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [ProcessedAt] DATETIME2 NULL,
        [Data] NVARCHAR(MAX), -- JSON data for template
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_NotificationSchedules_User FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_NotificationSchedules_Template FOREIGN KEY ([TemplateId]) REFERENCES [dbo].[NotificationTemplates]([Id])
    );
    
    CREATE INDEX IX_NotificationSchedules_ScheduledFor ON [dbo].[NotificationSchedules]([ScheduledFor]);
    CREATE INDEX IX_NotificationSchedules_Status ON [dbo].[NotificationSchedules]([Status]);
END
GO

PRINT 'User Management schema created successfully';
GO
