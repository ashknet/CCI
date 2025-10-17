-- =============================================
-- Insert User Roles and Preferences
-- =============================================

PRINT 'Inserting User Roles and Preferences...';

-- Get role IDs
DECLARE @PatientRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'patient');
DECLARE @DoctorRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'doctor');
DECLARE @AdminRoleId UNIQUEIDENTIFIER = (SELECT Id FROM UserManagement.Roles WHERE Name = 'hospital_admin');

-- If roles don't exist, create them
IF @PatientRoleId IS NULL
BEGIN
    SET @PatientRoleId = NEWID();
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@PatientRoleId, 'patient', 'Patient role', GETUTCDATE(), GETUTCDATE());
END

IF @DoctorRoleId IS NULL
BEGIN
    SET @DoctorRoleId = NEWID();
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@DoctorRoleId, 'doctor', 'Doctor role', GETUTCDATE(), GETUTCDATE());
END

IF @AdminRoleId IS NULL
BEGIN
    SET @AdminRoleId = NEWID();
    INSERT INTO UserManagement.Roles (Id, Name, Description, CreatedAt, UpdatedAt)
    VALUES (@AdminRoleId, 'hospital_admin', 'Hospital administrator role', GETUTCDATE(), GETUTCDATE());
END

-- Assign patient role to all users
INSERT INTO UserManagement.UserRoles (UserId, RoleId, CreatedAt)
SELECT u.Id, @PatientRoleId, GETUTCDATE()
FROM UserManagement.Users u
WHERE NOT EXISTS (SELECT 1 FROM UserManagement.UserRoles ur WHERE ur.UserId = u.Id AND ur.RoleId = @PatientRoleId);

-- Insert user preferences for all users
INSERT INTO UserManagement.UserPreferences (Id, UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, SmsNotifications, PushNotifications, TimeZone, CreatedAt, UpdatedAt)
SELECT NEWID(), u.Id, 'en', 'INR', 1, 1, 1, 'Asia/Kolkata', GETUTCDATE(), GETUTCDATE()
FROM UserManagement.Users u
WHERE NOT EXISTS (SELECT 1 FROM UserManagement.UserPreferences up WHERE up.UserId = u.Id);

PRINT 'Successfully inserted user roles and preferences!';
GO
