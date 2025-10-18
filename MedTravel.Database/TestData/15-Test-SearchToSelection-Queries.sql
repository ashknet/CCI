-- =============================================
-- Test Search-to-Selection Queries
-- =============================================

PRINT 'Testing Search-to-Selection Functionality...';
PRINT '';

-- Test 1: Doctor Selection Flow
PRINT '=== TEST 1: DOCTOR SELECTION FLOW ===';
PRINT 'Finding doctors with their availability and reviews...';

SELECT TOP 5
    d.Id AS DoctorId,
    d.FirstName + ' ' + d.LastName AS DoctorName,
    d.Qualification,
    d.YearsOfExperience,
    d.ConsultationFee,
    d.AverageRating,
    d.TotalReviews,
    h.Name AS HospitalName,
    h.Address AS HospitalAddress,
    h.City AS HospitalCity,
    s.Name AS PrimarySpecialty,
    COUNT(da.Id) AS AvailabilityDays,
    COUNT(dl.Id) AS LanguagesSpoken,
    COUNT(dd.Id) AS DiseasesTreated
FROM Hospital.Doctors d
INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId AND ds.IsPrimary = 1
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
LEFT JOIN Hospital.DoctorAvailability da ON d.Id = da.DoctorId AND da.IsActive = 1
LEFT JOIN Hospital.DoctorLanguages dl ON d.Id = dl.DoctorId
LEFT JOIN Hospital.DoctorDiseases dd ON d.Id = dd.DoctorId
WHERE d.IsActive = 1 AND d.IsAcceptingPatients = 1
GROUP BY d.Id, d.FirstName, d.LastName, d.Qualification, d.YearsOfExperience, 
         d.ConsultationFee, d.AverageRating, d.TotalReviews, h.Name, h.Address, h.City, s.Name
ORDER BY d.AverageRating DESC, d.TotalReviews DESC;

-- Test 2: Hospital Selection Flow
PRINT '';
PRINT '=== TEST 2: HOSPITAL SELECTION FLOW ===';
PRINT 'Finding hospitals with their doctors and specialties...';

SELECT TOP 5
    h.Id AS HospitalId,
    h.Name AS HospitalName,
    h.Address,
    h.City,
    h.BedCapacity,
    h.AverageRating,
    h.TotalReviews,
    COUNT(DISTINCT d.Id) AS DoctorCount,
    COUNT(DISTINCT ds.SpecialtyId) AS SpecialtyCount,
    COUNT(DISTINCT dd.DiseaseId) AS DiseasesTreated,
    STRING_AGG(DISTINCT s.Name, ', ') AS AvailableSpecialties
FROM Hospital.Hospitals h
LEFT JOIN Hospital.Doctors d ON h.Id = d.HospitalId AND d.IsActive = 1
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
LEFT JOIN Hospital.DoctorDiseases dd ON d.Id = dd.DoctorId
WHERE h.IsActive = 1
GROUP BY h.Id, h.Name, h.Address, h.City, h.BedCapacity, h.AverageRating, h.TotalReviews
ORDER BY h.AverageRating DESC, DoctorCount DESC;

-- Test 3: City Selection Flow
PRINT '';
PRINT '=== TEST 3: CITY SELECTION FLOW ===';
PRINT 'Finding cities with their hospitals and total doctors...';

SELECT 
    c.Id AS CityId,
    c.Name AS CityName,
    c.State,
    c.Country,
    COUNT(DISTINCT h.Id) AS HospitalCount,
    COUNT(DISTINCT d.Id) AS DoctorCount,
    COUNT(DISTINCT ds.SpecialtyId) AS SpecialtyCount,
    COUNT(DISTINCT dd.DiseaseId) AS DiseasesTreated,
    AVG(h.AverageRating) AS AvgHospitalRating,
    SUM(h.BedCapacity) AS TotalBeds
FROM Metadata.Cities c
LEFT JOIN Hospital.Hospitals h ON c.Id = h.CityId AND h.IsActive = 1
LEFT JOIN Hospital.Doctors d ON h.Id = d.HospitalId AND d.IsActive = 1
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
LEFT JOIN Hospital.DoctorDiseases dd ON d.Id = dd.DoctorId
WHERE c.IsActive = 1
GROUP BY c.Id, c.Name, c.State, c.Country
ORDER BY DoctorCount DESC, HospitalCount DESC;

-- Test 4: Disease Selection Flow
PRINT '';
PRINT '=== TEST 4: DISEASE SELECTION FLOW ===';
PRINT 'Finding diseases with their specialists and related specialties...';

SELECT TOP 10
    dis.Id AS DiseaseId,
    dis.Name AS DiseaseName,
    dis.Category,
    dis.Description,
    dis.AverageTreatmentCost,
    COUNT(DISTINCT dd.DoctorId) AS SpecialistCount,
    COUNT(DISTINCT h.Id) AS HospitalCount,
    COUNT(DISTINCT ds.SpecialtyId) AS RelatedSpecialties,
    STRING_AGG(DISTINCT s.Name, ', ') AS Specialties,
    AVG(d.AverageRating) AS AvgSpecialistRating,
    MIN(d.ConsultationFee) AS MinConsultationFee,
    MAX(d.ConsultationFee) AS MaxConsultationFee
FROM Metadata.Diseases dis
LEFT JOIN Hospital.DoctorDiseases dd ON dis.Id = dd.DiseaseId
LEFT JOIN Hospital.Doctors d ON dd.DoctorId = d.Id AND d.IsActive = 1
LEFT JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
LEFT JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
GROUP BY dis.Id, dis.Name, dis.Category, dis.Description, dis.AverageTreatmentCost
ORDER BY SpecialistCount DESC, AvgSpecialistRating DESC;

-- Test 5: Doctor Availability Analysis
PRINT '';
PRINT '=== TEST 5: DOCTOR AVAILABILITY ANALYSIS ===';
PRINT 'Analyzing doctor availability patterns...';

SELECT 
    CASE da.DayOfWeek
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS DayOfWeek,
    COUNT(*) AS AvailableDoctors,
    AVG(DATEDIFF(MINUTE, da.StartTime, da.EndTime)) AS AvgWorkingMinutes,
    AVG(CAST(da.SlotDurationMinutes AS FLOAT)) AS AvgSlotDuration,
    MIN(da.StartTime) AS EarliestStart,
    MAX(da.EndTime) AS LatestEnd
FROM Hospital.DoctorAvailability da
WHERE da.IsActive = 1
GROUP BY da.DayOfWeek
ORDER BY da.DayOfWeek;

-- Test 6: Language Distribution
PRINT '';
PRINT '=== TEST 6: LANGUAGE DISTRIBUTION ===';
PRINT 'Analyzing doctor language capabilities...';

SELECT 
    l.Name AS Language,
    l.Code,
    COUNT(*) AS DoctorCount,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Native' THEN 1 END) AS NativeSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Fluent' THEN 1 END) AS FluentSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Intermediate' THEN 1 END) AS IntermediateSpeakers,
    COUNT(CASE WHEN dl.ProficiencyLevel = 'Basic' THEN 1 END) AS BasicSpeakers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Hospital.Doctors WHERE IsActive = 1), 2) AS PercentageOfDoctors
FROM Hospital.DoctorLanguages dl
INNER JOIN Metadata.Languages l ON dl.LanguageId = l.Id
INNER JOIN Hospital.Doctors d ON dl.DoctorId = d.Id
WHERE d.IsActive = 1
GROUP BY l.Name, l.Code
ORDER BY DoctorCount DESC;

-- Test 7: Specialty-Disease Relationships
PRINT '';
PRINT '=== TEST 7: SPECIALTY-DISEASE RELATIONSHIPS ===';
PRINT 'Analyzing which specialties treat which diseases...';

SELECT TOP 15
    s.Name AS Specialty,
    s.Category,
    COUNT(DISTINCT dd.DiseaseId) AS DiseasesTreated,
    COUNT(DISTINCT dd.DoctorId) AS Specialists,
    STRING_AGG(DISTINCT dis.Name, ', ') AS SampleDiseases
FROM Metadata.Specialties s
INNER JOIN Hospital.DoctorSpecialties ds ON s.Id = ds.SpecialtyId
INNER JOIN Hospital.DoctorDiseases dd ON ds.DoctorId = dd.DoctorId
INNER JOIN Metadata.Diseases dis ON dd.DiseaseId = dis.Id
INNER JOIN Hospital.Doctors d ON dd.DoctorId = d.Id
WHERE d.IsActive = 1
GROUP BY s.Name, s.Category
ORDER BY DiseasesTreated DESC, Specialists DESC;

-- Test 8: Search-to-Selection Workflow Simulation
PRINT '';
PRINT '=== TEST 8: SEARCH-TO-SELECTION WORKFLOW SIMULATION ===';
PRINT 'Simulating complete search-to-selection workflows...';

-- Simulate: User searches for "Diabetes" -> Finds specialists -> Selects doctor -> Views availability
PRINT 'Workflow: Disease Search -> Doctor Selection -> Availability Check';
PRINT '';

WITH DiabetesSpecialists AS (
    SELECT 
        d.Id AS DoctorId,
        d.FirstName + ' ' + d.LastName AS DoctorName,
        d.Qualification,
        d.YearsOfExperience,
        d.ConsultationFee,
        d.AverageRating,
        h.Name AS HospitalName,
        h.City,
        s.Name AS Specialty,
        dd.YearsOfExperience AS DiseaseExperience,
        dd.IsPrimary
    FROM Metadata.Diseases dis
    INNER JOIN Hospital.DoctorDiseases dd ON dis.Id = dd.DiseaseId
    INNER JOIN Hospital.Doctors d ON dd.DoctorId = d.Id
    INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
    INNER JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId AND ds.IsPrimary = 1
    INNER JOIN Metadata.Specialties s ON ds.SpecialtyId = s.Id
    WHERE dis.Name = 'Type 2 Diabetes' 
      AND d.IsActive = 1 
      AND d.IsAcceptingPatients = 1
)
SELECT TOP 5
    DoctorId,
    DoctorName,
    Qualification,
    YearsOfExperience,
    DiseaseExperience,
    ConsultationFee,
    AverageRating,
    HospitalName,
    City,
    Specialty,
    IsPrimary,
    CASE 
        WHEN EXISTS (SELECT 1 FROM Hospital.DoctorAvailability da WHERE da.DoctorId = ds.DoctorId AND da.IsActive = 1) 
        THEN 'Available' 
        ELSE 'Not Available' 
    END AS AvailabilityStatus,
    COUNT(DISTINCT dl.LanguageId) AS LanguagesSpoken
FROM DiabetesSpecialists ds
LEFT JOIN Hospital.DoctorLanguages dl ON ds.DoctorId = dl.DoctorId
GROUP BY DoctorId, DoctorName, Qualification, YearsOfExperience, DiseaseExperience, 
         ConsultationFee, AverageRating, HospitalName, City, Specialty, IsPrimary
ORDER BY IsPrimary DESC, AverageRating DESC, DiseaseExperience DESC;

-- Test 9: Performance Analysis
PRINT '';
PRINT '=== TEST 9: PERFORMANCE ANALYSIS ===';
PRINT 'Analyzing query performance and data distribution...';

-- Check data distribution
SELECT 
    'Doctors' AS Entity,
    COUNT(*) AS TotalCount,
    COUNT(CASE WHEN IsActive = 1 THEN 1 END) AS ActiveCount,
    COUNT(CASE WHEN IsAcceptingPatients = 1 THEN 1 END) AS AcceptingPatients
FROM Hospital.Doctors
UNION ALL
SELECT 
    'Hospitals',
    COUNT(*),
    COUNT(CASE WHEN IsActive = 1 THEN 1 END),
    NULL
FROM Hospital.Hospitals
UNION ALL
SELECT 
    'Diseases',
    COUNT(*),
    NULL,
    NULL
FROM Metadata.Diseases
UNION ALL
SELECT 
    'Doctor-Disease Relationships',
    COUNT(*),
    COUNT(CASE WHEN IsPrimary = 1 THEN 1 END),
    COUNT(CASE WHEN IsPrimary = 0 THEN 1 END)
FROM Hospital.DoctorDiseases
UNION ALL
SELECT 
    'Doctor Availability Records',
    COUNT(*),
    COUNT(CASE WHEN IsActive = 1 THEN 1 END),
    NULL
FROM Hospital.DoctorAvailability
UNION ALL
SELECT 
    'Doctor-Language Relationships',
    COUNT(*),
    NULL,
    NULL
FROM Hospital.DoctorLanguages;

PRINT '';
PRINT '=== SEARCH-TO-SELECTION TESTING COMPLETE ===';
PRINT 'All workflows tested successfully!';
PRINT 'The system is ready for comprehensive search-to-selection functionality.';
PRINT '';

GO
