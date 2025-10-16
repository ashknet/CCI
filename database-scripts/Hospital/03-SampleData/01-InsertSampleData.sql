-- =============================================
-- Hospital Service - Sample Data
-- =============================================

USE HospitalDb;
GO

-- =============================================
-- 1. Insert Specialties
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Specialties)
BEGIN
    INSERT INTO Specialties (Id, Name, Description) VALUES
        (NEWID(), 'Cardiology', 'Heart and cardiovascular system'),
        (NEWID(), 'Orthopedics', 'Bones, joints, and muscles'),
        (NEWID(), 'Neurology', 'Brain and nervous system'),
        (NEWID(), 'Oncology', 'Cancer treatment and care'),
        (NEWID(), 'Gastroenterology', 'Digestive system'),
        (NEWID(), 'Endocrinology', 'Hormones and metabolism'),
        (NEWID(), 'Nephrology', 'Kidney diseases'),
        (NEWID(), 'Pulmonology', 'Respiratory system'),
        (NEWID(), 'Dermatology', 'Skin conditions'),
        (NEWID(), 'Ophthalmology', 'Eye care');
    
    PRINT '✅ Specialties inserted';
END
GO

-- =============================================
-- 2. Insert Languages
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Languages)
BEGIN
    INSERT INTO Languages (Name, Code) VALUES
        ('English', 'en'),
        ('Hindi', 'hi'),
        ('Telugu', 'te'),
        ('Tamil', 'ta'),
        ('Kannada', 'kn'),
        ('Malayalam', 'ml'),
        ('Bengali', 'bn'),
        ('Marathi', 'mr');
    
    PRINT '✅ Languages inserted';
END
GO

-- =============================================
-- 3. Insert Sample Hospitals
-- =============================================
DECLARE @ApolloHydId UNIQUEIDENTIFIER = NEWID();
DECLARE @CareHydId UNIQUEIDENTIFIER = NEWID();
DECLARE @ApolloBlrId UNIQUEIDENTIFIER = NEWID();

IF NOT EXISTS (SELECT 1 FROM Hospitals)
BEGIN
    INSERT INTO Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, Phone, Email, Website, BedCapacity, YearEstablished, AverageRating, TotalReviews)
    VALUES
        (@ApolloHydId, 
         'Apollo Hospitals Hyderabad', 
         'Multi-specialty tertiary care hospital with state-of-the-art facilities',
         'Jubilee Hills, Road No. 72',
         'Hyderabad',
         'Telangana',
         'India',
         '500033',
         17.4239,
         78.4501,
         '+91-40-23607777',
         'info@apollohyd.com',
         'https://www.apollohospitals.com',
         750,
         1988,
         4.7,
         1250),
        
        (@CareHydId,
         'Care Hospitals Hyderabad',
         'Leading multi-specialty hospital in Telangana',
         'Road No. 1, Banjara Hills',
         'Hyderabad',
         'Telangana',
         'India',
         '500034',
         17.4126,
         78.4451,
         '+91-40-67141111',
         'info@carehospitals.com',
         'https://www.carehospitals.com',
         600,
         1997,
         4.6,
         980),
        
        (@ApolloBlrId,
         'Apollo Hospitals Bangalore',
         'Advanced medical and surgical care with international standards',
         'Bannerghatta Road',
         'Bangalore',
         'Karnataka',
         'India',
         '560076',
         12.8996,
         77.6025,
         '+91-80-26304050',
         'info@apollobanglore.com',
         'https://www.apollohospitals.com/bangalore',
         800,
         1985,
         4.8,
         1450);
    
    PRINT '✅ Hospitals inserted';
END
GO

-- =============================================
-- 4. Insert Sample Doctors
-- =============================================
DECLARE @Doctor1Id UNIQUEIDENTIFIER = NEWID();
DECLARE @Doctor2Id UNIQUEIDENTIFIER = NEWID();
DECLARE @Doctor3Id UNIQUEIDENTIFIER = NEWID();
DECLARE @ApolloHydId UNIQUEIDENTIFIER;
DECLARE @CardioId UNIQUEIDENTIFIER;
DECLARE @OrthoId UNIQUEIDENTIFIER;

SELECT @ApolloHydId = Id FROM Hospitals WHERE Name = 'Apollo Hospitals Hyderabad';
SELECT @CardioId = Id FROM Specialties WHERE Name = 'Cardiology';
SELECT @OrthoId = Id FROM Specialties WHERE Name = 'Orthopedics';

IF NOT EXISTS (SELECT 1 FROM Doctors) AND @ApolloHydId IS NOT NULL
BEGIN
    INSERT INTO Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews)
    VALUES
        (@Doctor1Id,
         @ApolloHydId,
         'Rajesh',
         'Kumar',
         'dr.rajesh@apollohyd.com',
         '+91-9876543210',
         'MD, DM (Cardiology), FESC',
         18,
         'Senior Interventional Cardiologist with expertise in complex coronary interventions',
         2000.00,
         4.8,
         156),
        
        (@Doctor2Id,
         @ApolloHydId,
         'Priya',
         'Reddy',
         'dr.priya@apollohyd.com',
         '+91-9876543211',
         'MS (Ortho), DNB, MRCS',
         12,
         'Specialist in joint replacement and sports medicine',
         1800.00,
         4.7,
         98),
        
        (@Doctor3Id,
         @ApolloHydId,
         'Anil',
         'Sharma',
         'dr.anil@apollohyd.com',
         '+91-9876543212',
         'MD, DM (Neurology)',
         15,
         'Neurologist specializing in stroke and movement disorders',
         2200.00,
         4.9,
         203);
    
    PRINT '✅ Doctors inserted';
END
GO

-- =============================================
-- 5. Insert Doctor Specialties
-- =============================================
IF NOT EXISTS (SELECT 1 FROM DoctorSpecialties)
BEGIN
    INSERT INTO DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    SELECT 
        d.Id,
        s.Id,
        1,
        d.YearsOfExperience
    FROM Doctors d
    CROSS JOIN Specialties s
    WHERE 
        (d.FirstName = 'Rajesh' AND s.Name = 'Cardiology')
        OR (d.FirstName = 'Priya' AND s.Name = 'Orthopedics')
        OR (d.FirstName = 'Anil' AND s.Name = 'Neurology');
    
    PRINT '✅ Doctor specialties assigned';
END
GO

-- =============================================
-- 6. Insert Doctor Languages
-- =============================================
IF NOT EXISTS (SELECT 1 FROM DoctorLanguages)
BEGIN
    -- All doctors speak English, Hindi, and Telugu
    INSERT INTO DoctorLanguages (DoctorId, LanguageId, ProficiencyLevel)
    SELECT 
        d.Id,
        l.Id,
        'Fluent'
    FROM Doctors d
    CROSS JOIN Languages l
    WHERE l.Code IN ('en', 'hi', 'te');
    
    PRINT '✅ Doctor languages assigned';
END
GO

-- =============================================
-- 7. Insert Doctor Availability
-- =============================================
IF NOT EXISTS (SELECT 1 FROM DoctorAvailability)
BEGIN
    -- Create availability for all doctors (Mon-Sat, 9 AM - 5 PM)
    INSERT INTO DoctorAvailability (DoctorId, DayOfWeek, StartTime, EndTime, SlotDurationMinutes)
    SELECT 
        Id AS DoctorId,
        DayOfWeek,
        '09:00:00' AS StartTime,
        '17:00:00' AS EndTime,
        30 AS SlotDurationMinutes
    FROM Doctors
    CROSS JOIN (VALUES (1), (2), (3), (4), (5), (6)) AS Days(DayOfWeek); -- Mon-Sat
    
    PRINT '✅ Doctor availability created';
END
GO

-- =============================================
-- 8. Insert Sample Accreditations
-- =============================================
IF NOT EXISTS (SELECT 1 FROM HospitalAccreditations)
BEGIN
    INSERT INTO HospitalAccreditations (HospitalId, AccreditationBody, AccreditationType, CertificateNumber, IssuedDate, ExpiryDate, Status)
    SELECT 
        Id,
        'NABH',
        'Hospital Accreditation',
        'NABH-' + LEFT(CAST(NEWID() AS NVARCHAR(36)), 8),
        DATEADD(YEAR, -2, GETDATE()),
        DATEADD(YEAR, 1, GETDATE()),
        'active'
    FROM Hospitals;
    
    PRINT '✅ Hospital accreditations inserted';
END
GO

-- =============================================
-- 9. Insert Diseases
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Diseases)
BEGIN
    INSERT INTO Diseases (Name, Category, Description, ICD10Code, AverageTreatmentCost) VALUES
        ('Coronary Artery Disease', 'Cardiovascular', 'Narrowing of coronary arteries', 'I25.1', 500000),
        ('Type 2 Diabetes', 'Endocrine', 'Chronic condition affecting blood sugar', 'E11', 50000),
        ('Osteoarthritis', 'Musculoskeletal', 'Degenerative joint disease', 'M15', 300000),
        ('Stroke', 'Neurological', 'Disruption of blood supply to brain', 'I64', 400000),
        ('Lung Cancer', 'Oncology', 'Malignant tumor in the lungs', 'C34', 800000);
    
    PRINT '✅ Diseases inserted';
END
GO

PRINT 'Hospital Service sample data inserted successfully';
GO
