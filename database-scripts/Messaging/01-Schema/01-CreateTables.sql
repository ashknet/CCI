-- =============================================
-- MedTravel Platform - Messaging Service Database
-- Schema Creation Script
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MessagingDb')
BEGIN
    CREATE DATABASE MessagingDb;
END
GO

USE MessagingDb;
GO

-- =============================================
-- 1. Threads Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Threads]'))
BEGIN
    CREATE TABLE [dbo].[Threads] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [Subject] NVARCHAR(500),
        [ParticipantIds] NVARCHAR(MAX) NOT NULL, -- JSON array of user IDs
        [ThreadType] NVARCHAR(50) DEFAULT 'patient_doctor', -- patient_doctor, patient_support, group
        [IsActive] BIT DEFAULT 1,
        [IsArchived] BIT DEFAULT 0,
        [LastMessageAt] DATETIME2 NULL,
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        [CreatedBy] UNIQUEIDENTIFIER NOT NULL
    );
    
    CREATE INDEX IX_Threads_CreatedAt ON [dbo].[Threads]([CreatedAt] DESC);
    CREATE INDEX IX_Threads_LastMessageAt ON [dbo].[Threads]([LastMessageAt] DESC);
END
GO

-- =============================================
-- 2. Messages Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Messages]'))
BEGIN
    CREATE TABLE [dbo].[Messages] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [ThreadId] UNIQUEIDENTIFIER NOT NULL,
        [SenderId] UNIQUEIDENTIFIER NOT NULL,
        [Content] NVARCHAR(MAX) NOT NULL,
        [MessageType] NVARCHAR(20) DEFAULT 'text', -- text, image, file
        [IsEncrypted] BIT DEFAULT 1,
        [IsDelivered] BIT DEFAULT 0,
        [IsRead] BIT DEFAULT 0,
        [DeliveredAt] DATETIME2 NULL,
        [ReadAt] DATETIME2 NULL,
        [ReadBy] NVARCHAR(MAX), -- JSON array of user IDs who read
        [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_Messages_Thread FOREIGN KEY ([ThreadId]) REFERENCES [dbo].[Threads]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Messages_ThreadId ON [dbo].[Messages]([ThreadId]);
    CREATE INDEX IX_Messages_SenderId ON [dbo].[Messages]([SenderId]);
    CREATE INDEX IX_Messages_CreatedAt ON [dbo].[Messages]([CreatedAt] DESC);
    CREATE INDEX IX_Messages_IsDelivered ON [dbo].[Messages]([IsDelivered]) WHERE [IsDelivered] = 0;
END
GO

-- =============================================
-- 3. MessageAttachments Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageAttachments]'))
BEGIN
    CREATE TABLE [dbo].[MessageAttachments] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [MessageId] UNIQUEIDENTIFIER NOT NULL,
        [FileName] NVARCHAR(255) NOT NULL,
        [FileUrl] NVARCHAR(1000) NOT NULL,
        [FileSize] BIGINT,
        [MimeType] NVARCHAR(100),
        [IsEncrypted] BIT DEFAULT 1,
        [UploadedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_MessageAttachments_Message FOREIGN KEY ([MessageId]) REFERENCES [dbo].[Messages]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_MessageAttachments_MessageId ON [dbo].[MessageAttachments]([MessageId]);
END
GO

-- =============================================
-- 4. MessageAudit Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageAudit]'))
BEGIN
    CREATE TABLE [dbo].[MessageAudit] (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [MessageId] UNIQUEIDENTIFIER NOT NULL,
        [Action] NVARCHAR(50) NOT NULL, -- created, delivered, read, deleted
        [UserId] UNIQUEIDENTIFIER NULL,
        [IpAddress] NVARCHAR(50),
        [UserAgent] NVARCHAR(500),
        [Timestamp] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
        CONSTRAINT FK_MessageAudit_Message FOREIGN KEY ([MessageId]) REFERENCES [dbo].[Messages]([Id]) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_MessageAudit_MessageId ON [dbo].[MessageAudit]([MessageId]);
    CREATE INDEX IX_MessageAudit_Timestamp ON [dbo].[MessageAudit]([Timestamp] DESC);
END
GO

PRINT 'Messaging Service schema created successfully';
GO
