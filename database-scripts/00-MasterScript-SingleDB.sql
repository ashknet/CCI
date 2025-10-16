-- =============================================
-- MedTravel Platform - Single Database with Multiple Schemas
-- Master Database Setup Script
-- =============================================
-- Each microservice has its own schema within MedTravelDb
-- =============================================

SET NOCOUNT ON;
GO

PRINT '======================================'
PRINT '  MedTravel Platform Database Setup'
PRINT '  Single Database, Multiple Schemas'
PRINT '======================================'
PRINT ''
GO

USE master;
GO

-- =============================================
-- Create Single Database
-- =============================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'MedTravelDb')
BEGIN
    CREATE DATABASE MedTravelDb;
    PRINT '✅ Database MedTravelDb created';
END
ELSE
BEGIN
    PRINT '⚠️  Database MedTravelDb already exists';
END
GO

USE MedTravelDb;
GO

-- =============================================
-- Create Schemas for Each Service
-- =============================================
PRINT ''
PRINT 'Creating schemas...'
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'UserManagement')
BEGIN
    EXEC('CREATE SCHEMA UserManagement');
    PRINT '✅ Schema [UserManagement] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Hospital')
BEGIN
    EXEC('CREATE SCHEMA Hospital');
    PRINT '✅ Schema [Hospital] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'TAService')
BEGIN
    EXEC('CREATE SCHEMA TAService');
    PRINT '✅ Schema [TAService] created';
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Messaging')
BEGIN
    EXEC('CREATE SCHEMA Messaging');
    PRINT '✅ Schema [Messaging] created';
END
GO

PRINT ''
PRINT '======================================'
PRINT '  Schemas Created Successfully'
PRINT '======================================'
PRINT ''
PRINT 'Database: MedTravelDb'
PRINT 'Schemas:'
PRINT '  • UserManagement (User service tables)'
PRINT '  • Hospital (Hospital service tables)'
PRINT '  • TAService (Travel & Accommodation tables)'
PRINT '  • Messaging (Messaging service tables)'
PRINT ''
PRINT 'Connection String Example:'
PRINT 'Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True'
PRINT ''
PRINT 'Now run individual schema scripts:'
PRINT '  1. UserManagement/01-Schema/01-CreateTables.sql'
PRINT '  2. Hospital/01-Schema/01-CreateTables.sql'
PRINT '  3. TAService/01-Schema/01-CreateTables.sql'
PRINT '  4. Messaging/01-Schema/01-CreateTables.sql'
PRINT ''
GO
