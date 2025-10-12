-- =============================================
-- Medical Travel Booking Platform
-- Notification Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelNotificationDB')
BEGIN
    CREATE DATABASE MedicalTravelNotificationDB;
END
GO

USE MedicalTravelNotificationDB;
GO

-- Notification Templates
CREATE TABLE NotificationTemplates (
    TemplateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TemplateName NVARCHAR(100) NOT NULL,
    TemplateType NVARCHAR(50) NOT NULL, -- Email, SMS, Push
    NotificationCategory NVARCHAR(50) NOT NULL, -- Appointment, Payment, Booking, Alert, Marketing
    Subject NVARCHAR(255), -- For emails
    BodyTemplate NVARCHAR(MAX) NOT NULL,
    LanguageCode NVARCHAR(10) DEFAULT 'en',
    IsActive BIT DEFAULT 1,
    Priority NVARCHAR(20) DEFAULT 'Normal', -- Low, Normal, High, Urgent
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_NotificationTemplates_TemplateType (TemplateType),
    INDEX IX_NotificationTemplates_NotificationCategory (NotificationCategory)
);

-- Notifications
CREATE TABLE Notifications (
    NotificationId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    TemplateId UNIQUEIDENTIFIER,
    NotificationType NVARCHAR(20) NOT NULL, -- Email, SMS, Push, InApp
    NotificationCategory NVARCHAR(50) NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'Normal',
    Subject NVARCHAR(255),
    MessageBody NVARCHAR(MAX) NOT NULL,
    RecipientEmail NVARCHAR(255),
    RecipientPhone NVARCHAR(20),
    DeviceToken NVARCHAR(500), -- For push notifications
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Sent, Delivered, Failed, Bounced
    ScheduledFor DATETIME2,
    SentAt DATETIME2,
    DeliveredAt DATETIME2,
    ReadAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    RetryCount INT DEFAULT 0,
    MaxRetries INT DEFAULT 3,
    RelatedEntityType NVARCHAR(50), -- Appointment, Booking, Payment
    RelatedEntityId UNIQUEIDENTIFIER,
    Metadata NVARCHAR(MAX), -- JSON for additional data
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (TemplateId) REFERENCES NotificationTemplates(TemplateId),
    INDEX IX_Notifications_UserId (UserId),
    INDEX IX_Notifications_Status (Status),
    INDEX IX_Notifications_ScheduledFor (ScheduledFor),
    INDEX IX_Notifications_NotificationType (NotificationType)
);

-- User Notification Preferences
CREATE TABLE UserNotificationPreferences (
    PreferenceId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL UNIQUE,
    EmailNotifications BIT DEFAULT 1,
    SMSNotifications BIT DEFAULT 1,
    PushNotifications BIT DEFAULT 1,
    InAppNotifications BIT DEFAULT 1,
    AppointmentReminders BIT DEFAULT 1,
    BookingConfirmations BIT DEFAULT 1,
    PaymentNotifications BIT DEFAULT 1,
    MarketingEmails BIT DEFAULT 0,
    NewsletterSubscription BIT DEFAULT 0,
    ReminderLeadTime INT DEFAULT 24, -- Hours before appointment
    QuietHoursStart TIME,
    QuietHoursEnd TIME,
    PreferredLanguage NVARCHAR(10) DEFAULT 'en',
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_UserNotificationPreferences_UserId (UserId)
);

-- Device Tokens (for Push Notifications)
CREATE TABLE UserDeviceTokens (
    TokenId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    DeviceToken NVARCHAR(500) NOT NULL UNIQUE,
    DeviceType NVARCHAR(20) NOT NULL, -- iOS, Android, Web
    DeviceName NVARCHAR(255),
    Platform NVARCHAR(50),
    OSVersion NVARCHAR(50),
    AppVersion NVARCHAR(50),
    IsActive BIT DEFAULT 1,
    LastUsedAt DATETIME2 DEFAULT GETUTCDATE(),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_UserDeviceTokens_UserId (UserId),
    INDEX IX_UserDeviceTokens_DeviceToken (DeviceToken)
);

-- Email Queue
CREATE TABLE EmailQueue (
    EmailId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    NotificationId UNIQUEIDENTIFIER,
    ToEmail NVARCHAR(255) NOT NULL,
    FromEmail NVARCHAR(255) NOT NULL,
    CcEmails NVARCHAR(MAX), -- Comma-separated
    BccEmails NVARCHAR(MAX), -- Comma-separated
    Subject NVARCHAR(255) NOT NULL,
    HtmlBody NVARCHAR(MAX),
    TextBody NVARCHAR(MAX),
    Priority NVARCHAR(20) DEFAULT 'Normal',
    Status NVARCHAR(20) NOT NULL DEFAULT 'Queued', -- Queued, Sending, Sent, Failed
    ScheduledFor DATETIME2,
    SentAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    RetryCount INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (NotificationId) REFERENCES Notifications(NotificationId),
    INDEX IX_EmailQueue_Status (Status),
    INDEX IX_EmailQueue_ScheduledFor (ScheduledFor)
);

-- SMS Queue
CREATE TABLE SMSQueue (
    SMSId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    NotificationId UNIQUEIDENTIFIER,
    ToPhoneNumber NVARCHAR(20) NOT NULL,
    FromPhoneNumber NVARCHAR(20),
    MessageBody NVARCHAR(1000) NOT NULL,
    SMSProvider NVARCHAR(50), -- Twilio, AWS SNS, etc.
    Status NVARCHAR(20) NOT NULL DEFAULT 'Queued',
    ScheduledFor DATETIME2,
    SentAt DATETIME2,
    DeliveredAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    ProviderMessageId NVARCHAR(255),
    RetryCount INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (NotificationId) REFERENCES Notifications(NotificationId),
    INDEX IX_SMSQueue_Status (Status),
    INDEX IX_SMSQueue_ScheduledFor (ScheduledFor)
);

-- Push Notification Queue
CREATE TABLE PushNotificationQueue (
    PushId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    NotificationId UNIQUEIDENTIFIER,
    DeviceToken NVARCHAR(500) NOT NULL,
    Title NVARCHAR(255),
    Body NVARCHAR(1000) NOT NULL,
    Badge INT,
    Sound NVARCHAR(50),
    CustomData NVARCHAR(MAX), -- JSON
    Status NVARCHAR(20) NOT NULL DEFAULT 'Queued',
    ScheduledFor DATETIME2,
    SentAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    ProviderMessageId NVARCHAR(255),
    RetryCount INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (NotificationId) REFERENCES Notifications(NotificationId),
    INDEX IX_PushNotificationQueue_Status (Status),
    INDEX IX_PushNotificationQueue_ScheduledFor (ScheduledFor)
);

-- Notification Logs
CREATE TABLE NotificationLogs (
    LogId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    NotificationId UNIQUEIDENTIFIER NOT NULL,
    LogType NVARCHAR(50) NOT NULL, -- Created, Sent, Delivered, Failed, Opened, Clicked
    LogMessage NVARCHAR(MAX),
    ErrorDetails NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (NotificationId) REFERENCES Notifications(NotificationId),
    INDEX IX_NotificationLogs_NotificationId (NotificationId),
    INDEX IX_NotificationLogs_CreatedAt (CreatedAt)
);

-- Notification Statistics
CREATE TABLE NotificationStatistics (
    StatId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    NotificationCategory NVARCHAR(50) NOT NULL,
    NotificationType NVARCHAR(20) NOT NULL,
    DatePeriod DATE NOT NULL,
    TotalSent INT DEFAULT 0,
    TotalDelivered INT DEFAULT 0,
    TotalFailed INT DEFAULT 0,
    TotalOpened INT DEFAULT 0,
    TotalClicked INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_NotificationStatistics_DatePeriod (DatePeriod),
    INDEX IX_NotificationStatistics_Category (NotificationCategory)
);

-- Insert Sample Notification Templates
INSERT INTO NotificationTemplates (TemplateName, TemplateType, NotificationCategory, Subject, BodyTemplate, Priority) VALUES
('Appointment Confirmation Email', 'Email', 'Appointment', 'Appointment Confirmed', 
 'Dear {PatientName},<br><br>Your appointment with Dr. {DoctorName} has been confirmed for {AppointmentDate} at {AppointmentTime}.<br><br>Hospital: {HospitalName}<br>Address: {HospitalAddress}', 'High'),
 
('Appointment Reminder SMS', 'SMS', 'Appointment', NULL, 
 'Reminder: Your appointment with Dr. {DoctorName} is tomorrow at {AppointmentTime}. Hospital: {HospitalName}', 'High'),
 
('Payment Confirmation', 'Email', 'Payment', 'Payment Received', 
 'Dear {UserName},<br><br>We have received your payment of {Amount} {Currency}. Transaction ID: {TransactionId}.<br><br>Thank you!', 'Normal'),
 
('Booking Confirmation Push', 'Push', 'Booking', NULL, 
 'Your {BookingType} has been confirmed! Reference: {BookingReference}', 'Normal'),
 
('Appointment Cancellation', 'Email', 'Appointment', 'Appointment Cancelled', 
 'Dear {PatientName},<br><br>Your appointment with Dr. {DoctorName} scheduled for {AppointmentDate} has been cancelled.<br><br>Reason: {CancellationReason}', 'High');

-- Insert Sample User Notification Preferences
INSERT INTO UserNotificationPreferences (UserId, ReminderLeadTime) VALUES
('11111111-1111-1111-1111-000000000001', 24),
('22222222-2222-2222-2222-000000000001', 48);

GO
