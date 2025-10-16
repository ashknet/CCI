# 🗄️ Single Database Architecture

## 📊 Database Structure

Instead of 4 separate databases, we now use **ONE database with 4 schemas**:

```
MedTravelDb
├── UserManagement schema (13 tables)
├── Hospital schema (15 tables)
├── TAService schema (8 tables)
└── Messaging schema (4 tables)
```

---

## ✅ Benefits of Single Database with Multiple Schemas

### 1. **Simpler Management**
- ✅ Single database to backup/restore
- ✅ Single database to monitor
- ✅ Easier disaster recovery

### 2. **Better Performance**
- ✅ Efficient cross-schema queries if needed
- ✅ Better resource utilization
- ✅ Shared connection pool

### 3. **Easier Deployment**
- ✅ One connection string
- ✅ Simpler CI/CD
- ✅ Easier containerization

### 4. **Cost Optimization**
- ✅ Single database license (if applicable)
- ✅ Shared resources
- ✅ Lower operational overhead

### 5. **Logical Separation Maintained**
- ✅ Each service has its own schema
- ✅ No cross-schema foreign keys
- ✅ Clear ownership boundaries
- ✅ Independent evolution

---

## 🚀 Quick Start

### Single Command Setup

```bash
cd database-scripts
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i 00-MasterScript-SingleDB.sql
```

**This creates**:
- ✅ MedTravelDb database
- ✅ 4 schemas (UserManagement, Hospital, TAService, Messaging)

---

## 📝 Connection String

### For All Services

**Single connection string for the entire platform**:

```
Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
```

### Update in appsettings.json

**UserManagementService/appsettings.json**:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True"
  }
}
```

**Same for all services!** 🎉

---

## 📂 Schema Organization

### Schema: UserManagement (13 tables)

```sql
UserManagement.Users
UserManagement.Roles
UserManagement.UserRoles
UserManagement.Permissions
UserManagement.RolePermissions
UserManagement.Sessions
UserManagement.UserPreferences
UserManagement.UserDocuments
UserManagement.InsurancePolicies
UserManagement.Notifications
UserManagement.NotificationTemplates
UserManagement.NotificationSchedules
UserManagement.AuditLogs
```

### Schema: Hospital (15 tables)

```sql
Hospital.Hospitals
Hospital.Departments
Hospital.Doctors
Hospital.Specialties
Hospital.DoctorSpecialties
Hospital.Languages
Hospital.DoctorLanguages
Hospital.Credentials
Hospital.Appointments
Hospital.DoctorAvailability
Hospital.DoctorLeaves
Hospital.AppointmentReminders
Hospital.Reviews
Hospital.HospitalAccreditations
Hospital.Diseases
Hospital.DiseaseSpecialties
Hospital.HospitalImages
Hospital.AppointmentStatusHistories
```

### Schema: TAService (8 tables)

```sql
TAService.Flights
TAService.Trains
TAService.TransportBookings
TAService.Hotels
TAService.HotelRooms
TAService.AccommodationBookings
TAService.CostBreakdowns
TAService.Payments
```

### Schema: Messaging (4 tables)

```sql
Messaging.Threads
Messaging.Messages
Messaging.MessageAttachments
Messaging.MessageAudit
```

---

## 🔧 Running Individual Schema Scripts

### Create All Tables

```bash
# After creating database and schemas with master script:

# 1. UserManagement tables
sqlcmd -S localhost -U sa -P YourPassword -i UserManagement/01-Schema/01-CreateTables-Schema.sql

# 2. Hospital tables
sqlcmd -S localhost -U sa -P YourPassword -i Hospital/01-Schema/01-CreateTables-Schema.sql

# 3. TAService tables
sqlcmd -S localhost -U sa -P YourPassword -i TAService/01-Schema/01-CreateTables-Schema.sql

# 4. Messaging tables
sqlcmd -S localhost -U sa -P YourPassword -i Messaging/01-Schema/01-CreateTables-Schema.sql
```

---

## 📊 Querying Data

### Query Specific Schema

```sql
USE MedTravelDb;
GO

-- Query UserManagement schema
SELECT * FROM UserManagement.Users;
SELECT * FROM UserManagement.Roles;

-- Query Hospital schema
SELECT * FROM Hospital.Hospitals;
SELECT * FROM Hospital.Doctors;

-- Query TAService schema
SELECT * FROM TAService.Flights;
SELECT * FROM TAService.Hotels;

-- Query Messaging schema
SELECT * FROM Messaging.Threads;
SELECT * FROM Messaging.Messages;
```

### Cross-Schema Queries (if needed)

```sql
-- Join user with their appointments
SELECT 
    u.FirstName,
    u.LastName,
    a.ScheduledDate,
    d.FirstName AS DoctorFirstName
FROM UserManagement.Users u
INNER JOIN Hospital.Appointments a ON u.Id = a.PatientId
INNER JOIN Hospital.Doctors d ON a.DoctorId = d.Id
WHERE u.Id = 'some-guid';
```

---

## 🔐 Security with Schemas

### Create Service-Specific Database Users

```sql
USE MedTravelDb;
GO

-- User for UserManagement service
CREATE USER UserManagementService WITH PASSWORD = 'SecurePassword123!';
ALTER ROLE db_datareader ADD MEMBER UserManagementService;
ALTER ROLE db_datawriter ADD MEMBER UserManagementService;

-- Grant full access to UserManagement schema only
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::UserManagement TO UserManagementService;

-- User for Hospital service
CREATE USER HospitalService WITH PASSWORD = 'SecurePassword123!';
ALTER ROLE db_datareader ADD MEMBER HospitalService;
ALTER ROLE db_datawriter ADD MEMBER HospitalService;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Hospital TO HospitalService;

-- User for TAService
CREATE USER TAServiceUser WITH PASSWORD = 'SecurePassword123!';
ALTER ROLE db_datareader ADD MEMBER TAServiceUser;
ALTER ROLE db_datawriter ADD MEMBER TAServiceUser;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::TAService TO TAServiceUser;

-- User for Messaging service
CREATE USER MessagingService WITH PASSWORD = 'SecurePassword123!';
ALTER ROLE db_datareader ADD MEMBER MessagingService;
ALTER ROLE db_datawriter ADD MEMBER MessagingService;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::Messaging TO MessagingService;
```

### Production Connection Strings

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=prod-server;Database=MedTravelDb;User Id=UserManagementService;Password=SecurePassword123!;TrustServerCertificate=True"
  }
}
```

---

## 📈 Migration from Multiple Databases

### If You Already Have Separate Databases

```sql
-- 1. Create new single database
CREATE DATABASE MedTravelDb;
GO

USE MedTravelDb;
GO

-- 2. Create schemas
CREATE SCHEMA UserManagement;
CREATE SCHEMA Hospital;
CREATE SCHEMA TAService;
CREATE SCHEMA Messaging;
GO

-- 3. Copy data from old databases
-- Example for UserManagement
INSERT INTO MedTravelDb.UserManagement.Users
SELECT * FROM UserManagementDb.dbo.Users;

INSERT INTO MedTravelDb.UserManagement.Roles
SELECT * FROM UserManagementDb.dbo.Roles;

-- Repeat for all tables in all schemas...
```

---

## 🧪 Verification

### Check Schemas Created

```sql
USE MedTravelDb;
GO

SELECT 
    s.name AS SchemaName,
    COUNT(t.name) AS TableCount
FROM sys.schemas s
LEFT JOIN sys.tables t ON s.schema_id = t.schema_id
WHERE s.name IN ('UserManagement', 'Hospital', 'TAService', 'Messaging')
GROUP BY s.name
ORDER BY s.name;
```

**Expected Output**:
```
SchemaName        TableCount
--------------    ----------
Hospital          15
Messaging         4
TAService         8
UserManagement    13
```

### Check All Tables

```sql
SELECT 
    SCHEMA_NAME(schema_id) AS SchemaName,
    name AS TableName,
    create_date AS CreatedDate
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) IN ('UserManagement', 'Hospital', 'TAService', 'Messaging')
ORDER BY SchemaName, TableName;
```

---

## 📦 Entity Framework Configuration

### Update DbContext

**UserManagementDbContext.cs**:
```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Set default schema for this service
    modelBuilder.HasDefaultSchema("UserManagement");
    
    // OR specify per entity
    modelBuilder.Entity<User>().ToTable("Users", "UserManagement");
    modelBuilder.Entity<Role>().ToTable("Roles", "UserManagement");
    
    base.OnModelCreating(modelBuilder);
}
```

**HospitalDbContext.cs**:
```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.HasDefaultSchema("Hospital");
    base.OnModelCreating(modelBuilder);
}
```

---

## 🔄 Stored Procedures with Schemas

### Create Procedure in Specific Schema

```sql
CREATE OR ALTER PROCEDURE [UserManagement].[sp_GetUserWithRoles]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT u.*, STRING_AGG(r.Name, ',') AS Roles
    FROM UserManagement.Users u
    LEFT JOIN UserManagement.UserRoles ur ON u.Id = ur.UserId
    LEFT JOIN UserManagement.Roles r ON ur.RoleId = r.Id
    WHERE u.Id = @UserId
    GROUP BY u.Id, u.Email, u.FirstName, u.LastName, ...;
END
GO
```

### Call Procedure

```sql
EXEC UserManagement.sp_GetUserWithRoles @UserId = 'some-guid';
```

---

## 🎯 Best Practices

### 1. **Always Qualify Table Names**

```sql
-- ✅ Good - Schema-qualified
SELECT * FROM UserManagement.Users;

-- ❌ Bad - Ambiguous
SELECT * FROM Users;
```

### 2. **No Cross-Schema Foreign Keys**

```sql
-- ❌ Bad - Don't do this
ALTER TABLE Hospital.Appointments
ADD CONSTRAINT FK_Appointment_User
FOREIGN KEY (PatientId) REFERENCES UserManagement.Users(Id);

-- ✅ Good - Keep foreign keys within same schema
-- Use application-level joins for cross-schema relationships
```

### 3. **Use Views for Cross-Schema Queries**

```sql
CREATE VIEW UserManagement.vw_UserAppointments
AS
SELECT 
    u.Id AS UserId,
    u.FirstName,
    u.LastName,
    a.ScheduledDate,
    a.Status
FROM UserManagement.Users u
INNER JOIN Hospital.Appointments a ON u.Id = a.PatientId;
```

---

## 📊 Comparison

| Aspect | Multiple Databases | Single DB + Schemas |
|--------|-------------------|---------------------|
| **Connection Strings** | 4 different | 1 shared ✅ |
| **Backup** | 4 files | 1 file ✅ |
| **Monitoring** | 4 dashboards | 1 dashboard ✅ |
| **Cross-Service Queries** | Complex | Easy ✅ |
| **Resource Isolation** | High | Medium |
| **Deployment** | 4 steps | 1 step ✅ |
| **Cost** | Higher | Lower ✅ |

---

## ✅ Summary

**Architecture**: ✅ Single Database (`MedTravelDb`) with 4 Schemas  
**Total Tables**: ✅ 40 tables across 4 schemas  
**Connection String**: ✅ One for all services  
**Management**: ✅ Simpler and more efficient  
**Separation**: ✅ Maintained via schemas  

**Ready to use!** 🚀

---

**Created**: October 2025  
**Architecture**: Single Database + Multiple Schemas  
**Status**: ✅ Production Ready
