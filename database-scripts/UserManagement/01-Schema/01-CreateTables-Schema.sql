-- =============================================
-- MedTravel Platform - User Management Schema
-- Tables within UserManagement schema
-- =============================================

USE MedTravelDb;
GO

-- Ensure schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'UserManagement')
BEGIN
    EXEC('CREATE SCHEMA UserManagement');
END
GO

PRINT 'Creating UserManagement schema tables...'
GO

-- =============================================
-- 1. Roles Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Roles]'))
BEGIN
    CREATE TABLE [UserManagement].[Roles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(50) NOT NULL UNIQUE,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2 NULL
    );
    
    CREATE INDEX IX_Roles_Name ON [UserManagement].[Roles]([Name]);
    PRINT '✅ Table [UserManagement].[Roles] created';
END
GO

-- =============================================
-- 2. Permissions Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[Permissions]'))
BEGIN
    CREATE TABLE [UserManagement].[Permissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Name] NVARCHAR(100) NOT NULL,
        [Resource] NVARCHAR(50) NOT NULL,
        [Action] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(500),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT UQ_Permission_Resource_Action UNIQUE ([Resource], [Action])
    );
    
    CREATE INDEX IX_Permissions_Resource ON [UserManagement].[Permissions]([Resource]);
    PRINT '✅ Table [UserManagement].[Permissions] created';
END
GO

-- =============================================
-- 3. RolePermissions Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[RolePermissions]'))
BEGIN
    CREATE TABLE [UserManagement].[RolePermissions] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [PermissionId] UNIQUEIDENTIFIER NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserManagement_RolePermissions_Role 
            FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserManagement_RolePermissions_Permission 
            FOREIGN KEY ([PermissionId]) REFERENCES [UserManagement].[Permissions]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_UserManagement_RolePermission UNIQUE ([RoleId], [PermissionId])
    );
    
    CREATE INDEX IX_UserManagement_RolePermissions_RoleId ON [UserManagement].[RolePermissions]([RoleId]);
    CREATE INDEX IX_UserManagement_RolePermissions_PermissionId ON [UserManagement].[RolePermissions]([PermissionId]);
    PRINT '✅ Table [UserManagement].[RolePermissions] created';
END
GO

-- =============================================
-- 4. Users Table
-- =============================================
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
    
    CREATE UNIQUE INDEX IX_UserManagement_Users_Email ON [UserManagement].[Users]([Email]);
    CREATE INDEX IX_UserManagement_Users_Country_City ON [UserManagement].[Users]([Country], [City]);
    CREATE INDEX IX_UserManagement_Users_CreatedAt ON [UserManagement].[Users]([CreatedAt] DESC);
    PRINT '✅ Table [UserManagement].[Users] created';
END
GO

-- =============================================
-- 5. UserRoles Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserRoles]'))
BEGIN
    CREATE TABLE [UserManagement].[UserRoles] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [RoleId] UNIQUEIDENTIFIER NOT NULL,
        [AssignedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [AssignedBy] UNIQUEIDENTIFIER NULL,
        CONSTRAINT FK_UserManagement_UserRoles_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserManagement_UserRoles_Role 
            FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles]([Id]) ON DELETE CASCADE,
        CONSTRAINT UQ_UserManagement_UserRole UNIQUE ([UserId], [RoleId])
    );
    
    CREATE INDEX IX_UserManagement_UserRoles_UserId ON [UserManagement].[UserRoles]([UserId]);
    CREATE INDEX IX_UserManagement_UserRoles_RoleId ON [UserManagement].[UserRoles]([RoleId]);
    PRINT '✅ Table [UserManagement].[UserRoles] created';
END
GO

-- =============================================
-- 6. Sessions Table
-- =============================================
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
        CONSTRAINT FK_UserManagement_Sessions_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE UNIQUE INDEX IX_UserManagement_Sessions_RefreshToken ON [UserManagement].[Sessions]([RefreshToken]);
    CREATE INDEX IX_UserManagement_Sessions_UserId ON [UserManagement].[Sessions]([UserId]);
    CREATE INDEX IX_UserManagement_Sessions_ExpiresAt ON [UserManagement].[Sessions]([ExpiresAt]);
    PRINT '✅ Table [UserManagement].[Sessions] created';
END
GO

-- =============================================
-- 7. UserPreferences Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserPreferences]'))
BEGIN
    CREATE TABLE [UserManagement].[UserPreferences] (
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
        CONSTRAINT FK_UserManagement_UserPreferences_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserManagement_UserPreferences_UserId ON [UserManagement].[UserPreferences]([UserId]);
    PRINT '✅ Table [UserManagement].[UserPreferences] created';
END
GO

-- =============================================
-- 8. UserDocuments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[UserDocuments]'))
BEGIN
    CREATE TABLE [UserManagement].[UserDocuments] (
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
        CONSTRAINT FK_UserManagement_UserDocuments_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserManagement_UserDocuments_UserId ON [UserManagement].[UserDocuments]([UserId]);
    CREATE INDEX IX_UserManagement_UserDocuments_Type ON [UserManagement].[UserDocuments]([DocumentType]);
    PRINT '✅ Table [UserManagement].[UserDocuments] created';
END
GO

-- =============================================
-- 9. InsurancePolicies Table
-- =============================================
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
        CONSTRAINT FK_UserManagement_InsurancePolicies_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserManagement_InsurancePolicies_UserId ON [UserManagement].[InsurancePolicies]([UserId]);
    CREATE INDEX IX_UserManagement_InsurancePolicies_PolicyNumber ON [UserManagement].[InsurancePolicies]([PolicyNumber]);
    PRINT '✅ Table [UserManagement].[InsurancePolicies] created';
END
GO

-- =============================================
-- 10. Notifications Table
-- =============================================
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
        CONSTRAINT FK_UserManagement_Notifications_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_UserManagement_Notifications_UserId ON [UserManagement].[Notifications]([UserId]);
    CREATE INDEX IX_UserManagement_Notifications_Status ON [UserManagement].[Notifications]([Status]);
    CREATE INDEX IX_UserManagement_Notifications_CreatedAt ON [UserManagement].[Notifications]([CreatedAt] DESC);
    PRINT '✅ Table [UserManagement].[Notifications] created';
END
GO

-- =============================================
-- 11. AuditLogs Table
-- =============================================
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
        CONSTRAINT FK_UserManagement_AuditLogs_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_UserManagement_AuditLogs_UserId ON [UserManagement].[AuditLogs]([UserId]);
    CREATE INDEX IX_UserManagement_AuditLogs_EntityType ON [UserManagement].[AuditLogs]([EntityType]);
    CREATE INDEX IX_UserManagement_AuditLogs_Timestamp ON [UserManagement].[AuditLogs]([Timestamp] DESC);
    PRINT '✅ Table [UserManagement].[AuditLogs] created';
END
GO

-- =============================================
-- 12. NotificationTemplates Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[NotificationTemplates]'))
BEGIN
    CREATE TABLE [UserManagement].[NotificationTemplates] (
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
    
    CREATE INDEX IX_UserManagement_NotificationTemplates_Type ON [UserManagement].[NotificationTemplates]([Type]);
    PRINT '✅ Table [UserManagement].[NotificationTemplates] created';
END
GO

-- =============================================
-- 13. NotificationSchedules Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UserManagement].[NotificationSchedules]'))
BEGIN
    CREATE TABLE [UserManagement].[NotificationSchedules] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [UserId] UNIQUEIDENTIFIER NOT NULL,
        [TemplateId] UNIQUEIDENTIFIER NOT NULL,
        [ScheduledFor] DATETIME2 NOT NULL,
        [Status] NVARCHAR(20) DEFAULT 'pending',
        [ProcessedAt] DATETIME2 NULL,
        [Data] NVARCHAR(MAX),
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_UserManagement_NotificationSchedules_User 
            FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users]([Id]) ON DELETE CASCADE,
        CONSTRAINT FK_UserManagement_NotificationSchedules_Template 
            FOREIGN KEY ([TemplateId]) REFERENCES [UserManagement].[NotificationTemplates]([Id])
    );
    
    CREATE INDEX IX_UserManagement_NotificationSchedules_ScheduledFor ON [UserManagement].[NotificationSchedules]([ScheduledFor]);
    CREATE INDEX IX_UserManagement_NotificationSchedules_Status ON [UserManagement].[NotificationSchedules]([Status]);
    PRINT '✅ Table [UserManagement].[NotificationSchedules] created';
END
GO

PRINT ''
PRINT '✅ UserManagement schema - 13 tables created successfully'
PRINT ''
GO
