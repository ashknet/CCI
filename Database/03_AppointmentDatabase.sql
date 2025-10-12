-- =============================================
-- Medical Travel Booking Platform
-- Appointment Management Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelAppointmentDB')
BEGIN
    CREATE DATABASE MedicalTravelAppointmentDB;
END
GO

USE MedicalTravelAppointmentDB;
GO

-- Doctor Availability Schedule
CREATE TABLE DoctorAvailability (
    AvailabilityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DoctorId UNIQUEIDENTIFIER NOT NULL,
    DayOfWeek INT NOT NULL, -- 0=Sunday, 6=Saturday
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_DoctorAvailability_DoctorId (DoctorId),
    INDEX IX_DoctorAvailability_DayOfWeek (DayOfWeek)
);

-- Doctor Time Slots (30-minute intervals)
CREATE TABLE TimeSlots (
    TimeSlotId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    DoctorId UNIQUEIDENTIFIER NOT NULL,
    SlotDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    IsBooked BIT DEFAULT 0,
    IsBlocked BIT DEFAULT 0, -- For holidays, doctor unavailability
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_TimeSlots_DoctorId (DoctorId),
    INDEX IX_TimeSlots_SlotDate (SlotDate),
    INDEX IX_TimeSlots_IsBooked (IsBooked)
);

-- Appointments
CREATE TABLE Appointments (
    AppointmentId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PatientId UNIQUEIDENTIFIER NOT NULL, -- References UserService.Users
    DoctorId UNIQUEIDENTIFIER NOT NULL, -- References ProviderService.Doctors
    HospitalId UNIQUEIDENTIFIER NOT NULL, -- References ProviderService.Hospitals
    TimeSlotId UNIQUEIDENTIFIER NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Duration INT DEFAULT 30, -- Minutes
    AppointmentType NVARCHAR(50) NOT NULL, -- Consultation, Follow-up, Surgery, etc.
    Status NVARCHAR(50) NOT NULL DEFAULT 'Scheduled', -- Scheduled, Confirmed, Completed, Cancelled, NoShow
    ReasonForVisit NVARCHAR(MAX),
    SpecialRequirements NVARCHAR(MAX),
    PatientNotes NVARCHAR(MAX),
    DoctorNotes NVARCHAR(MAX),
    CancellationReason NVARCHAR(500),
    CancelledBy UNIQUEIDENTIFIER,
    CancelledAt DATETIME2,
    ConfirmedAt DATETIME2,
    CompletedAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (TimeSlotId) REFERENCES TimeSlots(TimeSlotId),
    INDEX IX_Appointments_PatientId (PatientId),
    INDEX IX_Appointments_DoctorId (DoctorId),
    INDEX IX_Appointments_HospitalId (HospitalId),
    INDEX IX_Appointments_AppointmentDate (AppointmentDate),
    INDEX IX_Appointments_Status (Status)
);

-- Appointment Reminders
CREATE TABLE AppointmentReminders (
    ReminderId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AppointmentId UNIQUEIDENTIFIER NOT NULL,
    ReminderType NVARCHAR(20) NOT NULL, -- Email, SMS, Push
    ScheduledFor DATETIME2 NOT NULL,
    SentAt DATETIME2,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Sent, Failed
    ErrorMessage NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId) ON DELETE CASCADE,
    INDEX IX_AppointmentReminders_AppointmentId (AppointmentId),
    INDEX IX_AppointmentReminders_ScheduledFor (ScheduledFor),
    INDEX IX_AppointmentReminders_Status (Status)
);

-- Appointment Documents
CREATE TABLE AppointmentDocuments (
    DocumentId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AppointmentId UNIQUEIDENTIFIER NOT NULL,
    DocumentType NVARCHAR(50) NOT NULL, -- Prescription, LabReport, MedicalRecord, Invoice
    DocumentName NVARCHAR(255) NOT NULL,
    DocumentUrl NVARCHAR(500) NOT NULL,
    FileSize BIGINT,
    MimeType NVARCHAR(100),
    UploadedBy UNIQUEIDENTIFIER NOT NULL,
    UploadedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId) ON DELETE CASCADE,
    INDEX IX_AppointmentDocuments_AppointmentId (AppointmentId)
);

-- Reschedule History
CREATE TABLE RescheduleHistory (
    RescheduleId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    AppointmentId UNIQUEIDENTIFIER NOT NULL,
    OldDate DATE NOT NULL,
    OldTime TIME NOT NULL,
    NewDate DATE NOT NULL,
    NewTime TIME NOT NULL,
    Reason NVARCHAR(500),
    RescheduledBy UNIQUEIDENTIFIER NOT NULL,
    RescheduledAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId),
    INDEX IX_RescheduleHistory_AppointmentId (AppointmentId)
);

-- Insert Sample Doctor Availability
INSERT INTO DoctorAvailability (DoctorId, DayOfWeek, StartTime, EndTime) VALUES
('11111111-1111-1111-1111-111111111111', 1, '09:00:00', '17:00:00'), -- Monday
('11111111-1111-1111-1111-111111111111', 2, '09:00:00', '17:00:00'), -- Tuesday
('11111111-1111-1111-1111-111111111111', 3, '09:00:00', '17:00:00'), -- Wednesday
('11111111-1111-1111-1111-111111111111', 4, '09:00:00', '17:00:00'), -- Thursday
('11111111-1111-1111-1111-111111111111', 5, '09:00:00', '13:00:00'); -- Friday

-- Generate time slots for next 30 days (example for one doctor)
DECLARE @StartDate DATE = CAST(GETUTCDATE() AS DATE);
DECLARE @EndDate DATE = DATEADD(DAY, 30, @StartDate);
DECLARE @CurrentDate DATE = @StartDate;
DECLARE @DoctorIdSample UNIQUEIDENTIFIER = '11111111-1111-1111-1111-111111111111';

WHILE @CurrentDate <= @EndDate
BEGIN
    DECLARE @DayOfWeek INT = DATEPART(WEEKDAY, @CurrentDate) - 1;
    
    -- Check if doctor is available on this day
    IF EXISTS (SELECT 1 FROM DoctorAvailability WHERE DoctorId = @DoctorIdSample AND DayOfWeek = @DayOfWeek AND IsActive = 1)
    BEGIN
        DECLARE @StartTimeStr TIME, @EndTimeStr TIME;
        SELECT @StartTimeStr = StartTime, @EndTimeStr = EndTime 
        FROM DoctorAvailability 
        WHERE DoctorId = @DoctorIdSample AND DayOfWeek = @DayOfWeek AND IsActive = 1;
        
        -- Generate 30-minute slots
        DECLARE @CurrentTime TIME = @StartTimeStr;
        WHILE @CurrentTime < @EndTimeStr
        BEGIN
            INSERT INTO TimeSlots (DoctorId, SlotDate, StartTime, EndTime, IsBooked, IsBlocked)
            VALUES (@DoctorIdSample, @CurrentDate, @CurrentTime, DATEADD(MINUTE, 30, @CurrentTime), 0, 0);
            
            SET @CurrentTime = DATEADD(MINUTE, 30, @CurrentTime);
        END
    END
    
    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END

-- Insert Sample Appointments
DECLARE @SampleTimeSlotId UNIQUEIDENTIFIER = (SELECT TOP 1 TimeSlotId FROM TimeSlots WHERE IsBooked = 0 AND SlotDate > GETUTCDATE());

INSERT INTO Appointments (PatientId, DoctorId, HospitalId, TimeSlotId, AppointmentDate, AppointmentTime, AppointmentType, Status, ReasonForVisit)
VALUES 
('11111111-1111-1111-1111-000000000001', '11111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-222222222222', 
 @SampleTimeSlotId, CAST(DATEADD(DAY, 5, GETUTCDATE()) AS DATE), '10:00:00', 'Consultation', 'Scheduled', 
 'Chest pain and shortness of breath');

-- Update the time slot as booked
UPDATE TimeSlots SET IsBooked = 1 WHERE TimeSlotId = @SampleTimeSlotId;

GO
