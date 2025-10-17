-- =============================================
-- Execute All Test Data Scripts
-- =============================================

PRINT '========================================';
PRINT 'Starting Comprehensive Test Data Insertion';
PRINT '========================================';
PRINT '';

-- Execute all test data scripts in order
PRINT 'Step 1: Inserting 30 Medical Specialties...';
:r "03-Insert-Specialties-30.sql"

PRINT 'Step 2: Inserting 100 Test Users...';
:r "01-Insert-Users-100.sql"

PRINT 'Step 3: Inserting 50 Hyderabad Hospitals...';
:r "02-Insert-Hospitals-50.sql"

PRINT 'Step 4: Inserting 150 Doctors...';
:r "04-Insert-Doctors-150.sql"

PRINT 'Step 5: Inserting User Roles and Preferences...';
:r "10-Insert-UserRoles-Preferences.sql"

PRINT 'Step 6: Inserting 200 Appointments...';
:r "05-Insert-Appointments-200.sql"

PRINT 'Step 7: Inserting 150 Reviews...';
:r "06-Insert-Reviews-150.sql"

PRINT 'Step 8: Inserting 100 Message Threads...';
:r "07-Insert-MessageThreads-100.sql"

PRINT 'Step 9: Inserting 500 Messages...';
:r "08-Insert-Messages-500.sql"

PRINT 'Step 10: Inserting 50 Hotels...';
:r "09-Insert-Hotels-50.sql"

PRINT '';
PRINT '========================================';
PRINT 'TEST DATA INSERTION COMPLETE!';
PRINT '========================================';
PRINT '';
PRINT 'Summary of inserted data:';
PRINT '  ✓ 30 Medical Specialties';
PRINT '  ✓ 100 Test Users (Patients)';
PRINT '  ✓ 50 Hyderabad Hospitals';
PRINT '  ✓ 150 Doctors across hospitals';
PRINT '  ✓ 200 Appointments (various statuses)';
PRINT '  ✓ 150 Reviews (hospitals and doctors)';
PRINT '  ✓ 100 Message Threads';
PRINT '  ✓ 500 Messages in threads';
PRINT '  ✓ 50 Hotels in Hyderabad';
PRINT '  ✓ User roles and preferences';
PRINT '';
PRINT 'All data uses proper foreign keys from metadata tables.';
PRINT 'Ready for comprehensive testing!';
PRINT '';

-- Display summary statistics
SELECT 
    'Users' AS Entity, COUNT(*) AS Count FROM UserManagement.Users
UNION ALL
SELECT 'Hospitals', COUNT(*) FROM Hospital.Hospitals
UNION ALL
SELECT 'Doctors', COUNT(*) FROM Hospital.Doctors
UNION ALL
SELECT 'Appointments', COUNT(*) FROM Hospital.Appointments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Hospital.Reviews
UNION ALL
SELECT 'Message Threads', COUNT(*) FROM Messaging.Threads
UNION ALL
SELECT 'Messages', COUNT(*) FROM Messaging.Messages
UNION ALL
SELECT 'Hotels', COUNT(*) FROM TAService.Hotels
UNION ALL
SELECT 'Specialties', COUNT(*) FROM Metadata.Specialties;

GO
