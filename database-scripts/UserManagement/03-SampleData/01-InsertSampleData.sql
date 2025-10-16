-- =============================================
-- User Management - Sample Data
-- =============================================

USE UserManagementDb;
GO

-- =============================================
-- 1. Insert Roles
-- =============================================
DECLARE @PatientRoleId UNIQUEIDENTIFIER = NEWID();
DECLARE @DoctorRoleId UNIQUEIDENTIFIER = NEWID();
DECLARE @HospitalAdminRoleId UNIQUEIDENTIFIER = NEWID();
DECLARE @SupportRoleId UNIQUEIDENTIFIER = NEWID();

IF NOT EXISTS (SELECT 1 FROM Roles WHERE Name = 'patient')
BEGIN
    INSERT INTO Roles (Id, Name, Description)
    VALUES 
        (@PatientRoleId, 'patient', 'Patient user role'),
        (@DoctorRoleId, 'doctor', 'Doctor user role'),
        (@HospitalAdminRoleId, 'hospital_admin', 'Hospital administrator role'),
        (@SupportRoleId, 'support', 'Support team role');
    
    PRINT '✅ Roles inserted';
END
GO

-- =============================================
-- 2. Insert Permissions
-- =============================================
IF NOT EXISTS (SELECT 1 FROM Permissions WHERE Resource = 'users')
BEGIN
    INSERT INTO Permissions (Name, Resource, Action, Description)
    VALUES 
        -- User permissions
        ('View User', 'users', 'read', 'Can view user information'),
        ('Edit User', 'users', 'update', 'Can update user information'),
        ('Delete User', 'users', 'delete', 'Can delete users'),
        ('Create User', 'users', 'create', 'Can create new users'),
        
        -- Appointment permissions
        ('View Appointments', 'appointments', 'read', 'Can view appointments'),
        ('Book Appointment', 'appointments', 'create', 'Can book appointments'),
        ('Cancel Appointment', 'appointments', 'delete', 'Can cancel appointments'),
        
        -- Document permissions
        ('View Documents', 'documents', 'read', 'Can view documents'),
        ('Upload Documents', 'documents', 'create', 'Can upload documents'),
        ('Delete Documents', 'documents', 'delete', 'Can delete documents'),
        
        -- Admin permissions
        ('Manage Roles', 'roles', 'manage', 'Can manage roles and permissions'),
        ('View Audit Logs', 'audit', 'read', 'Can view audit logs');
    
    PRINT '✅ Permissions inserted';
END
GO

-- =============================================
-- 3. Assign Permissions to Roles
-- =============================================
IF NOT EXISTS (SELECT 1 FROM RolePermissions)
BEGIN
    -- Patient role permissions
    INSERT INTO RolePermissions (RoleId, PermissionId)
    SELECT 
        r.Id AS RoleId,
        p.Id AS PermissionId
    FROM Roles r
    CROSS JOIN Permissions p
    WHERE r.Name = 'patient'
      AND p.Resource IN ('users', 'appointments', 'documents')
      AND p.Action IN ('read', 'create', 'update');
    
    -- Doctor role permissions
    INSERT INTO RolePermissions (RoleId, PermissionId)
    SELECT 
        r.Id AS RoleId,
        p.Id AS PermissionId
    FROM Roles r
    CROSS JOIN Permissions p
    WHERE r.Name = 'doctor'
      AND p.Resource IN ('users', 'appointments')
      AND p.Action IN ('read', 'update');
    
    -- Hospital admin role permissions
    INSERT INTO RolePermissions (RoleId, PermissionId)
    SELECT 
        r.Id AS RoleId,
        p.Id AS PermissionId
    FROM Roles r
    CROSS JOIN Permissions p
    WHERE r.Name = 'hospital_admin';
    
    -- Support role - all permissions
    INSERT INTO RolePermissions (RoleId, PermissionId)
    SELECT 
        r.Id AS RoleId,
        p.Id AS PermissionId
    FROM Roles r
    CROSS JOIN Permissions p
    WHERE r.Name = 'support';
    
    PRINT '✅ Role permissions assigned';
END
GO

-- =============================================
-- 4. Insert Sample Users
-- =============================================
-- Password: SecurePass123! (BCrypt hashed)
DECLARE @PatientUserId UNIQUEIDENTIFIER = NEWID();
DECLARE @DoctorUserId UNIQUEIDENTIFIER = NEWID();
DECLARE @AdminUserId UNIQUEIDENTIFIER = NEWID();

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'patient@medtravel.com')
BEGIN
    INSERT INTO Users (Id, Email, PasswordHash, FirstName, LastName, Phone, Country, City, EmailVerified)
    VALUES 
        (@PatientUserId, 'patient@medtravel.com', '$2a$11$XYZ...', 'John', 'Doe', '+1-555-0100', 'USA', 'New York', 1),
        (@DoctorUserId, 'doctor@medtravel.com', '$2a$11$XYZ...', 'Dr. Rajesh', 'Kumar', '+91-9876543210', 'India', 'Hyderabad', 1),
        (@AdminUserId, 'admin@medtravel.com', '$2a$11$XYZ...', 'Admin', 'User', '+91-1234567890', 'India', 'Bangalore', 1);
    
    PRINT '✅ Sample users inserted';
END
GO

-- =============================================
-- 5. Assign Roles to Users
-- =============================================
IF NOT EXISTS (SELECT 1 FROM UserRoles)
BEGIN
    INSERT INTO UserRoles (UserId, RoleId)
    SELECT u.Id, r.Id
    FROM Users u
    CROSS JOIN Roles r
    WHERE 
        (u.Email = 'patient@medtravel.com' AND r.Name = 'patient')
        OR (u.Email = 'doctor@medtravel.com' AND r.Name = 'doctor')
        OR (u.Email = 'admin@medtravel.com' AND r.Name = 'support');
    
    PRINT '✅ User roles assigned';
END
GO

-- =============================================
-- 6. Insert Notification Templates
-- =============================================
IF NOT EXISTS (SELECT 1 FROM NotificationTemplates)
BEGIN
    INSERT INTO NotificationTemplates (Name, Type, Channel, Subject, Body)
    VALUES 
        ('AppointmentConfirmation', 'appointment', 'email', 
         'Appointment Confirmed', 
         'Your appointment with {DoctorName} on {AppointmentDate} at {AppointmentTime} has been confirmed.'),
        
        ('AppointmentReminder', 'appointment', 'sms', 
         NULL, 
         'Reminder: You have an appointment with {DoctorName} tomorrow at {AppointmentTime}.'),
        
        ('TravelReminder', 'travel', 'push', 
         'Travel Reminder', 
         'Your flight {FlightNumber} departs in 24 hours. Please check in online.'),
        
        ('WelcomeEmail', 'account', 'email', 
         'Welcome to MedTravel', 
         'Dear {FirstName}, welcome to MedTravel platform. Start exploring healthcare options today!');
    
    PRINT '✅ Notification templates inserted';
END
GO

-- =============================================
-- 7. Insert Sample Preferences
-- =============================================
IF NOT EXISTS (SELECT 1 FROM UserPreferences)
BEGIN
    INSERT INTO UserPreferences (UserId, PreferredLanguage, PreferredCurrency, EmailNotifications, SmsNotifications)
    SELECT 
        Id,
        CASE 
            WHEN Country = 'India' THEN 'hi'
            ELSE 'en'
        END,
        CASE 
            WHEN Country = 'India' THEN 'INR'
            ELSE 'USD'
        END,
        1,
        1
    FROM Users;
    
    PRINT '✅ User preferences inserted';
END
GO

PRINT 'User Management sample data inserted successfully';
GO
