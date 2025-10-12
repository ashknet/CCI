-- =============================================
-- Medical Travel Booking Platform
-- Messaging Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelMessagingDB')
BEGIN
    CREATE DATABASE MedicalTravelMessagingDB;
END
GO

USE MedicalTravelMessagingDB;
GO

-- Conversations/Threads
CREATE TABLE Conversations (
    ConversationId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ConversationType NVARCHAR(50) NOT NULL, -- DirectMessage, GroupChat, Support
    Subject NVARCHAR(255),
    AppointmentId UNIQUEIDENTIFIER, -- Optional link to appointment
    IsActive BIT DEFAULT 1,
    CreatedBy UNIQUEIDENTIFIER NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    LastMessageAt DATETIME2,
    INDEX IX_Conversations_ConversationType (ConversationType),
    INDEX IX_Conversations_AppointmentId (AppointmentId),
    INDEX IX_Conversations_LastMessageAt (LastMessageAt)
);

-- Conversation Participants
CREATE TABLE ConversationParticipants (
    ParticipantId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ConversationId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    UserRole NVARCHAR(50), -- Patient, Doctor, Admin, Support
    JoinedAt DATETIME2 DEFAULT GETUTCDATE(),
    LeftAt DATETIME2,
    IsActive BIT DEFAULT 1,
    LastReadAt DATETIME2,
    UnreadCount INT DEFAULT 0,
    FOREIGN KEY (ConversationId) REFERENCES Conversations(ConversationId) ON DELETE CASCADE,
    INDEX IX_ConversationParticipants_ConversationId (ConversationId),
    INDEX IX_ConversationParticipants_UserId (UserId)
);

-- Messages
CREATE TABLE Messages (
    MessageId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ConversationId UNIQUEIDENTIFIER NOT NULL,
    SenderId UNIQUEIDENTIFIER NOT NULL,
    MessageContent NVARCHAR(MAX) NOT NULL,
    MessageType NVARCHAR(50) DEFAULT 'Text', -- Text, Image, Document, Voice
    IsEncrypted BIT DEFAULT 1,
    IsEdited BIT DEFAULT 0,
    IsDeleted BIT DEFAULT 0,
    ParentMessageId UNIQUEIDENTIFIER, -- For replies/threading
    SentAt DATETIME2 DEFAULT GETUTCDATE(),
    EditedAt DATETIME2,
    DeletedAt DATETIME2,
    FOREIGN KEY (ConversationId) REFERENCES Conversations(ConversationId) ON DELETE CASCADE,
    FOREIGN KEY (ParentMessageId) REFERENCES Messages(MessageId),
    INDEX IX_Messages_ConversationId (ConversationId),
    INDEX IX_Messages_SenderId (SenderId),
    INDEX IX_Messages_SentAt (SentAt)
);

-- Message Attachments
CREATE TABLE MessageAttachments (
    AttachmentId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    MessageId UNIQUEIDENTIFIER NOT NULL,
    FileName NVARCHAR(255) NOT NULL,
    FileUrl NVARCHAR(500) NOT NULL,
    FileSize BIGINT,
    MimeType NVARCHAR(100),
    IsEncrypted BIT DEFAULT 1,
    UploadedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MessageId) REFERENCES Messages(MessageId) ON DELETE CASCADE,
    INDEX IX_MessageAttachments_MessageId (MessageId)
);

-- Message Read Receipts
CREATE TABLE MessageReadReceipts (
    ReceiptId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    MessageId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    ReadAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MessageId) REFERENCES Messages(MessageId) ON DELETE CASCADE,
    INDEX IX_MessageReadReceipts_MessageId (MessageId),
    INDEX IX_MessageReadReceipts_UserId (UserId)
);

-- Automated Messages/Templates
CREATE TABLE MessageTemplates (
    TemplateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TemplateName NVARCHAR(100) NOT NULL,
    TemplateType NVARCHAR(50) NOT NULL, -- Appointment, Reminder, Welcome, etc.
    Subject NVARCHAR(255),
    BodyTemplate NVARCHAR(MAX) NOT NULL, -- Can contain placeholders like {PatientName}, {DoctorName}
    LanguageCode NVARCHAR(10) DEFAULT 'en',
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_MessageTemplates_TemplateType (TemplateType),
    INDEX IX_MessageTemplates_LanguageCode (LanguageCode)
);

-- Support Tickets (Special type of conversation)
CREATE TABLE SupportTickets (
    TicketId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ConversationId UNIQUEIDENTIFIER NOT NULL UNIQUE,
    TicketNumber NVARCHAR(50) UNIQUE NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    Category NVARCHAR(100) NOT NULL, -- Technical, Billing, Medical, Booking
    Priority NVARCHAR(20) NOT NULL DEFAULT 'Medium', -- Low, Medium, High, Urgent
    Status NVARCHAR(50) NOT NULL DEFAULT 'Open', -- Open, InProgress, Resolved, Closed
    Subject NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    AssignedTo UNIQUEIDENTIFIER,
    ResolvedAt DATETIME2,
    ClosedAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ConversationId) REFERENCES Conversations(ConversationId),
    INDEX IX_SupportTickets_UserId (UserId),
    INDEX IX_SupportTickets_Status (Status),
    INDEX IX_SupportTickets_Priority (Priority),
    INDEX IX_SupportTickets_TicketNumber (TicketNumber)
);

-- Message Notifications
CREATE TABLE MessageNotifications (
    NotificationId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    MessageId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    NotificationType NVARCHAR(20) NOT NULL, -- Email, SMS, Push
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Sent, Failed
    SentAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (MessageId) REFERENCES Messages(MessageId),
    INDEX IX_MessageNotifications_MessageId (MessageId),
    INDEX IX_MessageNotifications_UserId (UserId),
    INDEX IX_MessageNotifications_Status (Status)
);

-- Insert Sample Message Templates
INSERT INTO MessageTemplates (TemplateName, TemplateType, Subject, BodyTemplate, LanguageCode) VALUES
('Appointment Confirmation', 'Appointment', 'Your Appointment Confirmation', 
 'Dear {PatientName}, Your appointment with Dr. {DoctorName} on {AppointmentDate} at {AppointmentTime} has been confirmed. Location: {HospitalName}', 'en'),
('Appointment Reminder', 'Reminder', 'Appointment Reminder', 
 'Dear {PatientName}, This is a reminder for your upcoming appointment with Dr. {DoctorName} on {AppointmentDate} at {AppointmentTime}.', 'en'),
('Booking Confirmation', 'Booking', 'Booking Confirmation', 
 'Dear {UserName}, Your booking for {ServiceType} has been confirmed. Booking Reference: {BookingReference}', 'en'),
('Welcome Message', 'Welcome', 'Welcome to Medical Travel Platform', 
 'Dear {UserName}, Welcome to our Medical Travel Booking Platform! We''re here to help you with all your medical travel needs.', 'en');

-- Insert Sample Conversations
INSERT INTO Conversations (ConversationType, Subject, CreatedBy) VALUES
('DirectMessage', 'Consultation Inquiry', '11111111-1111-1111-1111-000000000001'),
('Support', 'Payment Issue', '11111111-1111-1111-1111-000000000001');

-- Insert Sample Participants
DECLARE @Conv1 UNIQUEIDENTIFIER = (SELECT TOP 1 ConversationId FROM Conversations WHERE Subject = 'Consultation Inquiry');
DECLARE @Conv2 UNIQUEIDENTIFIER = (SELECT TOP 1 ConversationId FROM Conversations WHERE Subject = 'Payment Issue');

INSERT INTO ConversationParticipants (ConversationId, UserId, UserRole) VALUES
(@Conv1, '11111111-1111-1111-1111-000000000001', 'Patient'),
(@Conv1, '22222222-2222-2222-2222-000000000001', 'Doctor'),
(@Conv2, '11111111-1111-1111-1111-000000000001', 'Patient'),
(@Conv2, '33333333-3333-3333-3333-000000000001', 'Support');

GO
