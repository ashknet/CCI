-- =============================================
-- Insert 150 Doctors across Hyderabad Hospitals
-- =============================================

-- Get required IDs
DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Countries WHERE Name = 'India');
DECLARE @CityId_HYD UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name LIKE '%Hyderabad%');

-- Get Hospital IDs
DECLARE @ApolloJubilee UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Apollo Hospital Jubilee Hills');
DECLARE @YashodaSomajiguda UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Yashoda Hospitals Somajiguda');
DECLARE @CareBanjara UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Care Hospitals Banjara Hills');
DECLARE @KIMSSecunderabad UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'KIMS Hospital Secunderabad');
DECLARE @ContinentalGachibowli UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Continental Hospitals Gachibowli');
DECLARE @StarBanjara UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Star Hospitals Banjara Hills');
DECLARE @AIGSomajiguda UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Asian Institute of Gastroenterology');
DECLARE @RainbowBanjara UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Rainbow Children Hospital Banjara Hills');
DECLARE @AwareLBNagar UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Aware Gleneagles Global Hospital LB Nagar');
DECLARE @MedicoverMadhapur UNIQUEIDENTIFIER = (SELECT Id FROM Hospital.Hospitals WHERE Name = 'Medicover Hospitals Madhapur');

-- Get Specialty IDs
DECLARE @CardiologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Cardiology');
DECLARE @NeurologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Neurology');
DECLARE @OrthopedicsId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Orthopedics');
DECLARE @PediatricsId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Pediatrics');
DECLARE @OncologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Oncology');
DECLARE @GastroenterologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Gastroenterology');
DECLARE @NephrologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Nephrology');
DECLARE @UrologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Urology');
DECLARE @GynecologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Gynecology');
DECLARE @DermatologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Dermatology');
DECLARE @OphthalmologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Ophthalmology');
DECLARE @ENTId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'ENT');
DECLARE @PsychiatryId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Psychiatry');
DECLARE @EndocrinologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Endocrinology');
DECLARE @PulmonologyId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'Pulmonology');
DECLARE @GeneralSurgeryId UNIQUEIDENTIFIER = (SELECT Id FROM Metadata.Specialties WHERE Name = 'General Surgery');

PRINT 'Inserting 150 Doctors across Hyderabad hospitals...';

-- Apollo Hospital Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.suresh.reddy@apollo.com')
BEGIN
    DECLARE @DoctorId1 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId1, @ApolloJubilee, 'Suresh', 'Reddy', 'dr.suresh.reddy@apollo.com', '+91-9876502001', 'MBBS, MD, DM (Cardiology)', 18, 'Senior Interventional Cardiologist with expertise in complex angioplasty and heart failure management', 2500.00, 4.7, 450, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId1, @CardiologyId, 1, 18);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.lakshmi.devi@apollo.com')
BEGIN
    DECLARE @DoctorId2 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId2, @ApolloJubilee, 'Lakshmi', 'Devi', 'dr.lakshmi.devi@apollo.com', '+91-9876502002', 'MBBS, MD (Pediatrics)', 12, 'Pediatrician specializing in neonatology and child development disorders', 1500.00, 4.8, 380, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId2, @PediatricsId, 1, 12);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.ravi.kumar@apollo.com')
BEGIN
    DECLARE @DoctorId3 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId3, @ApolloJubilee, 'Ravi', 'Kumar', 'dr.ravi.kumar@apollo.com', '+91-9876502003', 'MBBS, MS (Orthopedics)', 15, 'Orthopedic surgeon specializing in joint replacement and sports medicine', 2000.00, 4.5, 320, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId3, @OrthopedicsId, 1, 15);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.priya.menon@apollo.com')
BEGIN
    DECLARE @DoctorId4 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId4, @ApolloJubilee, 'Priya', 'Menon', 'dr.priya.menon@apollo.com', '+91-9876502004', 'MBBS, MD, DM (Neurology)', 10, 'Neurologist with expertise in stroke management, epilepsy, and movement disorders', 2200.00, 4.6, 290, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId4, @NeurologyId, 1, 10);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.arun.sharma@apollo.com')
BEGIN
    DECLARE @DoctorId5 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId5, @ApolloJubilee, 'Arun', 'Sharma', 'dr.arun.sharma@apollo.com', '+91-9876502005', 'MBBS, MD, DM (Medical Oncology)', 14, 'Medical oncologist with focus on solid tumors and precision medicine', 3000.00, 4.9, 410, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId5, @OncologyId, 1, 14);
END

-- Yashoda Hospitals Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.venkat.rao@yashoda.com')
BEGIN
    DECLARE @DoctorId6 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId6, @YashodaSomajiguda, 'Venkat', 'Rao', 'dr.venkat.rao@yashoda.com', '+91-9876502006', 'MBBS, MS (General Surgery)', 16, 'General surgeon with expertise in laparoscopic and minimally invasive procedures', 1800.00, 4.4, 350, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId6, @GeneralSurgeryId, 1, 16);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.sailaja.iyer@yashoda.com')
BEGIN
    DECLARE @DoctorId7 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId7, @YashodaSomajiguda, 'Sailaja', 'Iyer', 'dr.sailaja.iyer@yashoda.com', '+91-9876502007', 'MBBS, MD (Gynecology)', 13, 'Gynecologist specializing in high-risk pregnancies and fertility treatments', 1600.00, 4.7, 420, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId7, @GynecologyId, 1, 13);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.krishna.reddy@yashoda.com')
BEGIN
    DECLARE @DoctorId8 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId8, @YashodaSomajiguda, 'Krishna', 'Reddy', 'dr.krishna.reddy@yashoda.com', '+91-9876502008', 'MBBS, MD (Gastroenterology)', 11, 'Gastroenterologist with expertise in advanced endoscopy and liver diseases', 2100.00, 4.5, 380, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId8, @GastroenterologyId, 1, 11);
END

-- Care Hospitals Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.mahesh.goud@care.com')
BEGIN
    DECLARE @DoctorId9 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId9, @CareBanjara, 'Mahesh', 'Goud', 'dr.mahesh.goud@care.com', '+91-9876502009', 'MBBS, MD (Nephrology)', 9, 'Nephrologist specializing in kidney diseases and dialysis management', 1900.00, 4.3, 280, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId9, @NephrologyId, 1, 9);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.swetha.naidu@care.com')
BEGIN
    DECLARE @DoctorId10 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId10, @CareBanjara, 'Swetha', 'Naidu', 'dr.swetha.naidu@care.com', '+91-9876502010', 'MBBS, MS (Urology)', 8, 'Urologist with expertise in minimally invasive urological procedures', 1700.00, 4.4, 320, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId10, @UrologyId, 1, 8);
END

-- KIMS Hospital Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.bhaskar.rao@kims.com')
BEGIN
    DECLARE @DoctorId11 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId11, @KIMSSecunderabad, 'Bhaskar', 'Rao', 'dr.bhaskar.rao@kims.com', '+91-9876502011', 'MBBS, MD (Dermatology)', 7, 'Dermatologist specializing in cosmetic dermatology and skin cancer treatment', 1400.00, 4.6, 290, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId11, @DermatologyId, 1, 7);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.keerthi.patel@kims.com')
BEGIN
    DECLARE @DoctorId12 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId12, @KIMSSecunderabad, 'Keerthi', 'Patel', 'dr.keerthi.patel@kims.com', '+91-9876502012', 'MBBS, MS (Ophthalmology)', 6, 'Ophthalmologist with expertise in cataract and retinal surgery', 1600.00, 4.5, 340, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId12, @OphthalmologyId, 1, 6);
END

-- Continental Hospitals Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.padma.sharma@continental.com')
BEGIN
    DECLARE @DoctorId13 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId13, @ContinentalGachibowli, 'Padma', 'Sharma', 'dr.padma.sharma@continental.com', '+91-9876502013', 'MBBS, MS (ENT)', 10, 'ENT surgeon specializing in endoscopic sinus surgery and hearing disorders', 1500.00, 4.4, 310, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId13, @ENTId, 1, 10);
END

IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.chandra.kumar@continental.com')
BEGIN
    DECLARE @DoctorId14 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId14, @ContinentalGachibowli, 'Chandra', 'Kumar', 'dr.chandra.kumar@continental.com', '+91-9876502014', 'MBBS, MD (Psychiatry)', 12, 'Psychiatrist specializing in mood disorders and addiction medicine', 1300.00, 4.3, 250, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId14, @PsychiatryId, 1, 12);
END

-- Star Hospitals Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.kishore.reddy@star.com')
BEGIN
    DECLARE @DoctorId15 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId15, @StarBanjara, 'Kishore', 'Reddy', 'dr.kishore.reddy@star.com', '+91-9876502015', 'MBBS, MD (Endocrinology)', 8, 'Endocrinologist specializing in diabetes and thyroid disorders', 1800.00, 4.5, 280, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId15, @EndocrinologyId, 1, 8);
END

-- AIG Hospital Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.ramesh.naidu@aig.com')
BEGIN
    DECLARE @DoctorId16 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId16, @AIGSomajiguda, 'Ramesh', 'Naidu', 'dr.ramesh.naidu@aig.com', '+91-9876502016', 'MBBS, MD (Pulmonology)', 11, 'Pulmonologist with expertise in sleep medicine and critical care', 2000.00, 4.6, 360, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId16, @PulmonologyId, 1, 11);
END

-- Rainbow Children Hospital Doctors (20 doctors)
IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = 'dr.ganesh.rao@rainbow.com')
BEGIN
    DECLARE @DoctorId17 UNIQUEIDENTIFIER = NEWID();
    INSERT INTO Hospital.Doctors (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
    VALUES (@DoctorId17, @RainbowBanjara, 'Ganesh', 'Rao', 'dr.ganesh.rao@rainbow.com', '+91-9876502017', 'MBBS, MD (Pediatrics)', 9, 'Pediatrician specializing in neonatology and pediatric intensive care', 1200.00, 4.7, 420, 1, GETUTCDATE());
    
    INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
    VALUES (@DoctorId17, @PediatricsId, 1, 9);
END

-- Continue with remaining doctors using dynamic insertion for efficiency
DECLARE @Counter INT = 18;
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @HospitalId UNIQUEIDENTIFIER;
DECLARE @FirstName NVARCHAR(100);
DECLARE @LastName NVARCHAR(100);
DECLARE @Email NVARCHAR(255);
DECLARE @Phone NVARCHAR(20);
DECLARE @Qualification NVARCHAR(200);
DECLARE @Experience INT;
DECLARE @Biography NVARCHAR(2000);
DECLARE @Fee DECIMAL(18,2);
DECLARE @Rating DECIMAL(3,2);
DECLARE @Reviews INT;
DECLARE @SpecialtyId UNIQUEIDENTIFIER;

DECLARE @DoctorNames TABLE (FirstName NVARCHAR(100), LastName NVARCHAR(100));
INSERT INTO @DoctorNames VALUES 
('Prasad', 'Reddy'), ('Murali', 'Naidu'), ('Satish', 'Goud'), ('Vinod', 'Yadav'),
('Ashok', 'Chowdary'), ('Mohan', 'Varma'), ('Prakash', 'Prasad'), ('Ravi', 'Rao'),
('Kumar', 'Kumar'), ('Suresh', 'Sharma'), ('Rajesh', 'Gupta'), ('Vikram', 'Singh'),
('Anil', 'Patel'), ('Naresh', 'Iyer'), ('Chandra', 'Menon'), ('Kishore', 'Nair'),
('Bhaskar', 'Reddy'), ('Mahesh', 'Naidu'), ('Krishna', 'Goud'), ('Venkat', 'Yadav'),
('Ramesh', 'Chowdary'), ('Ganesh', 'Varma'), ('Prasad', 'Prasad'), ('Murali', 'Rao'),
('Satish', 'Kumar'), ('Vinod', 'Sharma'), ('Ashok', 'Gupta'), ('Mohan', 'Singh'),
('Prakash', 'Patel'), ('Ravi', 'Iyer'), ('Kumar', 'Menon'), ('Suresh', 'Nair');

DECLARE @Hospitals TABLE (Id UNIQUEIDENTIFIER, Name NVARCHAR(200));
INSERT INTO @Hospitals 
SELECT Id, Name FROM Hospital.Hospitals WHERE Name IN (
    'Aware Gleneagles Global Hospital LB Nagar', 'Medicover Hospitals Madhapur',
    'Sunshine Hospitals Gachibowli', 'Omni Hospital Kukatpally', 'Maxcure Hospitals Madhapur',
    'Fernandez Hospital Bogulkunta', 'Century Hospital Lakdi Ka Pul', 'Citizens Hospital Nallagandla',
    'AIG Hospitals Gachibowli', 'Lotus Hospital Ameerpet', 'Apollo Cradle Kondapur',
    'Pranahitha Hospital Kukatpally', 'Vijaya Diagnostic Centre Banjara Hills',
    'Care Hospital Hitech City', 'Apollo Spectra Hospitals Kondapur', 'Srikara Hospitals Miyapur',
    'Yashoda Hospitals Malakpet', 'Lotus Hospital Dilsukhnagar', 'Kamineni Hospital LB Nagar',
    'Gandhi Hospital Secunderabad', 'Osmania General Hospital', 'Suraksha Multi-Specialty Hospital Kukatpally',
    'Omega Hospitals Banjara Hills', 'Remedy Hospital Kukatpally', 'Life Care Hospital Banjara Hills',
    'Balaji Hospital Miyapur', 'Apollo Clinic Jubilee Hills', 'Metro Heart Institute Secunderabad',
    'Pulse Hospital Kompally', 'Yashodha Hospitals Secunderabad', 'Virinchi Hospital Banjara Hills'
);

DECLARE @Specialties TABLE (Id UNIQUEIDENTIFIER, Name NVARCHAR(100));
INSERT INTO @Specialties 
SELECT Id, Name FROM Metadata.Specialties WHERE Name IN (
    'Cardiology', 'Neurology', 'Orthopedics', 'Pediatrics', 'Oncology', 'Gastroenterology',
    'Nephrology', 'Urology', 'Gynecology', 'Dermatology', 'Ophthalmology', 'ENT',
    'Psychiatry', 'Endocrinology', 'Pulmonology', 'General Surgery'
);

-- Insert remaining doctors dynamically
WHILE @Counter <= 150
BEGIN
    SET @Email = 'dr.user' + CAST(@Counter AS NVARCHAR(3)) + '@hospital.com';
    
    IF NOT EXISTS (SELECT 1 FROM Hospital.Doctors WHERE Email = @Email)
    BEGIN
        -- Select random components
        SELECT TOP 1 @FirstName = FirstName, @LastName = LastName FROM @DoctorNames ORDER BY NEWID();
        SELECT TOP 1 @HospitalId = Id FROM @Hospitals ORDER BY NEWID();
        SELECT TOP 1 @SpecialtyId = Id FROM @Specialties ORDER BY NEWID();
        
        SET @Phone = '+91-98765' + RIGHT('00000' + CAST(@Counter + 2000 AS NVARCHAR(5)), 5);
        SET @Experience = 5 + ABS(CHECKSUM(NEWID())) % 20;
        SET @Fee = 1000 + (ABS(CHECKSUM(NEWID())) % 2000);
        SET @Rating = 3.5 + (ABS(CHECKSUM(NEWID())) % 15) / 10.0;
        SET @Reviews = 50 + ABS(CHECKSUM(NEWID())) % 500;
        
        SET @Qualification = 'MBBS, MD (' + (SELECT Name FROM @Specialties WHERE Id = @SpecialtyId) + ')';
        SET @Biography = 'Experienced ' + (SELECT Name FROM @Specialties WHERE Id = @SpecialtyId) + ' specialist with ' + CAST(@Experience AS NVARCHAR) + ' years of practice';
        
        SET @DoctorId = NEWID();
        
        INSERT INTO Hospital.Doctors 
        (Id, HospitalId, FirstName, LastName, Email, Phone, Qualification, YearsOfExperience, Biography, ConsultationFee, AverageRating, TotalReviews, IsActive, CreatedAt)
        VALUES 
        (@DoctorId, @HospitalId, @FirstName, @LastName, @Email, @Phone, @Qualification, @Experience, @Biography, @Fee, @Rating, @Reviews, 1, GETUTCDATE());
        
        INSERT INTO Hospital.DoctorSpecialties (DoctorId, SpecialtyId, IsPrimary, YearsOfExperience)
        VALUES (@DoctorId, @SpecialtyId, 1, @Experience);
    END
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 150 doctors across Hyderabad hospitals!';
GO
