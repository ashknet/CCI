-- =============================================
-- Insert 200 Appointments across all users and doctors
-- =============================================

PRINT 'Inserting 200 Appointments...';

-- Get sample user and doctor IDs
DECLARE @UserIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100));
INSERT INTO @UserIds 
SELECT TOP 50 Id, FirstName, LastName FROM UserManagement.Users ORDER BY CreatedAt;

DECLARE @DoctorIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100), HospitalId UNIQUEIDENTIFIER, ConsultationFee DECIMAL(18,2));
INSERT INTO @DoctorIds 
SELECT TOP 50 Id, FirstName, LastName, HospitalId, ConsultationFee FROM Hospital.Doctors ORDER BY CreatedAt;

DECLARE @Counter INT = 1;
DECLARE @AppointmentId UNIQUEIDENTIFIER;
DECLARE @UserId UNIQUEIDENTIFIER;
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @HospitalId UNIQUEIDENTIFIER;
DECLARE @ScheduledDate DATE;
DECLARE @ScheduledTime TIME(7);
DECLARE @Status NVARCHAR(20);
DECLARE @ReasonForVisit NVARCHAR(500);
DECLARE @Fee DECIMAL(18,2);
DECLARE @IsPaid BIT;
DECLARE @PaidAt DATETIME2(7);
DECLARE @CancellationReason NVARCHAR(500);
DECLARE @CancelledAt DATETIME2(7);
DECLARE @CreatedAt DATETIME2(7);

-- Appointment reasons
DECLARE @Reasons TABLE (Reason NVARCHAR(500));
INSERT INTO @Reasons VALUES 
('Regular health checkup and consultation'),
('Chest pain and breathing difficulties'),
('High blood pressure monitoring'),
('Diabetes management and follow-up'),
('Knee pain and joint stiffness'),
('Severe headaches and dizziness'),
('Child vaccination and routine checkup'),
('Pregnancy consultation and monitoring'),
('Skin rash and allergy symptoms'),
('Eye examination and vision problems'),
('Ear infection and hearing issues'),
('Mental health counseling session'),
('Thyroid function test and consultation'),
('Lung function test and respiratory issues'),
('Kidney function test and consultation'),
('Urinary tract infection treatment'),
('Gynecological examination and consultation'),
('Dermatological consultation for skin issues'),
('Ophthalmological examination'),
('ENT consultation for throat problems'),
('Psychiatric evaluation and therapy'),
('Endocrine disorder management'),
('Pulmonary function assessment'),
('General surgery consultation'),
('Orthopedic consultation for bone issues'),
('Neurological examination'),
('Cardiological assessment'),
('Oncological consultation'),
('Gastroenterological examination'),
('Nephrological consultation');

-- Appointment statuses
DECLARE @Statuses TABLE (Status NVARCHAR(20), Weight INT);
INSERT INTO @Statuses VALUES 
('completed', 40),    -- 40% completed
('confirmed', 30),    -- 30% confirmed
('scheduled', 20),    -- 20% scheduled
('cancelled', 10);    -- 10% cancelled

-- Insert appointments dynamically
WHILE @Counter <= 200
BEGIN
    -- Select random user and doctor
    SELECT TOP 1 @UserId = Id FROM @UserIds ORDER BY NEWID();
    SELECT TOP 1 @DoctorId = Id, @HospitalId = HospitalId, @Fee = ConsultationFee FROM @DoctorIds ORDER BY NEWID();
    
    -- Select random reason
    SELECT TOP 1 @ReasonForVisit = Reason FROM @Reasons ORDER BY NEWID();
    
    -- Select status with weighted probability
    DECLARE @RandomWeight INT = ABS(CHECKSUM(NEWID())) % 100;
    IF @RandomWeight < 40
        SET @Status = 'completed'
    ELSE IF @RandomWeight < 70
        SET @Status = 'confirmed'
    ELSE IF @RandomWeight < 90
        SET @Status = 'scheduled'
    ELSE
        SET @Status = 'cancelled';
    
    -- Set dates based on status
    IF @Status = 'completed'
    BEGIN
        SET @ScheduledDate = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 90), CAST(GETUTCDATE() AS DATE));
        SET @IsPaid = 1;
        SET @PaidAt = DATEADD(HOUR, ABS(CHECKSUM(NEWID())) % 24, @ScheduledDate);
        SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 30), @ScheduledDate);
    END
    ELSE IF @Status = 'confirmed'
    BEGIN
        SET @ScheduledDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30, CAST(GETUTCDATE() AS DATE));
        SET @IsPaid = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 0 END;
        SET @PaidAt = CASE WHEN @IsPaid = 1 THEN DATEADD(HOUR, ABS(CHECKSUM(NEWID())) % 24, @ScheduledDate) ELSE NULL END;
        SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 15), GETUTCDATE());
    END
    ELSE IF @Status = 'scheduled'
    BEGIN
        SET @ScheduledDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 60, CAST(GETUTCDATE() AS DATE));
        SET @IsPaid = 0;
        SET @PaidAt = NULL;
        SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 10), GETUTCDATE());
    END
    ELSE -- cancelled
    BEGIN
        SET @ScheduledDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 30, CAST(GETUTCDATE() AS DATE));
        SET @IsPaid = 0;
        SET @PaidAt = NULL;
        SET @CancellationReason = CASE ABS(CHECKSUM(NEWID())) % 5
            WHEN 0 THEN 'Patient requested cancellation'
            WHEN 1 THEN 'Doctor unavailable'
            WHEN 2 THEN 'Emergency situation'
            WHEN 3 THEN 'Rescheduled to different time'
            ELSE 'Personal reasons'
        END;
        SET @CancelledAt = DATEADD(HOUR, ABS(CHECKSUM(NEWID())) % 24, @ScheduledDate);
        SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 20), GETUTCDATE());
    END
    
    -- Set random time between 9 AM and 6 PM
    SET @ScheduledTime = CAST(DATEADD(MINUTE, (9 * 60) + (ABS(CHECKSUM(NEWID())) % (9 * 60)), '00:00:00') AS TIME(7));
    
    SET @AppointmentId = NEWID();
    
    INSERT INTO Hospital.Appointments 
    (Id, DoctorId, PatientId, ScheduledDate, ScheduledTime, DurationMinutes, Status, ReasonForVisit, 
     Fee, IsPaid, PaidAt, CancellationReason, CancelledAt, CreatedAt)
    VALUES 
    (@AppointmentId, @DoctorId, @UserId, @ScheduledDate, @ScheduledTime, 30, @Status, @ReasonForVisit,
     @Fee, @IsPaid, @PaidAt, @CancellationReason, @CancelledAt, @CreatedAt);
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 200 appointments!';
GO
