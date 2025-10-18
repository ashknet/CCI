-- =============================================
-- Insert Doctor Languages Data
-- =============================================

PRINT 'Inserting Doctor Languages Data...';

-- First, insert common languages if they don't exist
IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'English')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'English', 'en', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Hindi')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Hindi', 'hi', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Telugu')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Telugu', 'te', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Tamil')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Tamil', 'ta', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Kannada')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Kannada', 'kn', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Malayalam')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Malayalam', 'ml', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Bengali')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Bengali', 'bn', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Marathi')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Marathi', 'mr', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Gujarati')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Gujarati', 'gu', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Punjabi')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Punjabi', 'pa', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Urdu')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Urdu', 'ur', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Arabic')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Arabic', 'ar', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'French')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'French', 'fr', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'German')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'German', 'de', 1);

IF NOT EXISTS (SELECT 1 FROM Metadata.Languages WHERE Name = 'Spanish')
INSERT INTO Metadata.Languages (Id, Name, Code, IsActive)
VALUES (NEWID(), 'Spanish', 'es', 1);

-- Declare variables
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @LanguageId UNIQUEIDENTIFIER;
DECLARE @Counter INT = 1;
DECLARE @TotalDoctors INT;
DECLARE @TotalLanguages INT;
DECLARE @RandomDoctor INT;
DECLARE @RandomLanguage INT;
DECLARE @ProficiencyLevel NVARCHAR(20);
DECLARE @MaxRelationships INT = 200;

-- Get total counts
SELECT @TotalDoctors = COUNT(*) FROM Hospital.Doctors WHERE IsActive = 1;
SELECT @TotalLanguages = COUNT(*) FROM Metadata.Languages WHERE IsActive = 1;

PRINT 'Total Doctors: ' + CAST(@TotalDoctors AS NVARCHAR(10));
PRINT 'Total Languages: ' + CAST(@TotalLanguages AS NVARCHAR(10));

-- Create temporary tables for efficient random selection
DECLARE @Doctors TABLE (RowNum INT IDENTITY(1,1), Id UNIQUEIDENTIFIER);
DECLARE @Languages TABLE (RowNum INT IDENTITY(1,1), Id UNIQUEIDENTIFIER, Name NVARCHAR(100));

INSERT INTO @Doctors (Id)
SELECT Id FROM Hospital.Doctors WHERE IsActive = 1 ORDER BY Id;

INSERT INTO @Languages (Id, Name)
SELECT Id, Name FROM Metadata.Languages WHERE IsActive = 1 ORDER BY Id;

-- First, ensure all doctors speak English (primary language)
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    'Native',
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name = 'English'
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add Hindi proficiency for most doctors (80% chance)
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    CASE 
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 40 THEN 'Native'
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 70 THEN 'Fluent'
        ELSE 'Intermediate'
    END,
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name = 'Hindi'
  AND ABS(CHECKSUM(d.Id)) % 100 < 80 -- 80% chance
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add Telugu proficiency for some doctors (30% chance)
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    CASE 
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 20 THEN 'Native'
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 50 THEN 'Fluent'
        ELSE 'Intermediate'
    END,
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name = 'Telugu'
  AND ABS(CHECKSUM(d.Id)) % 100 < 30 -- 30% chance
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add Tamil proficiency for some doctors (25% chance)
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    CASE 
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 15 THEN 'Native'
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 40 THEN 'Fluent'
        ELSE 'Intermediate'
    END,
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name = 'Tamil'
  AND ABS(CHECKSUM(d.Id)) % 100 < 25 -- 25% chance
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add other regional languages with lower probabilities
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    CASE 
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 10 THEN 'Native'
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 30 THEN 'Fluent'
        ELSE 'Intermediate'
    END,
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name IN ('Kannada', 'Malayalam', 'Bengali', 'Marathi', 'Gujarati', 'Punjabi', 'Urdu')
  AND ABS(CHECKSUM(d.Id)) % 100 < 15 -- 15% chance for each
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add international languages for some doctors (10% chance)
INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    l.Id,
    CASE 
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 5 THEN 'Native'
        WHEN ABS(CHECKSUM(d.Id)) % 100 < 20 THEN 'Fluent'
        ELSE 'Intermediate'
    END,
    GETUTCDATE()
FROM Hospital.Doctors d
CROSS JOIN Metadata.Languages l
WHERE d.IsActive = 1 
  AND l.Name IN ('Arabic', 'French', 'German', 'Spanish')
  AND ABS(CHECKSUM(d.Id)) % 100 < 10 -- 10% chance for each
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorLanguages dl 
    WHERE dl.DoctorId = d.Id AND dl.LanguageId = l.Id
  );

-- Add some random additional language combinations
WHILE @Counter <= 50 -- Add 50 additional random combinations
BEGIN
    SET @RandomDoctor = (ABS(CHECKSUM(NEWID())) % @TotalDoctors) + 1;
    SET @RandomLanguage = (ABS(CHECKSUM(NEWID())) % @TotalLanguages) + 1;
    
    SELECT @DoctorId = Id FROM @Doctors WHERE RowNum = @RandomDoctor;
    SELECT @LanguageId = Id FROM @Languages WHERE RowNum = @RandomLanguage;
    
    -- Skip English as it's already added
    IF NOT EXISTS (SELECT 1 FROM @Languages WHERE Id = @LanguageId AND Name = 'English')
    BEGIN
        -- Insert if relationship doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM Hospital.DoctorLanguages 
            WHERE DoctorId = @DoctorId AND LanguageId = @LanguageId
        )
        BEGIN
            SET @ProficiencyLevel = CASE (ABS(CHECKSUM(NEWID())) % 3)
                WHEN 0 THEN 'Fluent'
                WHEN 1 THEN 'Intermediate'
                ELSE 'Basic'
            END;
            
            INSERT INTO Hospital.DoctorLanguages (Id, DoctorId, LanguageId, ProficiencyLevel, CreatedAt)
            VALUES (
                NEWID(),
                @DoctorId,
                @LanguageId,
                @ProficiencyLevel,
                GETUTCDATE()
            );
            
            SET @Counter = @Counter + 1;
        END;
    END;
END;

-- Display summary
DECLARE @TotalRelationships INT;
SELECT @TotalRelationships = COUNT(*) FROM Hospital.DoctorLanguages;

PRINT 'Successfully inserted ' + CAST(@TotalRelationships AS NVARCHAR(10)) + ' doctor-language relationships!';

-- Display language distribution
PRINT '';
PRINT 'Language Distribution:';
SELECT 
    l.Name AS Language,
    l.Code,
    COUNT(*) AS DoctorCount,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Native' THEN 1 END) AS NativeSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Fluent' THEN 1 END) AS FluentSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Intermediate' THEN 1 END) AS IntermediateSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Basic' THEN 1 END) AS BasicSpeakers
FROM Hospital.DoctorLanguages dl
INNER JOIN Metadata.Languages l ON dl.LanguageId = l.Id
GROUP BY l.Name, l.Code
ORDER BY DoctorCount DESC;

-- Display sample doctor-language relationships
PRINT '';
PRINT 'Sample Doctor-Language Relationships:';
SELECT TOP 15
    d.FirstName + ' ' + d.LastName AS DoctorName,
    h.Name AS Hospital,
    s.Name AS Specialty,
    l.Name AS Language,
    dl.ProficiencyLevel
FROM Hospital.DoctorLanguages dl
INNER JOIN Hospital.Doctors d ON dl.DoctorId = d.Id
INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
INNER JOIN Metadata.Languages l ON dl.LanguageId = l.Id
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId AND ds.IsPrimary = 1
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
ORDER BY d.FirstName, l.Name;

-- Display doctors with multiple languages
PRINT '';
PRINT 'Doctors with Multiple Languages:';
SELECT 
    d.FirstName + ' ' + d.LastName AS DoctorName,
    h.Name AS Hospital,
    COUNT(*) AS LanguageCount,
    STRING_AGG(l.Name + ' (' + dl.ProficiencyLevel + ')', ', ') AS Languages
FROM Hospital.DoctorLanguages dl
INNER JOIN Hospital.Doctors d ON dl.DoctorId = d.Id
INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
INNER JOIN Metadata.Languages l ON dl.LanguageId = l.Id
GROUP BY d.Id, d.FirstName, d.LastName, h.Name
HAVING COUNT(*) > 2
ORDER BY LanguageCount DESC, d.FirstName;

GO
