-- =============================================
-- MedTravel Platform - Test/Sample Data
-- Inserts sample data into TestData schema
-- Then creates views to access it from service schemas
-- =============================================

USE MedTravelDb;
GO

PRINT ''
PRINT '======================================================================'
PRINT '  Inserting Test/Sample Data'
PRINT '======================================================================'
PRINT ''
GO

-- =============================================
-- STEP 1: Insert Metadata (Lookup Data)
-- =============================================

PRINT 'Inserting Metadata...'
GO

-- Countries
IF NOT EXISTS (SELECT 1 FROM Metadata.Countries)
BEGIN
    INSERT INTO Metadata.Countries (Code, Name, Region, IsActive) VALUES
    ('IND', 'India', 'Asia', 1),
    ('USA', 'United States', 'North America', 1),
    ('GBR', 'United Kingdom', 'Europe', 1),
    ('CAN', 'Canada', 'North America', 1),
    ('AUS', 'Australia', 'Oceania', 1);
    PRINT '✅ Countries inserted (5)';
END
GO

-- Cities
DECLARE @IndiaId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Countries WHERE Code = 'IND');
DECLARE @USAId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Countries WHERE Code = 'USA');
DECLARE @UKId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Countries WHERE Code = 'GBR');

IF NOT EXISTS (SELECT 1 FROM Metadata.Cities)
BEGIN
    INSERT INTO Metadata.Cities (CountryId, Name, State, Latitude, Longitude, IsActive) VALUES
    (@IndiaId, 'Hyderabad', 'Telangana', 17.3850, 78.4867, 1),
    (@IndiaId, 'Bangalore', 'Karnataka', 12.9716, 77.5946, 1),
    (@IndiaId, 'Mumbai', 'Maharashtra', 19.0760, 72.8777, 1),
    (@IndiaId, 'Delhi', 'Delhi', 28.7041, 77.1025, 1),
    (@IndiaId, 'Chennai', 'Tamil Nadu', 13.0827, 80.2707, 1),
    (@USAId, 'New York', 'New York', 40.7128, -74.0060, 1),
    (@USAId, 'Los Angeles', 'California', 34.0522, -118.2437, 1),
    (@UKId, 'London', 'England', 51.5074, -0.1278, 1);
    PRINT '✅ Cities inserted (8)';
END
GO

-- Languages
IF NOT EXISTS (SELECT 1 FROM Metadata.Languages)
BEGIN
    INSERT INTO Metadata.Languages (Code, Name, NativeName, IsActive) VALUES
    ('en', 'English', 'English', 1),
    ('hi', 'Hindi', 'हिन्दी', 1),
    ('te', 'Telugu', 'తెలుగు', 1),
    ('ta', 'Tamil', 'தமிழ்', 1),
    ('kn', 'Kannada', 'ಕನ್ನಡ', 1),
    ('ml', 'Malayalam', 'മലയാളം', 1),
    ('bn', 'Bengali', 'বাংলা', 1),
    ('mr', 'Marathi', 'मराठी', 1),
    ('es', 'Spanish', 'Español', 1),
    ('fr', 'French', 'Français', 1);
    PRINT '✅ Languages inserted (10)';
END
GO

-- Currencies
IF NOT EXISTS (SELECT 1 FROM Metadata.Currencies)
BEGIN
    INSERT INTO Metadata.Currencies (Code, Name, Symbol, IsActive) VALUES
    ('INR', 'Indian Rupee', '₹', 1),
    ('USD', 'US Dollar', '$', 1),
    ('GBP', 'British Pound', '£', 1),
    ('EUR', 'Euro', '€', 1),
    ('AUD', 'Australian Dollar', 'A$', 1);
    PRINT '✅ Currencies inserted (5)';
END
GO

-- Medical Specialties
IF NOT EXISTS (SELECT 1 FROM Metadata.Specialties)
BEGIN
    INSERT INTO Metadata.Specialties (Name, Description, Category, SortOrder) VALUES
    ('Cardiology', 'Heart and cardiovascular system', 'Medical', 1),
    ('Orthopedics', 'Bones, joints, and muscles', 'Surgical', 2),
    ('Neurology', 'Brain and nervous system', 'Medical', 3),
    ('Oncology', 'Cancer treatment and care', 'Medical', 4),
    ('Gastroenterology', 'Digestive system', 'Medical', 5),
    ('Endocrinology', 'Hormones and metabolism', 'Medical', 6),
    ('Nephrology', 'Kidney diseases', 'Medical', 7),
    ('Pulmonology', 'Respiratory system', 'Medical', 8),
    ('Dermatology', 'Skin conditions', 'Medical', 9),
    ('Ophthalmology', 'Eye care', 'Medical', 10),
    ('ENT', 'Ear, Nose, and Throat', 'Surgical', 11),
    ('Urology', 'Urinary system', 'Surgical', 12);
    PRINT '✅ Specialties inserted (12)';
END
GO

-- Diseases
DECLARE @CardiologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Cardiology');
DECLARE @OrthopedicsId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Orthopedics');
DECLARE @OncologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Oncology');

IF NOT EXISTS (SELECT 1 FROM Metadata.Diseases)
BEGIN
    INSERT INTO Metadata.Diseases (Name, Category, Description, ICD10Code, AverageTreatmentCost) VALUES
    ('Coronary Artery Disease', 'Cardiovascular', 'Narrowing of coronary arteries', 'I25.1', 500000),
    ('Type 2 Diabetes', 'Endocrine', 'Chronic condition affecting blood sugar', 'E11', 50000),
    ('Osteoarthritis', 'Musculoskeletal', 'Degenerative joint disease', 'M15', 300000),
    ('Stroke', 'Neurological', 'Disruption of blood supply to brain', 'I64', 400000),
    ('Lung Cancer', 'Oncology', 'Malignant tumor in the lungs', 'C34', 800000),
    ('Hypertension', 'Cardiovascular', 'High blood pressure', 'I10', 25000),
    ('Asthma', 'Respiratory', 'Chronic lung condition', 'J45', 30000);
    PRINT '✅ Diseases inserted (7)';
    
    -- Link diseases to specialties
    INSERT INTO Metadata.DiseaseSpecialties (DiseaseId, SpecialtyId)
    SELECT d.Id, @CardiologyId FROM Metadata.Diseases d WHERE d.Name IN ('Coronary Artery Disease', 'Hypertension')
    UNION ALL
    SELECT d.Id, @OrthopedicsId FROM Metadata.Diseases d WHERE d.Name = 'Osteoarthritis'
    UNION ALL
    SELECT d.Id, @OncologyId FROM Metadata.Diseases d WHERE d.Name = 'Lung Cancer';
END
GO

-- Accreditation Bodies
IF NOT EXISTS (SELECT 1 FROM Metadata.AccreditationBodies)
BEGIN
    INSERT INTO Metadata.AccreditationBodies (Name, Acronym, Description, Website, IsActive) VALUES
    ('National Accreditation Board for Hospitals', 'NABH', 'Indian hospital accreditation', 'https://www.nabh.co', 1),
    ('Joint Commission International', 'JCI', 'International healthcare accreditation', 'https://www.jointcommissioninternational.org', 1),
    ('ISO 9001', 'ISO', 'Quality management certification', 'https://www.iso.org', 1);
    PRINT '✅ Accreditation Bodies inserted (3)';
END
GO

-- Document Types
IF NOT EXISTS (SELECT 1 FROM Metadata.DocumentTypes)
BEGIN
    INSERT INTO Metadata.DocumentTypes (Name, Description, Category, IsRequired, MaxFileSizeMB) VALUES
    ('Passport', 'Valid passport for international travel', 'Identity', 1, 5),
    ('Visa', 'Medical visa for India', 'Travel', 1, 5),
    ('Medical Records', 'Previous medical history', 'Medical', 1, 10),
    ('Insurance Policy', 'Health insurance coverage', 'Insurance', 0, 5),
    ('Prescription', 'Doctor prescriptions', 'Medical', 0, 5),
    ('Lab Reports', 'Laboratory test results', 'Medical', 0, 10);
    PRINT '✅ Document Types inserted (6)';
END
GO

-- Airlines
IF NOT EXISTS (SELECT 1 FROM Metadata.Airlines)
BEGIN
    INSERT INTO Metadata.Airlines (Code, Name, Country, IsActive) VALUES
    ('AI', 'Air India', 'India', 1),
    ('6E', 'IndiGo', 'India', 1),
    ('SG', 'SpiceJet', 'India', 1),
    ('EK', 'Emirates', 'UAE', 1),
    ('QR', 'Qatar Airways', 'Qatar', 1),
    ('BA', 'British Airways', 'UK', 1);
    PRINT '✅ Airlines inserted (6)';
END
GO

-- Airports
DECLARE @HydCityId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Cities WHERE Name = 'Hyderabad');
DECLARE @BlrCityId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Cities WHERE Name = 'Bangalore');
DECLARE @BomCityId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Cities WHERE Name = 'Mumbai');

IF NOT EXISTS (SELECT 1 FROM Metadata.Airports)
BEGIN
    INSERT INTO Metadata.Airports (Code, Name, CityId, CountryId, Latitude, Longitude, IsActive) VALUES
    ('HYD', 'Rajiv Gandhi International Airport', @HydCityId, @IndiaId, 17.2403, 78.4294, 1),
    ('BLR', 'Kempegowda International Airport', @BlrCityId, @IndiaId, 13.1979, 77.7063, 1),
    ('BOM', 'Chhatrapati Shivaji Maharaj International Airport', @BomCityId, @IndiaId, 19.0887, 72.8679, 1),
    ('DEL', 'Indira Gandhi International Airport', (SELECT Id FROM Metadata.Cities WHERE Name = 'Delhi'), @IndiaId, 28.5562, 77.1000, 1),
    ('JFK', 'John F. Kennedy International Airport', (SELECT Id FROM Metadata.Cities WHERE Name = 'New York'), @USAId, 40.6413, -73.7781, 1),
    ('LHR', 'London Heathrow Airport', (SELECT Id FROM Metadata.Cities WHERE Name = 'London'), @UKId, 51.4700, -0.4543, 1);
    PRINT '✅ Airports inserted (6)';
END
GO

-- =============================================
-- STEP 2: Insert UserManagement Test Data
-- =============================================

PRINT ''
PRINT 'Inserting UserManagement test data...'
GO

-- Roles
IF NOT EXISTS (SELECT 1 FROM UserManagement.Roles)
BEGIN
    INSERT INTO UserManagement.Roles (Name, Description) VALUES
    ('patient', 'Patient user role'),
    ('doctor', 'Doctor user role'),
    ('hospital_admin', 'Hospital administrator role'),
    ('support', 'Support team role');
    PRINT '✅ Roles inserted (4)';
END
GO

-- Permissions
IF NOT EXISTS (SELECT 1 FROM UserManagement.Permissions)
BEGIN
    INSERT INTO UserManagement.Permissions (Name, Resource, Action, Description) VALUES
    ('View User', 'users', 'read', 'Can view user information'),
    ('Edit User', 'users', 'update', 'Can update user information'),
    ('Delete User', 'users', 'delete', 'Can delete users'),
    ('View Appointments', 'appointments', 'read', 'Can view appointments'),
    ('Book Appointment', 'appointments', 'create', 'Can book appointments'),
    ('Cancel Appointment', 'appointments', 'delete', 'Can cancel appointments'),
    ('Manage Roles', 'roles', 'manage', 'Can manage roles and permissions');
    PRINT '✅ Permissions inserted (7)';
END
GO

-- Users
DECLARE @PatientRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'patient');
DECLARE @DoctorRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'doctor');
DECLARE @AdminRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'support');
DECLARE @NYCityId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Cities WHERE Name = 'New York');

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users)
BEGIN
    DECLARE @PatientUserId UNIQUEIDENTIFIER = NEWID();
    DECLARE @DoctorUserId UNIQUEIDENTIFIER = NEWID();
    DECLARE @AdminUserId UNIQUEIDENTIFIER = NEWID();
    
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, CountryId, CityId, EmailVerified) VALUES
    (@PatientUserId, 'patient@medtravel.com', '$2a$11$XYZ...', 'John', 'Doe', '+1-555-0100', @USAId, @NYCityId, 1),
    (@DoctorUserId, 'doctor@medtravel.com', '$2a$11$XYZ...', 'Dr. Rajesh', 'Kumar', '+91-9876543210', @IndiaId, @HydCityId, 1),
    (@AdminUserId, 'admin@medtravel.com', '$2a$11$XYZ...', 'Admin', 'User', '+91-1234567890', @IndiaId, @BlrCityId, 1);
    
    -- Assign roles
    INSERT INTO UserManagement.UserRoles (UserId, RoleId) VALUES
    (@PatientUserId, @PatientRoleId),
    (@DoctorUserId, @DoctorRoleId),
    (@AdminUserId, @AdminRoleId);
    
    PRINT '✅ Users inserted (3) with roles';
END
GO

-- =============================================
-- STEP 3: Insert Hospital Test Data
-- =============================================

PRINT ''
PRINT 'Inserting Hospital test data...'
GO

-- Hospitals
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals)
BEGIN
    DECLARE @HospitalId1 UNIQUEIDENTIFIER = NEWID();
    DECLARE @HospitalId2 UNIQUEIDENTIFIER = NEWID();
    DECLARE @HospitalId3 UNIQUEIDENTIFIER = NEWID();
    
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, Email, BedCapacity, YearEstablished, AverageRating, TotalReviews) VALUES
    (@HospitalId1, 'Apollo Hospitals Hyderabad', 'Multi-specialty tertiary care hospital', 'Jubilee Hills, Road No. 72', @HydCityId, @IndiaId, '500033', 17.4239, 78.4501, '+91-40-23607777', 'info@apollohyd.com', 750, 1988, 4.7, 1250),
    (@HospitalId2, 'Care Hospitals Hyderabad', 'Leading multi-specialty hospital', 'Road No. 1, Banjara Hills', @HydCityId, @IndiaId, '500034', 17.4126, 78.4451, '+91-40-67141111', 'info@carehospitals.com', 600, 1997, 4.6, 980),
    (@HospitalId3, 'Manipal Hospital Bangalore', 'Advanced medical and surgical care', 'Old Airport Road', @BlrCityId, @IndiaId, '560017', 12.9577, 77.6410, '+91-80-25024444', 'info@manipalhospital.com', 800, 1991, 4.8, 1450);
    
    -- Doctors
    DECLARE @Doctor1Id UNIQUEIDENTIFIER = NEWID();
    DECLARE @Doctor2Id UNIQUEIDENTIFIER = NEWID();
    
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, ConsultationFee, AverageRating, TotalReviews) VALUES
    (@Doctor1Id, @HospitalId1, 'Rajesh', 'Kumar', 'dr.rajesh@apollohyd.com', '+91-9876543210', 'MD, DM (Cardiology), FESC', 18, 2000.00, 4.8, 156),
    (@Doctor2Id, @HospitalId1, 'Priya', 'Reddy', 'dr.priya@apollohyd.com', '+91-9876543211', 'MS (Ortho), DNB, MRCS', 12, 1800.00, 4.7, 98);
    
    -- Link doctors to specialties
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    SELECT @Doctor1Id, Id, 1, 18 FROM Metadata.Specialties WHERE Name = 'Cardiology'
    UNION ALL
    SELECT @Doctor2Id, Id, 1, 12 FROM Metadata.Specialties WHERE Name = 'Orthopedics';
    
    -- Link doctors to languages (English and Hindi)
    DECLARE @EnglishId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Languages WHERE Code = 'en');
    DECLARE @HindiId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Languages WHERE Code = 'hi');
    
    INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, ProficiencyLevel) VALUES
    (@Doctor1Id, @EnglishId, 'Fluent'),
    (@Doctor1Id, @HindiId, 'Fluent'),
    (@Doctor2Id, @EnglishId, 'Fluent'),
    (@Doctor2Id, @HindiId, 'Fluent');
    
    PRINT '✅ Hospitals (3), Doctors (2) with specialties and languages inserted';
END
GO

-- =============================================
-- STEP 4: Insert TAService Test Data
-- =============================================

PRINT ''
PRINT 'Inserting TAService test data...'
GO

-- Hotels
IF NOT EXISTS (SELECT 1 FROM TAService.Hotels)
BEGIN
    DECLARE @HotelId1 UNIQUEIDENTIFIER = NEWID();
    DECLARE @INRId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Currencies WHERE Code = 'INR');
    
    INSERT INTO TAService.Hotels (Id, Name, Description, Address, CityId, CountryId, PostalCode, Latitude, Longitude, Phone, StarRating, AverageRating, TotalReviews, DistanceToHospitalKm) VALUES
    (@HotelId1, 'Taj Krishna Hyderabad', 'Luxury hotel near Apollo Hospitals', 'Road No. 1, Banjara Hills', @HydCityId, @IndiaId, '500034', 17.4239, 78.4501, '+91-40-66662323', 5, 4.7, 850, 3.5);
    
    -- Hotel Rooms
    INSERT INTO TAService.HotelRooms (HotelId, RoomType, Description, PricePerNight, CurrencyId, MaxOccupancy, TotalRooms, AvailableRooms) VALUES
    (@HotelId1, 'Deluxe Room', 'Spacious room with modern amenities', 8500, @INRId, 2, 50, 45),
    (@HotelId1, 'Executive Suite', 'Luxurious suite with separate living area', 15000, @INRId, 3, 20, 15);
    
    PRINT '✅ Hotels (1) with rooms (2) inserted';
END
GO

-- Flights
DECLARE @AirIndiaId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Airlines WHERE Code = 'AI');
DECLARE @HydAirportId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Airports WHERE Code = 'HYD');
DECLARE @JFKAirportId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Airports WHERE Code = 'JFK');
DECLARE @USDId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Currencies WHERE Code = 'USD');

IF NOT EXISTS (SELECT 1 FROM TAService.Flights) AND @AirIndiaId IS NOT NULL
BEGIN
    INSERT INTO TAService.Flights (FlightNumber, AirlineId, DepartureAirportId, ArrivalAirportId, DepartureTime, ArrivalTime, DurationMinutes, Price, CurrencyId, AvailableSeats, FlightClass, IsDirect) VALUES
    ('AI101', @AirIndiaId, @JFKAirportId, @HydAirportId, DATEADD(DAY, 10, GETDATE()), DATEADD(DAY, 10, DATEADD(HOUR, 16, GETDATE())), 960, 85000, (SELECT Id FROM Metadata.Currencies WHERE Code = 'INR'), 50, 'Economy', 1);
    
    PRINT '✅ Flights (1) inserted';
END
GO

PRINT ''
PRINT '======================================================================'
PRINT '  ✅ TEST DATA INSERT COMPLETE!'
PRINT '======================================================================'
PRINT ''
GO

-- Show summary
SELECT 'Metadata.Countries' AS TableName, COUNT(*) AS RecordCount FROM Metadata.Countries
UNION ALL
SELECT 'Metadata.Cities', COUNT(*) FROM Metadata.Cities
UNION ALL
SELECT 'Metadata.Languages', COUNT(*) FROM Metadata.Languages
UNION ALL
SELECT 'Metadata.Currencies', COUNT(*) FROM Metadata.Currencies
UNION ALL
SELECT 'Metadata.Specialties', COUNT(*) FROM Metadata.Specialties
UNION ALL
SELECT 'Metadata.Diseases', COUNT(*) FROM Metadata.Diseases
UNION ALL
SELECT 'UserManagement.Users', COUNT(*) FROM UserManagement.Users
UNION ALL
SELECT 'UserManagement.Roles', COUNT(*) FROM UserManagement.Roles
UNION ALL
SELECT 'Hospital.Hospitals', COUNT(*) FROM Hospital.Hospitals
UNION ALL
SELECT 'Hospital.Doctors', COUNT(*) FROM Hospital.Doctors
UNION ALL
SELECT 'TAService.Hotels', COUNT(*) FROM TAService.Hotels
UNION ALL
SELECT 'TAService.Flights', COUNT(*) FROM TAService.Flights
ORDER BY TableName;
GO

PRINT ''
PRINT 'Sample test data ready for development and testing!'
PRINT ''
GO
