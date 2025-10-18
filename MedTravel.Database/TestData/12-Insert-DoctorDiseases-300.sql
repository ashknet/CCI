-- =============================================
-- Insert Doctor-Disease Relationships
-- =============================================

PRINT 'Inserting Doctor-Disease Relationships...';

-- Declare variables for dynamic insertion
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @DiseaseId UNIQUEIDENTIFIER;
DECLARE @Counter INT = 1;
DECLARE @MaxRelationships INT = 300;
DECLARE @RandomDoctor INT;
DECLARE @RandomDisease INT;
DECLARE @TotalDoctors INT;
DECLARE @TotalDiseases INT;

-- Get total counts
SELECT @TotalDoctors = COUNT(*) FROM Hospital.Doctors WHERE IsActive = 1;
SELECT @TotalDiseases = COUNT(*) FROM Metadata.Diseases;

PRINT 'Total Doctors: ' + CAST(@TotalDoctors AS NVARCHAR(10));
PRINT 'Total Diseases: ' + CAST(@TotalDiseases AS NVARCHAR(10));

-- Create temporary tables for efficient random selection
DECLARE @Doctors TABLE (RowNum INT IDENTITY(1,1), Id UNIQUEIDENTIFIER);
DECLARE @Diseases TABLE (RowNum INT IDENTITY(1,1), Id UNIQUEIDENTIFIER);

INSERT INTO @Doctors (Id)
SELECT Id FROM Hospital.Doctors WHERE IsActive = 1 ORDER BY Id;

INSERT INTO @Diseases (Id)
SELECT Id FROM Metadata.Diseases ORDER BY Id;

-- Insert specific doctor-disease relationships based on medical specialties
-- This ensures realistic relationships between doctors and diseases they would treat

-- Cardiology doctors treating cardiovascular diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' treatment and management',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Cardiology' 
  AND dis.Name IN ('Hypertension', 'Coronary Artery Disease', 'Heart Failure', 'Atrial Fibrillation')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Neurology doctors treating neurological diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' diagnosis and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Neurology' 
  AND dis.Name IN ('Migraine', 'Epilepsy', 'Parkinson Disease', 'Alzheimer Disease', 'Multiple Sclerosis')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Endocrinology doctors treating endocrine diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' management and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Endocrinology' 
  AND dis.Name IN ('Type 2 Diabetes', 'Type 1 Diabetes', 'Hypothyroidism', 'Hyperthyroidism', 'Obesity')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Pulmonology doctors treating respiratory diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' care and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Pulmonology' 
  AND dis.Name IN ('Asthma', 'COPD', 'Pneumonia', 'Sleep Apnea')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Gastroenterology doctors treating GI diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' diagnosis and management',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Gastroenterology' 
  AND dis.Name IN ('Gastroesophageal Reflux Disease', 'Irritable Bowel Syndrome', 'Crohn Disease', 'Ulcerative Colitis', 'Cirrhosis')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Orthopedics doctors treating musculoskeletal diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' treatment and surgery',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Orthopedics' 
  AND dis.Name IN ('Osteoarthritis', 'Rheumatoid Arthritis', 'Osteoporosis')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Psychiatry doctors treating mental health diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' therapy and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Psychiatry' 
  AND dis.Name IN ('Major Depressive Disorder', 'Generalized Anxiety Disorder', 'Bipolar Disorder', 'Attention Deficit Hyperactivity Disorder', 'Autism Spectrum Disorder')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Oncology doctors treating cancer diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' treatment and care',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Oncology' 
  AND dis.Name IN ('Breast Cancer', 'Lung Cancer', 'Prostate Cancer', 'Colorectal Cancer')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Nephrology doctors treating kidney diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' management and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Nephrology' 
  AND dis.Name IN ('Chronic Kidney Disease', 'Kidney Stones')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Dermatology doctors treating skin diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' treatment and care',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Dermatology' 
  AND dis.Name IN ('Psoriasis', 'Eczema', 'Acne')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Ophthalmology doctors treating eye diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' surgery and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Ophthalmology' 
  AND dis.Name IN ('Cataracts', 'Glaucoma', 'Macular Degeneration')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Urology doctors treating urological diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in ' + dis.Name + ' treatment and surgery',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Urology' 
  AND dis.Name IN ('Benign Prostatic Hyperplasia', 'Urinary Tract Infection', 'Prostate Cancer')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Gynecology doctors treating gynecological diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Expert in ' + dis.Name + ' diagnosis and treatment',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Gynecology' 
  AND dis.Name IN ('Endometriosis', 'Polycystic Ovary Syndrome', 'Breast Cancer')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Pediatrics doctors treating pediatric diseases
INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
SELECT 
    NEWID(),
    d.Id,
    dis.Id,
    1, -- Primary specialty
    ABS(CHECKSUM(NEWID())) % 15 + 5, -- 5-20 years experience
    'Specializes in pediatric ' + dis.Name + ' care',
    GETUTCDATE()
FROM Hospital.Doctors d
INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
CROSS JOIN Metadata.Diseases dis
WHERE s.Name = 'Pediatrics' 
  AND dis.Name IN ('Attention Deficit Hyperactivity Disorder', 'Autism Spectrum Disorder', 'Asthma', 'Type 1 Diabetes')
  AND NOT EXISTS (
    SELECT 1 FROM Hospital.DoctorDiseases dd 
    WHERE dd.DoctorId = d.Id AND dd.DiseaseId = dis.Id
  );

-- Add some secondary disease relationships (doctors treating diseases outside their primary specialty)
-- This creates more realistic scenarios where doctors might treat multiple conditions

-- Add random secondary relationships
WHILE @Counter <= 50 -- Add 50 secondary relationships
BEGIN
    SET @RandomDoctor = (ABS(CHECKSUM(NEWID())) % @TotalDoctors) + 1;
    SET @RandomDisease = (ABS(CHECKSUM(NEWID())) % @TotalDiseases) + 1;
    
    SELECT @DoctorId = Id FROM @Doctors WHERE RowNum = @RandomDoctor;
    SELECT @DiseaseId = Id FROM @Diseases WHERE RowNum = @RandomDisease;
    
    -- Insert if relationship doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM Hospital.DoctorDiseases 
        WHERE DoctorId = @DoctorId AND DiseaseId = @DiseaseId
    )
    BEGIN
        INSERT INTO Hospital.DoctorDiseases (Id, DoctorId, DiseaseId, IsPrimary, YearsOfExperience, TreatmentNotes, CreatedAt)
        VALUES (
            NEWID(),
            @DoctorId,
            @DiseaseId,
            0, -- Secondary specialty
            ABS(CHECKSUM(NEWID())) % 10 + 2, -- 2-12 years experience
            'Has experience treating ' + (SELECT Name FROM Metadata.Diseases WHERE Id = @DiseaseId),
            GETUTCDATE()
        );
        
        SET @Counter = @Counter + 1;
    END;
END;

-- Display summary
DECLARE @TotalRelationships INT;
SELECT @TotalRelationships = COUNT(*) FROM Hospital.DoctorDiseases;

PRINT 'Successfully inserted ' + CAST(@TotalRelationships AS NVARCHAR(10)) + ' doctor-disease relationships!';
PRINT 'Primary relationships: ' + CAST((SELECT COUNT(*) FROM Hospital.DoctorDiseases WHERE IsPrimary = 1) AS NVARCHAR(10));
PRINT 'Secondary relationships: ' + CAST((SELECT COUNT(*) FROM Hospital.DoctorDiseases WHERE IsPrimary = 0) AS NVARCHAR(10));

-- Display sample relationships
PRINT '';
PRINT 'Sample Doctor-Disease Relationships:';
SELECT TOP 10
    d.FirstName + ' ' + d.LastName AS DoctorName,
    s.Name AS Specialty,
    dis.Name AS Disease,
    dd.IsPrimary,
    dd.YearsOfExperience,
    h.Name AS Hospital
FROM Hospital.DoctorDiseases dd
INNER JOIN Hospital.Doctors d ON dd.DoctorId = d.Id
INNER JOIN Metadata.Diseases dis ON dd.DiseaseId = dis.Id
INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId AND ds.IsPrimary = 1
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
ORDER BY dd.CreatedAt DESC;

GO
