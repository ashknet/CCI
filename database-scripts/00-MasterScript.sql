-- =============================================
-- MedTravel Platform - Master Database Setup Script
-- =============================================
-- This script creates all databases, tables, stored procedures, and sample data
-- Run this script on SQL Server instance to setup the complete database
-- =============================================

SET NOCOUNT ON;
GO

PRINT '======================================'
PRINT '  MedTravel Platform Database Setup'
PRINT '======================================'
PRINT ''
GO

-- =============================================
-- 1. USER MANAGEMENT DATABASE
-- =============================================
PRINT '1. Creating User Management Database...'
:r UserManagement/01-Schema/01-CreateTables.sql
:r UserManagement/02-StoredProcedures/01-UserProcedures.sql
:r UserManagement/03-SampleData/01-InsertSampleData.sql
PRINT '✅ User Management Database complete'
PRINT ''
GO

-- =============================================
-- 2. HOSPITAL SERVICE DATABASE
-- =============================================
PRINT '2. Creating Hospital Service Database...'
:r Hospital/01-Schema/01-CreateTables.sql
:r Hospital/02-StoredProcedures/01-SearchProcedures.sql
:r Hospital/03-SampleData/01-InsertSampleData.sql
PRINT '✅ Hospital Service Database complete'
PRINT ''
GO

-- =============================================
-- 3. TASERVICE DATABASE
-- =============================================
PRINT '3. Creating TAService Database...'
:r TAService/01-Schema/01-CreateTables.sql
:r TAService/02-StoredProcedures/01-BookingProcedures.sql
:r TAService/03-SampleData/01-InsertSampleData.sql
PRINT '✅ TAService Database complete'
PRINT ''
GO

-- =============================================
-- 4. MESSAGING SERVICE DATABASE
-- =============================================
PRINT '4. Creating Messaging Service Database...'
:r Messaging/01-Schema/01-CreateTables.sql
PRINT '✅ Messaging Service Database complete'
PRINT ''
GO

PRINT '======================================'
PRINT '  Database Setup Complete!'
PRINT '======================================'
PRINT ''
PRINT 'Summary:'
PRINT '  ✅ UserManagementDb - 13 tables, 8 stored procedures'
PRINT '  ✅ HospitalDb - 15 tables, 7 stored procedures'
PRINT '  ✅ TAServiceDb - 8 tables, 4 stored procedures'
PRINT '  ✅ MessagingDb - 4 tables'
PRINT ''
PRINT 'Total: 40 tables, 19 stored procedures'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Update connection strings in appsettings.json'
PRINT '  2. Test API connections'
PRINT '  3. Run services with: docker-compose up'
PRINT ''
GO
