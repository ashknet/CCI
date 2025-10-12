-- =============================================
-- Medical Travel Booking Platform
-- Checklist Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelChecklistDB')
BEGIN
    CREATE DATABASE MedicalTravelChecklistDB;
END
GO

USE MedicalTravelChecklistDB;
GO

-- Checklist Templates
CREATE TABLE ChecklistTemplates (
    TemplateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TemplateName NVARCHAR(255) NOT NULL,
    TemplateType NVARCHAR(50) NOT NULL, -- PreTravel, PreOp, PostOp, Recovery, General
    DiseaseId UNIQUEIDENTIFIER, -- Optional: specific to disease
    SpecialtyId UNIQUEIDENTIFIER, -- Optional: specific to specialty
    ProcedureType NVARCHAR(255),
    Description NVARCHAR(MAX),
    IsActive BIT DEFAULT 1,
    CreatedBy UNIQUEIDENTIFIER,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_ChecklistTemplates_TemplateType (TemplateType),
    INDEX IX_ChecklistTemplates_DiseaseId (DiseaseId)
);

-- Checklist Template Items
CREATE TABLE ChecklistTemplateItems (
    ItemId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    TemplateId UNIQUEIDENTIFIER NOT NULL,
    ItemTitle NVARCHAR(255) NOT NULL,
    ItemDescription NVARCHAR(MAX),
    Category NVARCHAR(100), -- Documents, Medications, Preparation, Travel, etc.
    IsMandatory BIT DEFAULT 0,
    DisplayOrder INT DEFAULT 0,
    DaysBeforeAppointment INT, -- When to complete (negative = before, positive = after)
    EstimatedTimeMinutes INT,
    ResourceLinks NVARCHAR(MAX), -- JSON array of helpful links
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (TemplateId) REFERENCES ChecklistTemplates(TemplateId) ON DELETE CASCADE,
    INDEX IX_ChecklistTemplateItems_TemplateId (TemplateId)
);

-- User Checklists
CREATE TABLE UserChecklists (
    ChecklistId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    TemplateId UNIQUEIDENTIFIER,
    AppointmentId UNIQUEIDENTIFIER, -- Link to appointment
    ChecklistName NVARCHAR(255) NOT NULL,
    ChecklistType NVARCHAR(50) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'InProgress', -- NotStarted, InProgress, Completed
    TotalItems INT DEFAULT 0,
    CompletedItems INT DEFAULT 0,
    ProgressPercentage DECIMAL(5,2) DEFAULT 0.0,
    DueDate DATE,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    CompletedAt DATETIME2,
    INDEX IX_UserChecklists_UserId (UserId),
    INDEX IX_UserChecklists_AppointmentId (AppointmentId),
    INDEX IX_UserChecklists_Status (Status)
);

-- User Checklist Items
CREATE TABLE UserChecklistItems (
    UserItemId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ChecklistId UNIQUEIDENTIFIER NOT NULL,
    TemplateItemId UNIQUEIDENTIFIER,
    ItemTitle NVARCHAR(255) NOT NULL,
    ItemDescription NVARCHAR(MAX),
    Category NVARCHAR(100),
    IsMandatory BIT DEFAULT 0,
    IsCompleted BIT DEFAULT 0,
    CompletedAt DATETIME2,
    DueDate DATE,
    DisplayOrder INT DEFAULT 0,
    UserNotes NVARCHAR(MAX),
    ReminderSent BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ChecklistId) REFERENCES UserChecklists(ChecklistId) ON DELETE CASCADE,
    INDEX IX_UserChecklistItems_ChecklistId (ChecklistId),
    INDEX IX_UserChecklistItems_IsCompleted (IsCompleted)
);

-- Checklist Item Attachments
CREATE TABLE ChecklistItemAttachments (
    AttachmentId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserItemId UNIQUEIDENTIFIER NOT NULL,
    FileName NVARCHAR(255) NOT NULL,
    FileUrl NVARCHAR(500) NOT NULL,
    FileSize BIGINT,
    MimeType NVARCHAR(100),
    UploadedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserItemId) REFERENCES UserChecklistItems(UserItemId) ON DELETE CASCADE,
    INDEX IX_ChecklistItemAttachments_UserItemId (UserItemId)
);

-- Travel Requirements
CREATE TABLE TravelRequirements (
    RequirementId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CountryFrom NVARCHAR(100) NOT NULL,
    CountryTo NVARCHAR(100) NOT NULL,
    RequirementType NVARCHAR(50) NOT NULL, -- Visa, Vaccination, Insurance, etc.
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    IsMandatory BIT DEFAULT 1,
    ProcessingTime NVARCHAR(100), -- e.g., "2-4 weeks"
    ValidityPeriod NVARCHAR(100),
    Cost DECIMAL(10,2),
    Currency NVARCHAR(10),
    OfficialWebsite NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    LastVerifiedDate DATE,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_TravelRequirements_CountryFrom (CountryFrom),
    INDEX IX_TravelRequirements_CountryTo (CountryTo),
    INDEX IX_TravelRequirements_RequirementType (RequirementType)
);

-- Medical Documents Templates
CREATE TABLE MedicalDocumentTemplates (
    DocumentTemplateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DocumentName NVARCHAR(255) NOT NULL,
    DocumentType NVARCHAR(50) NOT NULL, -- MedicalHistory, LabResults, Prescription, etc.
    Description NVARCHAR(MAX),
    IsRequired BIT DEFAULT 0,
    TemplateUrl NVARCHAR(500), -- Link to downloadable template
    Instructions NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_MedicalDocumentTemplates_DocumentType (DocumentType)
);

-- Estimated Costs per Checklist
CREATE TABLE ChecklistCostEstimates (
    CostEstimateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ChecklistId UNIQUEIDENTIFIER NOT NULL,
    ItemCategory NVARCHAR(100) NOT NULL,
    ItemName NVARCHAR(255) NOT NULL,
    EstimatedCost DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    Notes NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ChecklistId) REFERENCES UserChecklists(ChecklistId) ON DELETE CASCADE,
    INDEX IX_ChecklistCostEstimates_ChecklistId (ChecklistId)
);

-- Checklist Reminders
CREATE TABLE ChecklistReminders (
    ReminderId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserItemId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    ReminderType NVARCHAR(20) NOT NULL, -- Email, SMS, Push
    ScheduledFor DATETIME2 NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Sent, Failed
    SentAt DATETIME2,
    ErrorMessage NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (UserItemId) REFERENCES UserChecklistItems(UserItemId),
    INDEX IX_ChecklistReminders_UserItemId (UserItemId),
    INDEX IX_ChecklistReminders_ScheduledFor (ScheduledFor),
    INDEX IX_ChecklistReminders_Status (Status)
);

-- Insert Sample Checklist Templates
INSERT INTO ChecklistTemplates (TemplateName, TemplateType, Description) VALUES
('Pre-Travel Checklist', 'PreTravel', 'Essential items to prepare before international medical travel'),
('Pre-Operative Checklist', 'PreOp', 'Items to complete before surgery'),
('Post-Operative Recovery', 'PostOp', 'Recovery guidelines and tasks after surgery'),
('Cardiac Procedure Preparation', 'PreOp', 'Specific preparation for cardiac procedures'),
('International Travel Documents', 'PreTravel', 'Required documents for international medical travel');

-- Insert Sample Template Items for Pre-Travel Checklist
DECLARE @PreTravelTemplateId UNIQUEIDENTIFIER = (SELECT TOP 1 TemplateId FROM ChecklistTemplates WHERE TemplateName = 'Pre-Travel Checklist');

INSERT INTO ChecklistTemplateItems (TemplateId, ItemTitle, ItemDescription, Category, IsMandatory, DisplayOrder, DaysBeforeAppointment) VALUES
(@PreTravelTemplateId, 'Valid Passport', 'Ensure your passport is valid for at least 6 months beyond your travel dates', 'Documents', 1, 1, -30),
(@PreTravelTemplateId, 'Medical Visa', 'Apply for medical visa if required for destination country', 'Documents', 1, 2, -45),
(@PreTravelTemplateId, 'Travel Insurance', 'Purchase comprehensive travel and medical insurance', 'Insurance', 1, 3, -21),
(@PreTravelTemplateId, 'Medical Records', 'Gather all relevant medical records, test results, and imaging', 'Documents', 1, 4, -14),
(@PreTravelTemplateId, 'Prescription Medications', 'Obtain sufficient supply of current medications plus prescriptions', 'Medications', 1, 5, -7),
(@PreTravelTemplateId, 'Emergency Contacts', 'Prepare list of emergency contacts including local embassy', 'Preparation', 1, 6, -7),
(@PreTravelTemplateId, 'Currency Exchange', 'Exchange currency or arrange for payment methods', 'Travel', 0, 7, -3),
(@PreTravelTemplateId, 'Comfortable Clothing', 'Pack loose, comfortable clothing suitable for recovery', 'Travel', 0, 8, -2),
(@PreTravelTemplateId, 'Flight Confirmation', 'Confirm flight details and arrange airport transfers', 'Travel', 1, 9, -7),
(@PreTravelTemplateId, 'Accommodation Confirmation', 'Confirm hotel/accommodation booking near hospital', 'Travel', 1, 10, -7);

-- Insert Sample Template Items for Pre-Op Checklist
DECLARE @PreOpTemplateId UNIQUEIDENTIFIER = (SELECT TOP 1 TemplateId FROM ChecklistTemplates WHERE TemplateName = 'Pre-Operative Checklist');

INSERT INTO ChecklistTemplateItems (TemplateId, ItemTitle, ItemDescription, Category, IsMandatory, DisplayOrder, DaysBeforeAppointment) VALUES
(@PreOpTemplateId, 'Pre-Op Consultation', 'Attend pre-operative consultation with surgeon', 'Preparation', 1, 1, -7),
(@PreOpTemplateId, 'Blood Tests', 'Complete required blood work and lab tests', 'Preparation', 1, 2, -5),
(@PreOpTemplateId, 'Stop Blood Thinners', 'Discontinue blood thinning medications as instructed', 'Medications', 1, 3, -7),
(@PreOpTemplateId, 'Fasting Instructions', 'Follow fasting instructions (usually 8 hours before surgery)', 'Preparation', 1, 4, 0),
(@PreOpTemplateId, 'Arrange Caregiver', 'Ensure someone can accompany you and assist post-surgery', 'Preparation', 1, 5, -3),
(@PreOpTemplateId, 'Remove Jewelry/Makeup', 'Remove all jewelry, makeup, and nail polish', 'Preparation', 1, 6, 0);

-- Insert Travel Requirements
INSERT INTO TravelRequirements (CountryFrom, CountryTo, RequirementType, Title, Description, IsMandatory, ProcessingTime) VALUES
('USA', 'India', 'Visa', 'Medical Visa', 'Medical visa required for treatment in India. Must be accompanied by a medical letter from the hospital.', 1, '3-5 business days'),
('USA', 'Singapore', 'Vaccination', 'COVID-19 Vaccination', 'Proof of COVID-19 vaccination may be required', 0, 'N/A'),
('USA', 'UAE', 'Visa', 'Medical Visa', 'Visit visa sufficient for medical treatment up to 90 days', 1, '2-3 business days'),
('All', 'All', 'Insurance', 'Travel Medical Insurance', 'Comprehensive travel and medical insurance highly recommended', 0, 'Immediate');

-- Insert Medical Document Templates
INSERT INTO MedicalDocumentTemplates (DocumentName, DocumentType, Description, IsRequired) VALUES
('Medical History Form', 'MedicalHistory', 'Complete medical history including previous surgeries and conditions', 1),
('Current Medications List', 'Medications', 'List of all current medications with dosages', 1),
('Allergy Information', 'Allergies', 'Detailed list of known allergies and reactions', 1),
('Previous Lab Results', 'LabResults', 'Recent blood work, imaging, and diagnostic test results', 1),
('Doctor Referral Letter', 'Referral', 'Letter from your primary physician or specialist', 0),
('Insurance Pre-Authorization', 'Insurance', 'Insurance approval for medical procedure if applicable', 0);

GO
