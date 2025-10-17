-- =============================================
-- Insert 100 Message Threads between Patients and Doctors
-- =============================================

PRINT 'Inserting 100 Message Threads...';

-- Get sample data
DECLARE @UserIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100));
INSERT INTO @UserIds 
SELECT TOP 50 Id, FirstName, LastName FROM UserManagement.Users ORDER BY CreatedAt;

DECLARE @DoctorIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100));
INSERT INTO @DoctorIds 
SELECT TOP 50 Id, FirstName, LastName FROM Hospital.Doctors ORDER BY CreatedAt;

DECLARE @Counter INT = 1;
DECLARE @ThreadId UNIQUEIDENTIFIER;
DECLARE @UserId UNIQUEIDENTIFIER;
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @Subject NVARCHAR(500);
DECLARE @ParticipantIds NVARCHAR(MAX);
DECLARE @ThreadType NVARCHAR(50);
DECLARE @IsActive BIT;
DECLARE @IsArchived BIT;
DECLARE @LastMessageAt DATETIME2(7);
DECLARE @CreatedAt DATETIME2(7);
DECLARE @CreatedBy UNIQUEIDENTIFIER;

-- Thread subjects
DECLARE @Subjects TABLE (Subject NVARCHAR(500));
INSERT INTO @Subjects VALUES 
('Follow-up questions about medication'),
('Appointment scheduling inquiry'),
('Treatment plan discussion'),
('Side effects and concerns'),
('Test results consultation'),
('Prescription refill request'),
('Emergency medical advice'),
('Second opinion consultation'),
('Post-surgery follow-up'),
('General health queries'),
('Vaccination schedule questions'),
('Diet and lifestyle advice'),
('Medication dosage clarification'),
('Symptom assessment and guidance'),
('Preventive care consultation'),
('Chronic condition management'),
('Family health concerns'),
('Travel health advice'),
('Mental health support'),
('Recovery progress update');

-- Insert threads dynamically
WHILE @Counter <= 100
BEGIN
    -- Select random user and doctor
    SELECT TOP 1 @UserId = Id FROM @UserIds ORDER BY NEWID();
    SELECT TOP 1 @DoctorId = Id FROM @DoctorIds ORDER BY NEWID();
    
    -- Select random subject
    SELECT TOP 1 @Subject = Subject FROM @Subjects ORDER BY NEWID();
    
    -- Set participant IDs (JSON format)
    SET @ParticipantIds = '["' + CAST(@UserId AS NVARCHAR(50)) + '","' + CAST(@DoctorId AS NVARCHAR(50)) + '"]';
    
    -- Set thread type
    SET @ThreadType = 'patient_doctor';
    
    -- Set active status (90% active, 10% archived)
    SET @IsActive = CASE WHEN ABS(CHECKSUM(NEWID())) % 10 < 9 THEN 1 ELSE 0 END;
    SET @IsArchived = CASE WHEN @IsActive = 1 THEN 0 ELSE 1 END;
    
    -- Set creation date (within last 6 months)
    SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 180), GETUTCDATE());
    SET @CreatedBy = @UserId; -- Patient creates the thread
    
    -- Set last message date (within last 3 months)
    SET @LastMessageAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 90), GETUTCDATE());
    
    SET @ThreadId = NEWID();
    
    INSERT INTO Messaging.Threads 
    (Id, Subject, ParticipantIds, ThreadType, IsActive, IsArchived, LastMessageAt, CreatedAt, CreatedBy)
    VALUES 
    (@ThreadId, @Subject, @ParticipantIds, @ThreadType, @IsActive, @IsArchived, @LastMessageAt, @CreatedAt, @CreatedBy);
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 100 message threads!';
GO
