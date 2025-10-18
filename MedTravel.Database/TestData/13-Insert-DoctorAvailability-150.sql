-- =============================================
-- Insert Doctor Availability Data
-- =============================================

PRINT 'Inserting Doctor Availability Data...';

-- Declare variables
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @Counter INT = 1;
DECLARE @TotalDoctors INT;
DECLARE @DayOfWeek INT;
DECLARE @StartTime TIME;
DECLARE @EndTime TIME;
DECLARE @SlotDuration INT;

-- Get total count of active doctors
SELECT @TotalDoctors = COUNT(*) FROM Hospital.Doctors WHERE IsActive = 1;

PRINT 'Total Active Doctors: ' + CAST(@TotalDoctors AS NVARCHAR(10));

-- Create temporary table for doctors
DECLARE @Doctors TABLE (RowNum INT IDENTITY(1,1), Id UNIQUEIDENTIFIER);
INSERT INTO @Doctors (Id)
SELECT Id FROM Hospital.Doctors WHERE IsActive = 1 ORDER BY Id;

-- Insert availability for each doctor
WHILE @Counter <= @TotalDoctors
BEGIN
    SELECT @DoctorId = Id FROM @Doctors WHERE RowNum = @Counter;
    
    -- Clear existing availability for this doctor
    DELETE FROM Hospital.DoctorAvailability WHERE DoctorId = @DoctorId;
    
    -- Generate availability for each day of the week (Monday to Friday)
    SET @DayOfWeek = 1; -- Monday
    
    WHILE @DayOfWeek <= 5 -- Monday to Friday
    BEGIN
        -- Generate random working hours (most doctors work 8-10 hours)
        SET @StartTime = CAST(DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 120) + 480, '00:00:00') AS TIME); -- 8:00 AM to 10:00 AM
        SET @EndTime = CAST(DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 120) + 960, '00:00:00') AS TIME); -- 4:00 PM to 6:00 PM
        SET @SlotDuration = CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 30 -- 30 minutes
            ELSE 45 -- 45 minutes
        END;
        
        -- Insert availability record
        INSERT INTO Hospital.DoctorAvailability (Id, DoctorId, DayOfWeek, StartTime, EndTime, SlotDurationMinutes, IsActive, CreatedAt)
        VALUES (
            NEWID(),
            @DoctorId,
            @DayOfWeek,
            @StartTime,
            @EndTime,
            @SlotDuration,
            1,
            GETUTCDATE()
        );
        
        SET @DayOfWeek = @DayOfWeek + 1;
    END;
    
    -- Some doctors also work on weekends (30% chance)
    IF ABS(CHECKSUM(NEWID())) % 100 < 30
    BEGIN
        -- Saturday availability
        SET @StartTime = CAST(DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 60) + 540, '00:00:00') AS TIME); -- 9:00 AM to 10:00 AM
        SET @EndTime = CAST(DATEADD(MINUTE, (ABS(CHECKSUM(NEWID())) % 60) + 720, '00:00:00') AS TIME); -- 12:00 PM to 1:00 PM
        SET @SlotDuration = 30;
        
        INSERT INTO Hospital.DoctorAvailability (Id, DoctorId, DayOfWeek, StartTime, EndTime, SlotDurationMinutes, IsActive, CreatedAt)
        VALUES (
            NEWID(),
            @DoctorId,
            6, -- Saturday
            @StartTime,
            @EndTime,
            @SlotDuration,
            1,
            GETUTCDATE()
        );
    END;
    
    SET @Counter = @Counter + 1;
END;

-- Add some special availability patterns for different types of doctors
-- Emergency medicine doctors work different hours
UPDATE da 
SET StartTime = '00:00:00', EndTime = '23:59:59'
FROM Hospital.DoctorAvailability da
INNER JOIN Hospital.Doctors d ON da.DoctorId = d.Id
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
WHERE s.Name = 'Emergency Medicine';

-- Some specialists work only on specific days
-- Update cardiologists to work Monday, Wednesday, Friday
UPDATE da 
SET IsActive = 0
FROM Hospital.DoctorAvailability da
INNER JOIN Hospital.Doctors d ON da.DoctorId = d.Id
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
WHERE s.Name = 'Cardiology' AND da.DayOfWeek IN (2, 4, 6, 7); -- Tuesday, Thursday, Saturday, Sunday

-- Update neurosurgeons to work Tuesday, Thursday, Saturday
UPDATE da 
SET IsActive = 0
FROM Hospital.DoctorAvailability da
INNER JOIN Hospital.Doctors d ON da.DoctorId = d.Id
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
WHERE s.Name = 'Neurosurgery' AND da.DayOfWeek IN (1, 3, 5, 6, 7); -- Monday, Wednesday, Friday, Saturday, Sunday

-- Add some doctors with part-time availability
-- 20% of doctors work part-time (shorter hours)
UPDATE da 
SET EndTime = DATEADD(HOUR, -2, EndTime)
FROM Hospital.DoctorAvailability da
INNER JOIN Hospital.Doctors d ON da.DoctorId = d.Id
WHERE ABS(CHECKSUM(d.Id)) % 100 < 20 AND da.DayOfWeek <= 5;

-- Display summary
DECLARE @TotalAvailability INT;
SELECT @TotalAvailability = COUNT(*) FROM Hospital.DoctorAvailability WHERE IsActive = 1;

PRINT 'Successfully inserted ' + CAST(@TotalAvailability AS NVARCHAR(10)) + ' availability records!';

-- Display sample availability
PRINT '';
PRINT 'Sample Doctor Availability:';
SELECT TOP 10
    d.FirstName + ' ' + d.LastName AS DoctorName,
    h.Name AS Hospital,
    s.Name AS Specialty,
    CASE da.DayOfWeek
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS DayOfWeek,
    da.StartTime,
    da.EndTime,
    da.SlotDurationMinutes,
    da.IsActive
FROM Hospital.DoctorAvailability da
INNER JOIN Hospital.Doctors d ON da.DoctorId = d.Id
INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId AND ds.IsPrimary = 1
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
WHERE da.IsActive = 1
ORDER BY d.FirstName, da.DayOfWeek;

-- Display availability statistics
PRINT '';
PRINT 'Availability Statistics:';
SELECT 
    CASE DayOfWeek
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS DayOfWeek,
    COUNT(*) AS AvailableDoctors,
    AVG(DATEDIFF(MINUTE, StartTime, EndTime)) AS AvgWorkingMinutes,
    AVG(CAST(SlotDurationMinutes AS FLOAT)) AS AvgSlotDuration
FROM Hospital.DoctorAvailability 
WHERE IsActive = 1
GROUP BY DayOfWeek
ORDER BY DayOfWeek;

GO
