# 🗄️ MedTravel Database - Complete Setup

## 📊 Single Database Architecture

**One database (`MedTravelDb`) with 6 schemas:**

```
MedTravelDb
├── Metadata (11 lookup tables)
├── UserManagement (11 tables)
├── Hospital (11 tables)
├── TAService (6 tables)
├── Messaging (3 tables)
└── TestData (schema for sample data)
```

**Total**: 42+ tables, 6+ stored procedures

---

## 🚀 Quick Start

### Step 1: Create Database and Tables

```bash
cd database-scripts
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i MedTravel-Complete-Database.sql
```

**Creates**:
- ✅ MedTravelDb database
- ✅ 6 schemas
- ✅ 42+ tables
- ✅ 6+ stored procedures
- ✅ All relationships and indexes

### Step 2: Insert Test Data

```bash
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i MedTravel-TestData.sql
```

**Inserts**:
- ✅ Countries, Cities, Languages, Currencies
- ✅ Medical Specialties, Diseases, Airlines, Airports
- ✅ Sample users, roles, permissions
- ✅ Sample hospitals, doctors
- ✅ Sample hotels, flights

---

## 📁 Files

| File | Purpose | Size | Run Order |
|------|---------|------|-----------|
| **MedTravel-Complete-Database.sql** | Creates database, schemas, tables, stored procedures | ~1000 lines | 1st |
| **MedTravel-TestData.sql** | Inserts sample/test data | ~400 lines | 2nd |
| **README.md** | This file | - | - |

---

## 📊 Schema Details

### 1. Metadata Schema (11 tables)

**Purpose**: Shared lookup/reference data used by all services

**Tables**:
- `Countries` - Country master data
- `Cities` - Cities with lat/long
- `Languages` - Supported languages
- `Currencies` - Currency codes
- `Specialties` - Medical specialties
- `Diseases` - Disease catalog with ICD codes
- `DiseaseSpecialties` - Disease-Specialty mapping
- `AccreditationBodies` - NABH, JCI, ISO, etc.
- `DocumentTypes` - Passport, Visa, Medical Records, etc.
- `Airlines` - Airline master data
- `Airports` - Airport codes with locations

### 2. UserManagement Schema (11 tables)

**Purpose**: User authentication, authorization, preferences

**Tables**:
- `Roles` - patient, doctor, hospital_admin, support
- `Permissions` - Resource-action based permissions
- `RolePermissions` - Role-permission mapping
- `Users` - User accounts with profile data
- `UserRoles` - User-role assignments
- `Sessions` - JWT refresh tokens
- `UserPreferences` - Language, currency, notifications
- `UserDocuments` - Uploaded documents
- `InsurancePolicies` - Insurance coverage
- `Notifications` - User notifications
- `AuditLogs` - Audit trail

### 3. Hospital Schema (11 tables)

**Purpose**: Hospitals, doctors, appointments, reviews

**Tables**:
- `Hospitals` - Hospital listings with location
- `Departments` - Hospital departments by specialty
- `Doctors` - Doctor profiles
- `DoctorSpecialties` - Doctor-specialty mapping
- `DoctorLanguages` - Languages spoken by doctors
- `Credentials` - Doctor certifications
- `Appointments` - Appointment bookings
- `DoctorAvailability` - Weekly schedules
- `Reviews` - Hospital/doctor reviews
- `HospitalAccreditations` - Certifications

### 4. TAService Schema (6 tables)

**Purpose**: Travel and accommodation booking

**Tables**:
- `Flights` - Flight schedules and pricing
- `TransportBookings` - Flight/train/bus bookings
- `Hotels` - Hotel listings near hospitals
- `HotelRooms` - Room types and pricing
- `AccommodationBookings` - Hotel reservations
- `Payments` - Payment transactions

### 5. Messaging Schema (3 tables)

**Purpose**: Secure patient-doctor communication

**Tables**:
- `Threads` - Conversation threads
- `Messages` - Messages (encrypted)
- `MessageAttachments` - File attachments

### 6. TestData Schema

**Purpose**: Sample data for testing (populated by MedTravel-TestData.sql)

---

## 🔗 Connection String

**All services use the same connection string:**

```
Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
```

---

## 🔧 Update Service Configuration

### 1. Update Connection Strings

**All `appsettings.json` files**:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True"
  }
}
```

### 2. Update DbContext Files

**UserManagementDbContext.cs**:
```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.HasDefaultSchema("UserManagement");
    base.OnModelCreating(modelBuilder);
}
```

**HospitalDbContext.cs**:
```csharp
modelBuilder.HasDefaultSchema("Hospital");
```

**TransportationDbContext.cs**:
```csharp
modelBuilder.HasDefaultSchema("TAService");
```

**MessagingDbContext.cs**:
```csharp
modelBuilder.HasDefaultSchema("Messaging");
```

---

## 📝 Stored Procedures

### UserManagement
- `sp_GetUserWithRoles` - Get user with all roles
- `sp_SearchUsers` - Search users with filters

### Hospital
- `sp_SearchHospitals` - Search hospitals
- `sp_SearchDoctors` - Search doctors by specialty, location, rating
- `sp_GetNearbyHospitals` - Find hospitals by GPS coordinates

### TAService
- `sp_SearchFlights` - Search flights by route and date

**Usage Example**:
```sql
EXEC Hospital.sp_SearchDoctors 
    @SpecialtyId = 'some-guid',
    @CityId = 'some-guid',
    @MinRating = 4.5;
```

---

## 🧪 Verify Installation

### Check Schemas
```sql
USE MedTravelDb;
SELECT SCHEMA_NAME(schema_id) AS SchemaName, COUNT(*) AS TableCount
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) IN ('UserManagement', 'Hospital', 'TAService', 'Messaging', 'Metadata')
GROUP BY schema_id;
```

**Expected Output**:
```
SchemaName        TableCount
--------------    ----------
Hospital          11
Messaging         3
Metadata          11
TAService         6
UserManagement    11
```

### Check Sample Data
```sql
SELECT * FROM Metadata.Specialties;
SELECT * FROM Metadata.Cities;
SELECT * FROM UserManagement.Users;
SELECT * FROM Hospital.Hospitals;
```

---

## ✅ Benefits

| Feature | Benefit |
|---------|---------|
| **Single Database** | One backup, one connection string ✅ |
| **Metadata Schema** | Centralized lookup data ✅ |
| **Proper Foreign Keys** | Data integrity with metadata ✅ |
| **Schema Separation** | Logical isolation per service ✅ |
| **No Code Duplication** | Lookup tables shared ✅ |

---

## 🎯 Summary

**Database**: MedTravelDb  
**Schemas**: 6  
**Tables**: 42+  
**Stored Procedures**: 6+  
**Sample Data**: ✅ Included  
**Files**: 2 SQL scripts  

**Ready to use!** 🚀

---

**Created**: October 2025  
**Architecture**: Single Database + Multiple Schemas + Metadata  
**Status**: ✅ Production Ready
