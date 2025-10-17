-- =============================================
-- Insert 100 Test Users (Patients) - Hyderabad Focused
-- =============================================

-- Get required metadata IDs
DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Countries WHERE Name = 'India');
DECLARE @CityId_HYD UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Metadata.Cities WHERE Name LIKE '%Hyderabad%');

PRINT 'Inserting 100 Test Users (Patients) for Hyderabad...';

-- Batch 1: Users 1-20
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'rajesh.kumar01@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'rajesh.kumar01@gmail.com', '$2a$11$HASH1234567890', 'Rajesh', 'Kumar', '+91-9876501001', '1985-05-15', 'Male', 'Indian', @CountryId, @CityId_HYD, 'H.No 12-34, Jubilee Hills', '500033', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'priya.sharma02@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'priya.sharma02@gmail.com', '$2a$11$HASH1234567890', 'Priya', 'Sharma', '+91-9876501002', '1990-08-22', 'Female', 'Indian', @CountryId, @CityId_HYD, 'Plot 45, Banjara Hills', '500034', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'mohammed.ali03@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'mohammed.ali03@gmail.com', '$2a$11$HASH1234567890', 'Mohammed', 'Ali', '+91-9876501003', '1988-03-10', 'Male', 'Indian', @CountryId, @CityId_HYD, '789 Abids Circle', '500001', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'anita.reddy04@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'anita.reddy04@gmail.com', '$2a$11$HASH1234567890', 'Anita', 'Reddy', '+91-9876501004', '1992-11-05', 'Female', 'Indian', @CountryId, @CityId_HYD, '321 Madhapur', '500081', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'vikram.singh05@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'vikram.singh05@gmail.com', '$2a$11$HASH1234567890', 'Vikram', 'Singh', '+91-9876501005', '1987-07-18', 'Male', 'Indian', @CountryId, @CityId_HYD, '654 Hitech City', '500084', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'lakshmi.devi06@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'lakshmi.devi06@gmail.com', '$2a$11$HASH1234567890', 'Lakshmi', 'Devi', '+91-9876501006', '1995-02-14', 'Female', 'Indian', @CountryId, @CityId_HYD, '876 Kukatpally', '500072', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'srinivas.rao07@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'srinivas.rao07@gmail.com', '$2a$11$HASH1234567890', 'Srinivas', 'Rao', '+91-9876501007', '1983-09-25', 'Male', 'Indian', @CountryId, @CityId_HYD, '432 Ameerpet', '500016', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'kavita.patel08@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'kavita.patel08@gmail.com', '$2a$11$HASH1234567890', 'Kavita', 'Patel', '+91-9876501008', '1991-12-30', 'Female', 'Indian', @CountryId, @CityId_HYD, '234 Secunderabad', '500003', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'arjun.krishna09@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'arjun.krishna09@gmail.com', '$2a$11$HASH1234567890', 'Arjun', 'Krishna', '+91-9876501009', '1986-06-12', 'Male', 'Indian', @CountryId, @CityId_HYD, '567 Gachibowli', '500032', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'sneha.iyer10@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'sneha.iyer10@gmail.com', '$2a$11$HASH1234567890', 'Sneha', 'Iyer', '+91-9876501010', '1994-04-20', 'Female', 'Indian', @CountryId, @CityId_HYD, '890 Kondapur', '500084', 1, 1, 1, GETUTCDATE());

-- Batch 2: Users 11-30
IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'rahul.gupta11@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'rahul.gupta11@gmail.com', '$2a$11$HASH1234567890', 'Rahul', 'Gupta', '+91-9876501011', '1989-01-15', 'Male', 'Indian', @CountryId, @CityId_HYD, '123 Somajiguda', '500082', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'meera.nair12@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'meera.nair12@gmail.com', '$2a$11$HASH1234567890', 'Meera', 'Nair', '+91-9876501012', '1993-07-08', 'Female', 'Indian', @CountryId, @CityId_HYD, '456 Begumpet', '500016', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'karthik.reddy13@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'karthik.reddy13@gmail.com', '$2a$11$HASH1234567890', 'Karthik', 'Reddy', '+91-9876501013', '1984-11-22', 'Male', 'Indian', @CountryId, @CityId_HYD, '789 LB Nagar', '500074', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'divya.menon14@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'divya.menon14@gmail.com', '$2a$11$HASH1234567890', 'Divya', 'Menon', '+91-9876501014', '1996-03-17', 'Female', 'Indian', @CountryId, @CityId_HYD, '321 Dilsukhnagar', '500036', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'anil.kumar15@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'anil.kumar15@gmail.com', '$2a$11$HASH1234567890', 'Anil', 'Kumar', '+91-9876501015', '1982-09-05', 'Male', 'Indian', @CountryId, @CityId_HYD, '654 Miyapur', '500049', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'pooja.singh16@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'pooja.singh16@gmail.com', '$2a$11$HASH1234567890', 'Pooja', 'Singh', '+91-9876501016', '1997-05-28', 'Female', 'Indian', @CountryId, @CityId_HYD, '876 Uppal', '500039', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'suresh.babu17@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'suresh.babu17@gmail.com', '$2a$11$HASH1234567890', 'Suresh', 'Babu', '+91-9876501017', '1985-12-11', 'Male', 'Indian', @CountryId, @CityId_HYD, '432 Charminar', '500002', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'anjali.verma18@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'anjali.verma18@gmail.com', '$2a$11$HASH1234567890', 'Anjali', 'Verma', '+91-9876501018', '1990-08-19', 'Female', 'Indian', @CountryId, @CityId_HYD, '234 Mehdipatnam', '500028', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'naveen.reddy19@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'naveen.reddy19@gmail.com', '$2a$11$HASH1234567890', 'Naveen', 'Reddy', '+91-9876501019', '1987-02-26', 'Male', 'Indian', @CountryId, @CityId_HYD, '567 Tarnaka', '500017', 1, 1, 1, GETUTCDATE());

IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = 'swathi.rao20@gmail.com')
INSERT INTO UserManagement.Users (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
VALUES (NEWID(), 'swathi.rao20@gmail.com', '$2a$11$HASH1234567890', 'Swathi', 'Rao', '+91-9876501020', '1992-06-14', 'Female', 'Indian', @CountryId, @CityId_HYD, '890 Kompally', '500014', 1, 1, 1, GETUTCDATE());

-- Continue with remaining 80 users (21-100) in similar pattern...
-- For brevity, I'll create a pattern-based approach for the remaining users

DECLARE @Counter INT = 21;
DECLARE @Email NVARCHAR(255);
DECLARE @FirstName NVARCHAR(100);
DECLARE @LastName NVARCHAR(100);
DECLARE @Phone NVARCHAR(20);
DECLARE @Gender NVARCHAR(20);
DECLARE @Address NVARCHAR(500);
DECLARE @DOB DATE;

DECLARE @FirstNames TABLE (Name NVARCHAR(100), Gender NVARCHAR(20));
INSERT INTO @FirstNames VALUES 
('Venkat', 'Male'), ('Ramya', 'Female'), ('Harish', 'Male'), ('Nithya', 'Female'),
('Praveen', 'Male'), ('Sailaja', 'Female'), ('Ravi', 'Male'), ('Sujatha', 'Female'),
('Krishna', 'Male'), ('Madhavi', 'Female'), ('Bhaskar', 'Male'), ('Swetha', 'Female'),
('Mahesh', 'Male'), ('Keerthi', 'Female'), ('Naresh', 'Male'), ('Padma', 'Female'),
('Chandra', 'Male'), ('Bhavani', 'Female'), ('Kishore', 'Male'), ('Vasantha', 'Female'),
('Ramesh', 'Male'), ('Sowmya', 'Female'), ('Ganesh', 'Male'), ('Renuka', 'Female'),
('Prasad', 'Male'), ('Saroja', 'Female'), ('Murali', 'Male'), ('Vanaja', 'Female'),
('Satish', 'Male'), ('Lavanya', 'Female'), ('Vinod', 'Male'), ('Pushpa', 'Female'),
('Ashok', 'Male'), ('Latha', 'Female'), ('Kumar', 'Male'), ('Shanti', 'Female'),
('Mohan', 'Male'), ('Uma', 'Female'), ('Prakash', 'Male'), ('Kamala', 'Female');

DECLARE @LastNames TABLE (Name NVARCHAR(100));
INSERT INTO @LastNames VALUES 
('Reddy'), ('Naidu'), ('Goud'), ('Yadav'), ('Chowdary'), ('Varma'), ('Prasad'), ('Rao'),
('Kumar'), ('Sharma'), ('Gupta'), ('Singh'), ('Patel'), ('Iyer'), ('Menon'), ('Nair');

DECLARE @Areas TABLE (Area NVARCHAR(200), PostalCode NVARCHAR(20));
INSERT INTO @Areas VALUES
('Miyapur', '500049'), ('Kukatpally', '500072'), ('KPHB', '500072'), ('Nizampet', '500090'),
('Bachupally', '500090'), ('Patancheru', '502319'), ('Shamirpet', '500078'),
('Malkajgiri', '500047'), ('Alwal', '500010'), ('Sainikpuri', '500094'),
('AS Rao Nagar', '500062'), ('Nagole', '500035'), ('Moosarambagh', '500036'),
('Malakpet', '500024'), ('Chaderghat', '500024'), ('Koti', '500095'),
('Nampally', '500001'), ('Masab Tank', '500028'), ('Tolichowki', '500008'),
('Shaikpet', '500008'), ('Manikonda', '500089'), ('Narsingi', '500075');

-- Insert remaining users dynamically
WHILE @Counter <= 100
BEGIN
    SET @Email = 'user' + CAST(@Counter AS NVARCHAR(3)) + '@gmail.com';
    
    -- Check if already exists
    IF NOT EXISTS (SELECT 1 FROM UserManagement.Users WHERE Email = @Email)
    BEGIN
        -- Select random name components
        SELECT TOP 1 @FirstName = Name, @Gender = Gender FROM @FirstNames ORDER BY NEWID();
        SELECT TOP 1 @LastName = Name FROM @LastNames ORDER BY NEWID();
        SELECT TOP 1 @Address = '# ' + CAST(ABS(CHECKSUM(NEWID())) % 999 + 1 AS NVARCHAR) + ', ' + Area,
                     @PostalCode = PostalCode 
        FROM @Areas ORDER BY NEWID();
        
        SET @Phone = '+91-98765' + RIGHT('00000' + CAST(@Counter AS NVARCHAR(5)), 5);
        SET @DOB = DATEADD(YEAR, -(20 + ABS(CHECKSUM(NEWID())) % 40), GETUTCDATE());
        
        INSERT INTO UserManagement.Users 
        (Id, Email, PasswordHash, FirstName, LastName, Phone, DateOfBirth, Gender, Nationality, CountryId, CityId, Address, PostalCode, EmailVerified, PhoneVerified, IsActive, CreatedAt)
        VALUES 
        (NEWID(), @Email, '$2a$11$HASH1234567890', @FirstName, @LastName, @Phone, @DOB, @Gender, 'Indian', @CountryId, @CityId_HYD, @Address, @PostalCode, 1, 1, 1, GETUTCDATE());
    END
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 100 test users!';
GO
