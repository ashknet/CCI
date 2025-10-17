-- =============================================
-- Comprehensive Test Data Insertion Script
-- Inserts realistic data into all transactional tables
-- Checks for existing data and foreign keys
-- =============================================

USE MedTravelDb;
GO

PRINT '========================================';
PRINT 'Starting Comprehensive Test Data Insertion';
PRINT '========================================';
PRINT '';

-- =============================================
-- PART 1: USER MANAGEMENT SERVICE DATA
-- =============================================
PRINT 'PART 1: Inserting User Management Data...';
PRINT '';

-- Get country, state, city IDs from metadata
DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Countries WHERE Name = 'India');
DECLARE @StateId_TG UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.States WHERE Name = 'Telangana' AND CountryId = @CountryId);
DECLARE @StateId_KA UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.States WHERE Name = 'Karnataka' AND CountryId = @CountryId);
DECLARE @CityId_HYD UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name = 'Hyderabad' AND StateId = @StateId_TG);
DECLARE @CityId_BLR UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name = 'Bangalore' AND StateId = @StateId_KA);

-- Get language IDs
DECLARE @LangId_EN UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Languages WHERE Code = 'en');
DECLARE @LangId_HI UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Languages WHERE Code = 'hi');
DECLARE @LangId_TE UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Languages WHERE Code = 'te');

-- Insert Roles (if not exists)
PRINT '  Checking roles...';
IF NOT EXISTS (SELECT 1 FROM UserManagement.Roles WHERE Name = 'patient')
BEGIN
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (NEWID(), 'patient', 'Patient role', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted patient role';
END

IF NOT EXISTS (SELECT 1 FROM UserManagement.Roles WHERE Name = 'doctor')
BEGIN
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (NEWID(), 'doctor', 'Doctor role', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted doctor role';
END

IF NOT EXISTS (SELECT 1 FROM UserManagement.Roles WHERE Name = 'hospital_admin')
BEGIN
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (NEWID(), 'hospital_admin', 'Hospital administrator role', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital_admin role';
END

-- Get role IDs
DECLARE @RoleId_Patient UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'patient');
DECLARE @RoleId_Doctor UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'doctor');
DECLARE @RoleId_Admin UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'hospital_admin');

-- Insert Test Users (Patients)
PRINT '  Inserting test users...';

-- User 1: Rajesh Kumar
DECLARE @UserId1 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'rajesh.kumar@example.com')
BEGIN
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, 
                                      Nationality, Country, City, Address, PostalCode, IsActive, EmailVerified, PhoneVerified, 
                                      TwoFactorEnabled, CreatedAt, UpdatedAt)
    VALUES (@UserId1, 'rajesh.kumar@example.com', '$2a$11$XYZ123456789', 'Rajesh', 'Kumar', '+91-9876543210', 
            '1985-05-15', 'Male', 'Indian', 'India', 'Hyderabad', '123 MG Road', '500001', 1, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
    VALUES (@UserId1, @RoleId_Patient, GETUTCDATE());
    
    INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, 
                                                SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId1, 'en', 'INR', 1, 1, 1, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted user: Rajesh Kumar';
END

-- User 2: Priya Sharma
DECLARE @UserId2 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'priya.sharma@example.com')
BEGIN
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, 
                                      Nationality, Country, City, Address, PostalCode, IsActive, EmailVerified, PhoneVerified, 
                                      TwoFactorEnabled, CreatedAt, UpdatedAt)
    VALUES (@UserId2, 'priya.sharma@example.com', '$2a$11$ABC123456789', 'Priya', 'Sharma', '+91-9876543211', 
            '1990-08-22', 'Female', 'Indian', 'India', 'Bangalore', '456 Brigade Road', '560001', 1, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
    VALUES (@UserId2, @RoleId_Patient, GETUTCDATE());
    
    INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, 
                                                SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId2, 'hi', 'INR', 1, 1, 0, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted user: Priya Sharma';
END

-- User 3: Mohammed Ali
DECLARE @UserId3 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'mohammed.ali@example.com')
BEGIN
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, 
                                      Nationality, Country, City, Address, PostalCode, IsActive, EmailVerified, PhoneVerified, 
                                      TwoFactorEnabled, CreatedAt, UpdatedAt)
    VALUES (@UserId3, 'mohammed.ali@example.com', '$2a$11$DEF123456789', 'Mohammed', 'Ali', '+91-9876543212', 
            '1988-03-10', 'Male', 'Indian', 'India', 'Hyderabad', '789 Abids Circle', '500002', 1, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
    VALUES (@UserId3, @RoleId_Patient, GETUTCDATE());
    
    INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, 
                                                SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId3, 'te', 'INR', 1, 1, 1, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted user: Mohammed Ali';
END

-- User 4: Anita Reddy
DECLARE @UserId4 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'anita.reddy@example.com')
BEGIN
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, 
                                      Nationality, Country, City, Address, PostalCode, IsActive, EmailVerified, PhoneVerified, 
                                      TwoFactorEnabled, CreatedAt, UpdatedAt)
    VALUES (@UserId4, 'anita.reddy@example.com', '$2a$11$GHI123456789', 'Anita', 'Reddy', '+91-9876543213', 
            '1992-11-05', 'Female', 'Indian', 'India', 'Hyderabad', '321 Banjara Hills', '500034', 1, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
    VALUES (@UserId4, @RoleId_Patient, GETUTCDATE());
    
    INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, 
                                                SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId4, 'en', 'INR', 1, 0, 1, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted user: Anita Reddy';
END

-- User 5: Vikram Singh
DECLARE @UserId5 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'vikram.singh@example.com')
BEGIN
    INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, 
                                      Nationality, Country, City, Address, PostalCode, IsActive, EmailVerified, PhoneVerified, 
                                      TwoFactorEnabled, CreatedAt, UpdatedAt)
    VALUES (@UserId5, 'vikram.singh@example.com', '$2a$11$JKL123456789', 'Vikram', 'Singh', '+91-9876543214', 
            '1987-07-18', 'Male', 'Indian', 'India', 'Bangalore', '654 Koramangala', '560095', 1, 1, 1, 0, 
            GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
    VALUES (@UserId5, @RoleId_Patient, GETUTCDATE());
    
    INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, 
                                                SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId5, 'hi', 'INR', 1, 1, 1, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted user: Vikram Singh';
END

PRINT '  ✓ User Management data insertion complete!';
PRINT '';

-- =============================================
-- PART 2: HOSPITAL SERVICE DATA
-- =============================================
PRINT 'PART 2: Inserting Hospital Service Data...';
PRINT '';

-- Get disease and specialty IDs from metadata
DECLARE @DiseaseId_Cardiac UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Diseases WHERE Name LIKE '%Cardiac%' OR Name LIKE '%Heart%');
DECLARE @DiseaseId_Diabetes UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Diseases WHERE Name LIKE '%Diabetes%');
DECLARE @DiseaseId_Cancer UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Diseases WHERE Name LIKE '%Cancer%');

-- Insert Specialties
PRINT '  Inserting specialties...';
DECLARE @SpecialtyId_Cardiology UNIQUEIDENTIFIER = NEWID();
DECLARE @SpecialtyId_Orthopedics UNIQUEIDENTIFIER = NEWID();
DECLARE @SpecialtyId_Neurology UNIQUEIDENTIFIER = NEWID();
DECLARE @SpecialtyId_Pediatrics UNIQUEIDENTIFIER = NEWID();
DECLARE @SpecialtyId_Oncology UNIQUEIDENTIFIER = NEWID();

IF NOT EXISTS (SELECT 1 FROM Hospital.Specialties WHERE Name = 'Cardiology')
BEGIN
    SET @SpecialtyId_Cardiology = NEWID();
    INSERT INTO Hospital.Specialties (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@SpecialtyId_Cardiology, 'Cardiology', 'Heart and cardiovascular system', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted specialty: Cardiology';
END
ELSE
    SET @SpecialtyId_Cardiology = (SELECT Id FROM Hospital.Specialties WHERE Name = 'Cardiology');

IF NOT EXISTS (SELECT 1 FROM Hospital.Specialties WHERE Name = 'Orthopedics')
BEGIN
    SET @SpecialtyId_Orthopedics = NEWID();
    INSERT INTO Hospital.Specialties (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@SpecialtyId_Orthopedics, 'Orthopedics', 'Bones, joints, and muscles', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted specialty: Orthopedics';
END
ELSE
    SET @SpecialtyId_Orthopedics = (SELECT Id FROM Hospital.Specialties WHERE Name = 'Orthopedics');

IF NOT EXISTS (SELECT 1 FROM Hospital.Specialties WHERE Name = 'Neurology')
BEGIN
    SET @SpecialtyId_Neurology = NEWID();
    INSERT INTO Hospital.Specialties (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@SpecialtyId_Neurology, 'Neurology', 'Brain and nervous system', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted specialty: Neurology';
END
ELSE
    SET @SpecialtyId_Neurology = (SELECT Id FROM Hospital.Specialties WHERE Name = 'Neurology');

IF NOT EXISTS (SELECT 1 FROM Hospital.Specialties WHERE Name = 'Pediatrics')
BEGIN
    SET @SpecialtyId_Pediatrics = NEWID();
    INSERT INTO Hospital.Specialties (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@SpecialtyId_Pediatrics, 'Pediatrics', 'Children healthcare', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted specialty: Pediatrics';
END
ELSE
    SET @SpecialtyId_Pediatrics = (SELECT Id FROM Hospital.Specialties WHERE Name = 'Pediatrics');

IF NOT EXISTS (SELECT 1 FROM Hospital.Specialties WHERE Name = 'Oncology')
BEGIN
    SET @SpecialtyId_Oncology = NEWID();
    INSERT INTO Hospital.Specialties (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@SpecialtyId_Oncology, 'Oncology', 'Cancer treatment and care', GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted specialty: Oncology';
END
ELSE
    SET @SpecialtyId_Oncology = (SELECT Id FROM Hospital.Specialties WHERE Name = 'Oncology');

-- Insert Hospitals
PRINT '  Inserting hospitals...';

-- Hospital 1: Apollo Hospital Hyderabad
DECLARE @HospitalId1 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Apollo Hospital Hyderabad')
BEGIN
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, 
                                    Phone, Email, Website, BedCapacity, EstablishedYear, AverageRating, TotalReviews, 
                                    IsActive, CreatedAt, UpdatedAt)
    VALUES (@HospitalId1, 'Apollo Hospital Hyderabad', 
            'One of the leading multi-specialty hospitals in India with advanced cardiac care and cancer treatment facilities.',
            'Jubilee Hills, Road No 72', 'Hyderabad', 'Telangana', 'India', '500033', 17.4346, 78.4066,
            '+91-40-2355-1066', 'info@apollohyd.com', 'https://www.apollohospitals.com', 750, 1988, 4.5, 1250,
            1, GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital: Apollo Hospital Hyderabad';
END
ELSE
    SET @HospitalId1 = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Apollo Hospital Hyderabad');

-- Hospital 2: Yashoda Hospitals
DECLARE @HospitalId2 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Yashoda Hospitals')
BEGIN
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, 
                                    Phone, Email, Website, BedCapacity, EstablishedYear, AverageRating, TotalReviews, 
                                    IsActive, CreatedAt, UpdatedAt)
    VALUES (@HospitalId2, 'Yashoda Hospitals', 
            'Multi-specialty hospital chain known for advanced healthcare services and patient care.',
            'Somajiguda, Raj Bhavan Road', 'Hyderabad', 'Telangana', 'India', '500082', 17.4239, 78.4738,
            '+91-40-2342-2222', 'contact@yashodahospitals.com', 'https://www.yashodahospitals.com', 600, 1989, 4.3, 890,
            1, GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital: Yashoda Hospitals';
END
ELSE
    SET @HospitalId2 = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Yashoda Hospitals');

-- Hospital 3: Fortis Hospital Bangalore
DECLARE @HospitalId3 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Fortis Hospital Bangalore')
BEGIN
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, 
                                    Phone, Email, Website, BedCapacity, EstablishedYear, AverageRating, TotalReviews, 
                                    IsActive, CreatedAt, UpdatedAt)
    VALUES (@HospitalId3, 'Fortis Hospital Bangalore', 
            'Leading healthcare provider with expertise in cardiac sciences, neurosciences, and orthopedics.',
            'Bannerghatta Road', 'Bangalore', 'Karnataka', 'India', '560076', 12.8996, 77.6043,
            '+91-80-6621-4444', 'enquiry@fortishealthcare.com', 'https://www.fortishealthcare.com', 550, 2006, 4.4, 1100,
            1, GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital: Fortis Hospital Bangalore';
END
ELSE
    SET @HospitalId3 = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Fortis Hospital Bangalore');

-- Hospital 4: Manipal Hospital Bangalore
DECLARE @HospitalId4 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'Manipal Hospital Bangalore')
BEGIN
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, 
                                    Phone, Email, Website, BedCapacity, EstablishedYear, AverageRating, TotalReviews, 
                                    IsActive, CreatedAt, UpdatedAt)
    VALUES (@HospitalId4, 'Manipal Hospital Bangalore', 
            'Comprehensive healthcare services with focus on minimal invasive surgeries and advanced diagnostics.',
            'HAL Airport Road', 'Bangalore', 'Karnataka', 'India', '560017', 12.9576, 77.6451,
            '+91-80-2502-4444', 'contact@manipalhospitals.com', 'https://www.manipalhospitals.com', 650, 1991, 4.6, 1450,
            1, GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital: Manipal Hospital Bangalore';
END
ELSE
    SET @HospitalId4 = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Manipal Hospital Bangalore');

-- Hospital 5: KIMS Hospital Hyderabad
DECLARE @HospitalId5 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Hospitals WHERE Name = 'KIMS Hospital Hyderabad')
BEGIN
    INSERT INTO Hospital.Hospitals (Id, Name, Description, Address, City, State, Country, PostalCode, Latitude, Longitude, 
                                    Phone, Email, Website, BedCapacity, EstablishedYear, AverageRating, TotalReviews, 
                                    IsActive, CreatedAt, UpdatedAt)
    VALUES (@HospitalId5, 'KIMS Hospital Hyderabad', 
            'State-of-the-art multi-specialty hospital with excellence in critical care and emergency services.',
            'Kondapur Main Road', 'Hyderabad', 'Telangana', 'India', '500084', 17.4569, 78.3631,
            '+91-40-4815-5000', 'info@kimshospitals.com', 'https://www.kimshospitals.com', 500, 2003, 4.2, 750,
            1, GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted hospital: KIMS Hospital Hyderabad';
END
ELSE
    SET @HospitalId5 = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'KIMS Hospital Hyderabad');

-- Insert Doctors
PRINT '  Inserting doctors...';

-- Doctor 1: Dr. Suresh Reddy (Cardiologist at Apollo)
DECLARE @DoctorId1 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.suresh.reddy@apollo.com')
BEGIN
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, 
                                  YearsOfExperience, Biography, ProfileImageUrl, ConsultationFee, 
                                  AverageRating, TotalReviews, IsActive, CreatedAt, UpdatedAt)
    VALUES (@DoctorId1, @HospitalId1, 'Suresh', 'Reddy', 'dr.suresh.reddy@apollo.com', '+91-9876501001',
            'MBBS, MD, DM (Cardiology)', 18, 
            'Senior Cardiologist with 18+ years of experience in interventional cardiology and heart failure management.',
            NULL, 1500.00, 4.7, 450, 1, GETUTCDATE(), GETUTCDATE());
    
    -- Add specialties
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, CreatedAt)
    VALUES (@DoctorId1, @SpecialtyId_Cardiology, GETUTCDATE());
    
    -- Add languages
    IF @LangId_EN IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId1, @LangId_EN, GETUTCDATE());
    IF @LangId_HI IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId1, @LangId_HI, GETUTCDATE());
    IF @LangId_TE IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId1, @LangId_TE, GETUTCDATE());
    
    -- Add credentials
    INSERT INTO Hospital.DoctorCredentials (Id, DoctorId, Type, Name, IssuingOrganization, IssueDate, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @DoctorId1, 'Medical License', 'Medical Council of India Registration', 'MCI', '2005-06-15', 1, GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted doctor: Dr. Suresh Reddy (Cardiology)';
END
ELSE
    SET @DoctorId1 = (SELECT Id FROM Hospital.Doctors WHERE Email = 'dr.suresh.reddy@apollo.com');

-- Doctor 2: Dr. Lakshmi Devi (Pediatrician at Yashoda)
DECLARE @DoctorId2 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.lakshmi.devi@yashoda.com')
BEGIN
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, 
                                  YearsOfExperience, Biography, ProfileImageUrl, ConsultationFee, 
                                  AverageRating, TotalReviews, IsActive, CreatedAt, UpdatedAt)
    VALUES (@DoctorId2, @HospitalId2, 'Lakshmi', 'Devi', 'dr.lakshmi.devi@yashoda.com', '+91-9876501002',
            'MBBS, MD (Pediatrics)', 12, 
            'Experienced pediatrician specializing in neonatal care and child development disorders.',
            NULL, 1000.00, 4.8, 380, 1, GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, CreatedAt)
    VALUES (@DoctorId2, @SpecialtyId_Pediatrics, GETUTCDATE());
    
    IF @LangId_EN IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId2, @LangId_EN, GETUTCDATE());
    IF @LangId_TE IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId2, @LangId_TE, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorCredentials (Id, DoctorId, Type, Name, IssuingOrganization, IssueDate, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @DoctorId2, 'Medical License', 'MCI Registration', 'MCI', '2011-08-20', 1, GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted doctor: Dr. Lakshmi Devi (Pediatrics)';
END
ELSE
    SET @DoctorId2 = (SELECT Id FROM Hospital.Doctors WHERE Email = 'dr.lakshmi.devi@yashoda.com');

-- Doctor 3: Dr. Ravi Kumar (Orthopedic Surgeon at Fortis)
DECLARE @DoctorId3 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.ravi.kumar@fortis.com')
BEGIN
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, 
                                  YearsOfExperience, Biography, ProfileImageUrl, ConsultationFee, 
                                  AverageRating, TotalReviews, IsActive, CreatedAt, UpdatedAt)
    VALUES (@DoctorId3, @HospitalId3, 'Ravi', 'Kumar', 'dr.ravi.kumar@fortis.com', '+91-9876501003',
            'MBBS, MS (Orthopedics)', 15, 
            'Orthopedic surgeon specializing in joint replacement and sports medicine.',
            NULL, 1200.00, 4.5, 320, 1, GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, CreatedAt)
    VALUES (@DoctorId3, @SpecialtyId_Orthopedics, GETUTCDATE());
    
    IF @LangId_EN IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId3, @LangId_EN, GETUTCDATE());
    IF @LangId_HI IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId3, @LangId_HI, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorCredentials (Id, DoctorId, Type, Name, IssuingOrganization, IssueDate, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @DoctorId3, 'Medical License', 'Karnataka Medical Council', 'KMC', '2008-05-10', 1, GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted doctor: Dr. Ravi Kumar (Orthopedics)';
END
ELSE
    SET @DoctorId3 = (SELECT Id FROM Hospital.Doctors WHERE Email = 'dr.ravi.kumar@fortis.com');

-- Doctor 4: Dr. Priya Menon (Neurologist at Manipal)
DECLARE @DoctorId4 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.priya.menon@manipal.com')
BEGIN
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, 
                                  YearsOfExperience, Biography, ProfileImageUrl, ConsultationFee, 
                                  AverageRating, TotalReviews, IsActive, CreatedAt, UpdatedAt)
    VALUES (@DoctorId4, @HospitalId4, 'Priya', 'Menon', 'dr.priya.menon@manipal.com', '+91-9876501004',
            'MBBS, MD, DM (Neurology)', 10, 
            'Neurologist with expertise in stroke management, epilepsy, and movement disorders.',
            NULL, 1300.00, 4.6, 290, 1, GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, CreatedAt)
    VALUES (@DoctorId4, @SpecialtyId_Neurology, GETUTCDATE());
    
    IF @LangId_EN IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId4, @LangId_EN, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorCredentials (Id, DoctorId, Type, Name, IssuingOrganization, IssueDate, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @DoctorId4, 'Medical License', 'Karnataka Medical Council', 'KMC', '2013-07-15', 1, GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted doctor: Dr. Priya Menon (Neurology)';
END
ELSE
    SET @DoctorId4 = (SELECT Id FROM Hospital.Doctors WHERE Email = 'dr.priya.menon@manipal.com');

-- Doctor 5: Dr. Arun Sharma (Oncologist at KIMS)
DECLARE @DoctorId5 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.arun.sharma@kims.com')
BEGIN
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, 
                                  YearsOfExperience, Biography, ProfileImageUrl, ConsultationFee, 
                                  AverageRating, TotalReviews, IsActive, CreatedAt, UpdatedAt)
    VALUES (@DoctorId5, @HospitalId5, 'Arun', 'Sharma', 'dr.arun.sharma@kims.com', '+91-9876501005',
            'MBBS, MD, DM (Medical Oncology)', 14, 
            'Medical oncologist with focus on solid tumors and precision medicine.',
            NULL, 1800.00, 4.9, 410, 1, GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, CreatedAt)
    VALUES (@DoctorId5, @SpecialtyId_Oncology, GETUTCDATE());
    
    IF @LangId_EN IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId5, @LangId_EN, GETUTCDATE());
    IF @LangId_HI IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId5, @LangId_HI, GETUTCDATE());
    IF @LangId_TE IS NOT NULL
        INSERT INTO Hospital.DoctorLanguages (DoctorId, LanguageId, CreatedAt)
        VALUES (@DoctorId5, @LangId_TE, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorCredentials (Id, DoctorId, Type, Name, IssuingOrganization, IssueDate, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @DoctorId5, 'Medical License', 'Telangana Medical Council', 'TMC', '2009-09-01', 1, GETUTCDATE(), GETUTCDATE());
    
    PRINT '    ✓ Inserted doctor: Dr. Arun Sharma (Oncology)';
END
ELSE
    SET @DoctorId5 = (SELECT Id FROM Hospital.Doctors WHERE Email = 'dr.arun.sharma@kims.com');

-- Insert Appointments
PRINT '  Inserting appointments...';

-- Appointment 1: Rajesh with Dr. Suresh (Completed)
IF NOT EXISTS (SELECT 1 FROM Hospital.Appointments WHERE UserId = @UserId1 AND DoctorId = @DoctorId1)
BEGIN
    INSERT INTO Hospital.Appointments (Id, UserId, DoctorId, HospitalId, ScheduledDate, ScheduledTime, 
                                       ReasonForVisit, Status, ConsultationFee, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId1, @DoctorId1, @HospitalId1, 
            DATEADD(DAY, -15, CAST(GETUTCDATE() AS DATE)), '10:00:00', 
            'Chest pain and breathlessness', 'completed', 1500.00, 
            DATEADD(DAY, -20, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted appointment: Rajesh → Dr. Suresh (Completed)';
END

-- Appointment 2: Priya with Dr. Lakshmi (Confirmed)
IF NOT EXISTS (SELECT 1 FROM Hospital.Appointments WHERE UserId = @UserId2 AND DoctorId = @DoctorId2)
BEGIN
    INSERT INTO Hospital.Appointments (Id, UserId, DoctorId, HospitalId, ScheduledDate, ScheduledTime, 
                                       ReasonForVisit, Status, ConsultationFee, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId2, @DoctorId2, @HospitalId2, 
            DATEADD(DAY, 5, CAST(GETUTCDATE() AS DATE)), '14:30:00', 
            'Child vaccination and routine checkup', 'confirmed', 1000.00, 
            DATEADD(DAY, -2, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted appointment: Priya → Dr. Lakshmi (Confirmed)';
END

-- Appointment 3: Mohammed with Dr. Ravi (Scheduled)
IF NOT EXISTS (SELECT 1 FROM Hospital.Appointments WHERE UserId = @UserId3 AND DoctorId = @DoctorId3)
BEGIN
    INSERT INTO Hospital.Appointments (Id, UserId, DoctorId, HospitalId, ScheduledDate, ScheduledTime, 
                                       ReasonForVisit, Status, ConsultationFee, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId3, @DoctorId3, @HospitalId3, 
            DATEADD(DAY, 10, CAST(GETUTCDATE() AS DATE)), '11:00:00', 
            'Knee pain and swelling', 'scheduled', 1200.00, 
            DATEADD(DAY, -1, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted appointment: Mohammed → Dr. Ravi (Scheduled)';
END

-- Appointment 4: Anita with Dr. Priya (Confirmed)
IF NOT EXISTS (SELECT 1 FROM Hospital.Appointments WHERE UserId = @UserId4 AND DoctorId = @DoctorId4)
BEGIN
    INSERT INTO Hospital.Appointments (Id, UserId, DoctorId, HospitalId, ScheduledDate, ScheduledTime, 
                                       ReasonForVisit, Status, ConsultationFee, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId4, @DoctorId4, @HospitalId4, 
            DATEADD(DAY, 7, CAST(GETUTCDATE() AS DATE)), '16:00:00', 
            'Severe headaches and dizziness', 'confirmed', 1300.00, 
            GETUTCDATE(), GETUTCDATE());
    PRINT '    ✓ Inserted appointment: Anita → Dr. Priya (Confirmed)';
END

-- Appointment 5: Vikram with Dr. Arun (Scheduled)
IF NOT EXISTS (SELECT 1 FROM Hospital.Appointments WHERE UserId = @UserId5 AND DoctorId = @DoctorId5)
BEGIN
    INSERT INTO Hospital.Appointments (Id, UserId, DoctorId, HospitalId, ScheduledDate, ScheduledTime, 
                                       ReasonForVisit, Status, ConsultationFee, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId5, @DoctorId5, @HospitalId5, 
            DATEADD(DAY, 12, CAST(GETUTCDATE() AS DATE)), '09:30:00', 
            'Follow-up consultation for cancer screening', 'scheduled', 1800.00, 
            DATEADD(DAY, -3, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted appointment: Vikram → Dr. Arun (Scheduled)';
END

-- Insert Reviews
PRINT '  Inserting reviews...';

-- Review 1: Rajesh reviews Dr. Suresh
IF NOT EXISTS (SELECT 1 FROM Hospital.Reviews WHERE UserId = @UserId1 AND DoctorId = @DoctorId1)
BEGIN
    INSERT INTO Hospital.Reviews (Id, UserId, DoctorId, HospitalId, Rating, Comment, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId1, @DoctorId1, @HospitalId1, 5, 
            'Excellent doctor! Very thorough in diagnosis and treatment. Highly recommended for heart problems.', 
            1, DATEADD(DAY, -10, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted review: Rajesh → Dr. Suresh';
END

-- Review 2: Priya reviews Apollo Hospital
IF NOT EXISTS (SELECT 1 FROM Hospital.Reviews WHERE UserId = @UserId2 AND HospitalId = @HospitalId1 AND DoctorId IS NULL)
BEGIN
    INSERT INTO Hospital.Reviews (Id, UserId, DoctorId, HospitalId, Rating, Comment, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId2, NULL, @HospitalId1, 4, 
            'Great facilities and caring staff. Wait times can be long but worth it.', 
            1, DATEADD(DAY, -25, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted review: Priya → Apollo Hospital';
END

-- Review 3: Mohammed reviews Dr. Lakshmi
IF NOT EXISTS (SELECT 1 FROM Hospital.Reviews WHERE UserId = @UserId3 AND DoctorId = @DoctorId2)
BEGIN
    INSERT INTO Hospital.Reviews (Id, UserId, DoctorId, HospitalId, Rating, Comment, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId3, @DoctorId2, @HospitalId2, 5, 
            'Dr. Lakshmi is wonderful with children. Very patient and explains everything clearly.', 
            1, DATEADD(DAY, -18, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted review: Mohammed → Dr. Lakshmi';
END

-- Review 4: Anita reviews Fortis Hospital
IF NOT EXISTS (SELECT 1 FROM Hospital.Reviews WHERE UserId = @UserId4 AND HospitalId = @HospitalId3 AND DoctorId IS NULL)
BEGIN
    INSERT INTO Hospital.Reviews (Id, UserId, DoctorId, HospitalId, Rating, Comment, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId4, NULL, @HospitalId3, 4, 
            'Modern hospital with good infrastructure. Staff is professional and helpful.', 
            1, DATEADD(DAY, -30, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted review: Anita → Fortis Hospital';
END

-- Review 5: Vikram reviews Dr. Priya
IF NOT EXISTS (SELECT 1 FROM Hospital.Reviews WHERE UserId = @UserId5 AND DoctorId = @DoctorId4)
BEGIN
    INSERT INTO Hospital.Reviews (Id, UserId, DoctorId, HospitalId, Rating, Comment, IsVerified, CreatedAt, UpdatedAt)
    VALUES (NEWID(), @UserId5, @DoctorId4, @HospitalId4, 5, 
            'Very knowledgeable neurologist. Took time to explain my condition and treatment options.', 
            1, DATEADD(DAY, -12, GETUTCDATE()), GETUTCDATE());
    PRINT '    ✓ Inserted review: Vikram → Dr. Priya';
END

PRINT '  ✓ Hospital Service data insertion complete!';
PRINT '';

-- =============================================
-- PART 3: MESSAGING SERVICE DATA
-- =============================================
PRINT 'PART 3: Inserting Messaging Service Data...';
PRINT '';

-- Insert Message Threads
PRINT '  Inserting message threads...';

-- Thread 1: Rajesh and Dr. Suresh
DECLARE @ThreadId1 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Messaging.MessageThreads WHERE UserId = @UserId1 AND DoctorId = @DoctorId1)
BEGIN
    INSERT INTO Messaging.MessageThreads (Id, UserId, DoctorId, Subject, Status, CreatedAt, UpdatedAt)
    VALUES (@ThreadId1, @UserId1, @DoctorId1, 'Follow-up questions about medication', 'active', 
            DATEADD(DAY, -5, GETUTCDATE()), GETUTCDATE());
    
    -- Insert messages in thread
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId1, @UserId1, 'patient', 
            'Hello Doctor, I have some questions about the medication you prescribed.', 
            1, DATEADD(DAY, -5, GETUTCDATE()));
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId1, @DoctorId1, 'doctor', 
            'Hello Rajesh, please go ahead with your questions.', 
            1, DATEADD(DAY, -4, GETUTCDATE()));
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId1, @UserId1, 'patient', 
            'Should I take the medication before or after meals?', 
            1, DATEADD(DAY, -4, GETUTCDATE()));
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId1, @DoctorId1, 'doctor', 
            'Take it after meals, twice daily. If you experience any side effects, contact me immediately.', 
            0, DATEADD(DAY, -3, GETUTCDATE()));
    
    PRINT '    ✓ Inserted thread: Rajesh ↔ Dr. Suresh (4 messages)';
END

-- Thread 2: Priya and Dr. Lakshmi
DECLARE @ThreadId2 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Messaging.MessageThreads WHERE UserId = @UserId2 AND DoctorId = @DoctorId2)
BEGIN
    INSERT INTO Messaging.MessageThreads (Id, UserId, DoctorId, Subject, Status, CreatedAt, UpdatedAt)
    VALUES (@ThreadId2, @UserId2, @DoctorId2, 'Vaccination schedule query', 'active', 
            DATEADD(DAY, -2, GETUTCDATE()), GETUTCDATE());
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId2, @UserId2, 'patient', 
            'Doctor, when should I bring my child for the next vaccination?', 
            1, DATEADD(DAY, -2, GETUTCDATE()));
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId2, @DoctorId2, 'doctor', 
            'The next vaccination is due in 2 weeks. Please book an appointment.', 
            0, DATEADD(DAY, -1, GETUTCDATE()));
    
    PRINT '    ✓ Inserted thread: Priya ↔ Dr. Lakshmi (2 messages)';
END

-- Thread 3: Mohammed and Dr. Ravi
DECLARE @ThreadId3 UNIQUEIDENTIFIER = NEWID();
IF NOT EXISTS (SELECT 1 FROM Messaging.MessageThreads WHERE UserId = @UserId3 AND DoctorId = @DoctorId3)
BEGIN
    INSERT INTO Messaging.MessageThreads (Id, UserId, DoctorId, Subject, Status, CreatedAt, UpdatedAt)
    VALUES (@ThreadId3, @UserId3, @DoctorId3, 'Pre-appointment queries', 'active', 
            DATEADD(DAY, -1, GETUTCDATE()), GETUTCDATE());
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId3, @UserId3, 'patient', 
            'Doctor, what tests should I get done before my appointment?', 
            1, DATEADD(DAY, -1, GETUTCDATE()));
    
    INSERT INTO Messaging.Messages (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES (NEWID(), @ThreadId3, @DoctorId3, 'doctor', 
            'Please get an X-ray of your knee done. Bring the reports with you.', 
            0, GETUTCDATE());
    
    PRINT '    ✓ Inserted thread: Mohammed ↔ Dr. Ravi (2 messages)';
END

PRINT '  ✓ Messaging Service data insertion complete!';
PRINT '';

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'TEST DATA INSERTION COMPLETE!';
PRINT '========================================';
PRINT '';
PRINT 'Summary of inserted data:';
PRINT '  ✓ 5 Test Users (Patients)';
PRINT '  ✓ 5 User Preferences';
PRINT '  ✓ 3 Roles (patient, doctor, hospital_admin)';
PRINT '  ✓ 5 Specialties';
PRINT '  ✓ 5 Hospitals';
PRINT '  ✓ 5 Doctors (with specialties, languages, credentials)';
PRINT '  ✓ 5 Appointments (various statuses)';
PRINT '  ✓ 5 Reviews';
PRINT '  ✓ 3 Message Threads (with 8 total messages)';
PRINT '';
PRINT 'All data uses proper foreign keys from metadata tables.';
PRINT 'Ready for testing search, appointments, and messaging!';
PRINT '';

-- Display some sample data
PRINT 'Sample Data Check:';
PRINT '';
PRINT '  Users:';
SELECT TOP 3 FirstName + ' ' + LastName AS Name, Email, City FROM UserManagement.Users;
PRINT '';
PRINT '  Hospitals:';
SELECT TOP 3 Name, City, BedCapacity, AverageRating FROM Hospital.Hospitals;
PRINT '';
PRINT '  Doctors:';
SELECT TOP 3 FirstName + ' ' + LastName AS Name, Qualification, ConsultationFee, AverageRating FROM Hospital.Doctors;
PRINT '';
PRINT '  Appointments:';
SELECT TOP 3 
    u.FirstName + ' ' + u.LastName AS Patient,
    d.FirstName + ' ' + d.LastName AS Doctor,
    a.ScheduledDate,
    a.Status
FROM Hospital.Appointments a
JOIN UserManagement.Users u ON a.UserId = u.Id
JOIN Hospital.Doctors d ON a.DoctorId = d.Id;

GO
