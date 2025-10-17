-- =============================================
-- Insert 150 Reviews for Hospitals and Doctors
-- =============================================

PRINT 'Inserting 150 Reviews...';

-- Get sample data
DECLARE @UserIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100));
INSERT INTO @UserIds 
SELECT TOP 50 Id, FirstName, LastName FROM UserManagement.Users ORDER BY CreatedAt;

DECLARE @HospitalIds TABLE (Id UNIQUEIDENTIFIER, Name NVARCHAR(200));
INSERT INTO @HospitalIds 
SELECT TOP 30 Id, Name FROM Hospital.Hospitals ORDER BY CreatedAt;

DECLARE @DoctorIds TABLE (Id UNIQUEIDENTIFIER, FirstName NVARCHAR(100), LastName NVARCHAR(100), HospitalId UNIQUEIDENTIFIER);
INSERT INTO @DoctorIds 
SELECT TOP 50 Id, FirstName, LastName, HospitalId FROM Hospital.Doctors ORDER BY CreatedAt;

DECLARE @Counter INT = 1;
DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @UserId UNIQUEIDENTIFIER;
DECLARE @HospitalId UNIQUEIDENTIFIER;
DECLARE @DoctorId UNIQUEIDENTIFIER;
DECLARE @Rating INT;
DECLARE @Title NVARCHAR(200);
DECLARE @Comment NVARCHAR(2000);
DECLARE @TreatmentDate DATE;
DECLARE @IsVerified BIT;
DECLARE @IsApproved BIT;
DECLARE @CreatedAt DATETIME2(7);

-- Review titles and comments
DECLARE @HospitalTitles TABLE (Title NVARCHAR(200));
INSERT INTO @HospitalTitles VALUES 
('Excellent healthcare services'),
('Great hospital with caring staff'),
('Professional and efficient service'),
('Outstanding medical care'),
('Highly recommended hospital'),
('Good facilities and treatment'),
('Satisfactory healthcare experience'),
('Average hospital services'),
('Needs improvement in some areas'),
('Disappointing experience');

DECLARE @DoctorTitles TABLE (Title NVARCHAR(200));
INSERT INTO @DoctorTitles VALUES 
('Excellent doctor with great expertise'),
('Very knowledgeable and caring'),
('Professional and thorough consultation'),
('Outstanding medical treatment'),
('Highly skilled and experienced'),
('Good doctor with patient approach'),
('Satisfactory consultation'),
('Average medical service'),
('Needs improvement in communication'),
('Disappointing consultation');

DECLARE @HospitalComments TABLE (Comment NVARCHAR(2000));
INSERT INTO @HospitalComments VALUES 
('The hospital provides excellent healthcare services with modern facilities. The staff is very professional and caring. Highly recommended for quality medical care.'),
('Great experience at this hospital. The doctors are knowledgeable and the nursing staff is very supportive. Clean environment and good infrastructure.'),
('Professional service with efficient treatment. The hospital has good facilities and the staff is helpful. Would recommend for quality healthcare.'),
('Outstanding medical care with experienced doctors. The hospital maintains high standards of hygiene and patient care. Very satisfied with the services.'),
('Highly recommended hospital with excellent facilities. The medical team is professional and the treatment was effective. Good value for money.'),
('Good hospital with caring staff. The facilities are adequate and the doctors are experienced. Overall satisfactory healthcare experience.'),
('The hospital provides decent medical services. Staff is friendly and the environment is clean. Treatment was effective and timely.'),
('Average hospital with basic facilities. The medical care is satisfactory but there is room for improvement in patient care services.'),
('The hospital needs improvement in some areas. While the medical treatment was adequate, the overall experience could be better.'),
('Disappointing experience with poor service quality. The hospital needs significant improvement in patient care and facilities.');

DECLARE @DoctorComments TABLE (Comment NVARCHAR(2000));
INSERT INTO @DoctorComments VALUES 
('Dr. is an excellent physician with great expertise in the field. Very thorough in diagnosis and treatment. Highly recommended for quality medical care.'),
('Very knowledgeable doctor with a caring approach. Takes time to explain the condition and treatment options. Professional and patient-friendly.'),
('Professional consultation with detailed examination. The doctor is experienced and provides effective treatment. Very satisfied with the medical care.'),
('Outstanding doctor with excellent medical skills. The consultation was thorough and the treatment was effective. Highly skilled and experienced physician.'),
('Highly skilled doctor with great experience. The medical consultation was comprehensive and the treatment approach was professional. Recommended.'),
('Good doctor with a patient approach. The consultation was satisfactory and the treatment was effective. Professional and caring physician.'),
('Satisfactory consultation with adequate medical care. The doctor is experienced and provides standard treatment. Overall good medical service.'),
('Average consultation with basic medical care. The doctor is knowledgeable but could improve in patient communication and care.'),
('The doctor needs improvement in communication skills. While the medical knowledge is adequate, the patient interaction could be better.'),
('Disappointing consultation with poor communication. The doctor needs significant improvement in patient care and medical approach.');

-- Insert reviews dynamically
WHILE @Counter <= 150
BEGIN
    -- Select random user
    SELECT TOP 1 @UserId = Id FROM @UserIds ORDER BY NEWID();
    
    -- Decide if it's a hospital or doctor review (70% doctor, 30% hospital)
    DECLARE @ReviewType INT = ABS(CHECKSUM(NEWID())) % 100;
    
    IF @ReviewType < 70 -- Doctor review
    BEGIN
        SELECT TOP 1 @DoctorId = Id, @HospitalId = HospitalId FROM @DoctorIds ORDER BY NEWID();
        SET @HospitalId = NULL;
        
        -- Select random doctor title and comment
        SELECT TOP 1 @Title = Title FROM @DoctorTitles ORDER BY NEWID();
        SELECT TOP 1 @Comment = Comment FROM @DoctorComments ORDER BY NEWID();
    END
    ELSE -- Hospital review
    BEGIN
        SELECT TOP 1 @HospitalId = Id FROM @HospitalIds ORDER BY NEWID();
        SET @DoctorId = NULL;
        
        -- Select random hospital title and comment
        SELECT TOP 1 @Title = Title FROM @HospitalTitles ORDER BY NEWID();
        SELECT TOP 1 @Comment = Comment FROM @HospitalComments ORDER BY NEWID();
    END
    
    -- Set rating (weighted towards higher ratings)
    DECLARE @RatingWeight INT = ABS(CHECKSUM(NEWID())) % 100;
    IF @RatingWeight < 60
        SET @Rating = 5
    ELSE IF @RatingWeight < 80
        SET @Rating = 4
    ELSE IF @RatingWeight < 90
        SET @Rating = 3
    ELSE IF @RatingWeight < 95
        SET @Rating = 2
    ELSE
        SET @Rating = 1;
    
    -- Set treatment date (past 6 months)
    SET @TreatmentDate = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 180), CAST(GETUTCDATE() AS DATE));
    
    -- Set verification and approval status
    SET @IsVerified = CASE WHEN ABS(CHECKSUM(NEWID())) % 10 < 8 THEN 1 ELSE 0 END; -- 80% verified
    SET @IsApproved = CASE WHEN ABS(CHECKSUM(NEWID())) % 10 < 9 THEN 1 ELSE 0 END; -- 90% approved
    
    -- Set creation date (within last 3 months)
    SET @CreatedAt = DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 90), GETUTCDATE());
    
    SET @ReviewId = NEWID();
    
    INSERT INTO Hospital.Reviews 
    (Id, HospitalId, DoctorId, PatientId, Rating, Title, Comment, TreatmentDate, IsVerified, IsApproved, CreatedAt)
    VALUES 
    (@ReviewId, @HospitalId, @DoctorId, @UserId, @Rating, @Title, @Comment, @TreatmentDate, @IsVerified, @IsApproved, @CreatedAt);
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 150 reviews!';
GO
