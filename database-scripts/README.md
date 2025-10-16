# MedTravel Platform - Database Scripts

Complete SQL scripts for creating all databases, tables, stored procedures, and sample data.

---

## 📁 Folder Structure

```
database-scripts/
├── 00-MasterScript.sql           ← Run this to create everything
├── README.md                      ← This file
│
├── UserManagement/
│   ├── 01-Schema/
│   │   └── 01-CreateTables.sql   ← 13 tables
│   ├── 02-StoredProcedures/
│   │   └── 01-UserProcedures.sql ← 8 stored procedures
│   └── 03-SampleData/
│       └── 01-InsertSampleData.sql ← Sample users, roles, permissions
│
├── Hospital/
│   ├── 01-Schema/
│   │   └── 01-CreateTables.sql   ← 15 tables
│   ├── 02-StoredProcedures/
│   │   └── 01-SearchProcedures.sql ← 7 stored procedures
│   └── 03-SampleData/
│       └── 01-InsertSampleData.sql ← Hospitals, doctors, specialties
│
├── TAService/
│   ├── 01-Schema/
│   │   └── 01-CreateTables.sql   ← 8 tables
│   ├── 02-StoredProcedures/
│   │   └── 01-BookingProcedures.sql ← 4 stored procedures
│   └── 03-SampleData/
│       └── 01-InsertSampleData.sql ← Flights, trains, hotels
│
└── Messaging/
    ├── 01-Schema/
    │   └── 01-CreateTables.sql   ← 4 tables
    └── 02-StoredProcedures/       (Coming soon)
```

---

## 🗄️ Databases Created

| Database | Tables | Stored Procedures | Sample Data |
|----------|--------|-------------------|-------------|
| **UserManagementDb** | 13 | 8 | ✅ Users, Roles, Permissions |
| **HospitalDb** | 15 | 7 | ✅ Hospitals, Doctors, Specialties |
| **TAServiceDb** | 8 | 4 | ✅ Flights, Trains, Hotels |
| **MessagingDb** | 4 | 0 | ❌ (No sample data needed) |
| **TOTAL** | **40** | **19** | **3 databases** |

---

## 🚀 Quick Start

### Option 1: Run Master Script (Recommended)

**SQL Server Management Studio (SSMS)**:
1. Open SSMS
2. Connect to your SQL Server instance
3. Open `00-MasterScript.sql`
4. Press F5 to execute

**Command Line (sqlcmd)**:
```bash
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i 00-MasterScript.sql
```

**Azure Data Studio**:
1. Open Azure Data Studio
2. Connect to SQL Server
3. Open `00-MasterScript.sql`
4. Click "Run" or press F5

### Option 2: Run Individual Scripts

**Create Each Database Separately**:

```bash
# User Management
sqlcmd -S localhost -U sa -P YourPassword -i UserManagement/01-Schema/01-CreateTables.sql
sqlcmd -S localhost -U sa -P YourPassword -i UserManagement/02-StoredProcedures/01-UserProcedures.sql
sqlcmd -S localhost -U sa -P YourPassword -i UserManagement/03-SampleData/01-InsertSampleData.sql

# Hospital
sqlcmd -S localhost -U sa -P YourPassword -i Hospital/01-Schema/01-CreateTables.sql
sqlcmd -S localhost -U sa -P YourPassword -i Hospital/02-StoredProcedures/01-SearchProcedures.sql
sqlcmd -S localhost -U sa -P YourPassword -i Hospital/03-SampleData/01-InsertSampleData.sql

# TAService
sqlcmd -S localhost -U sa -P YourPassword -i TAService/01-Schema/01-CreateTables.sql
sqlcmd -S localhost -U sa -P YourPassword -i TAService/02-StoredProcedures/01-BookingProcedures.sql
sqlcmd -S localhost -U sa -P YourPassword -i TAService/03-SampleData/01-InsertSampleData.sql

# Messaging
sqlcmd -S localhost -U sa -P YourPassword -i Messaging/01-Schema/01-CreateTables.sql
```

### Option 3: Use Docker Compose (Automatic)

The Entity Framework migrations will automatically create the schema when you run:

```bash
docker-compose up
```

---

## 📋 Database Schemas

### UserManagementDb (13 Tables)

| Table | Purpose | Key Features |
|-------|---------|--------------|
| Users | User accounts | Email unique, password hash, profile info |
| Roles | User roles | patient, doctor, hospital_admin, support |
| UserRoles | User-Role mapping | Many-to-many relationship |
| Permissions | System permissions | Resource-action based |
| RolePermissions | Role-Permission mapping | Many-to-many relationship |
| Sessions | JWT refresh tokens | Refresh token management |
| UserPreferences | User settings | Language, currency, notifications |
| UserDocuments | Document storage | Passport, medical records |
| InsurancePolicies | Insurance info | Coverage details |
| Notifications | User notifications | Email, SMS, push |
| NotificationTemplates | Reusable templates | Dynamic content |
| NotificationSchedules | Scheduled notifications | Future notifications |
| AuditLogs | Audit trail | All user actions |

### HospitalDb (15 Tables)

| Table | Purpose | Key Features |
|-------|---------|--------------|
| Hospitals | Hospital listings | Location, ratings, capacity |
| Departments | Hospital departments | Cardiology, Orthopedics, etc. |
| Doctors | Doctor profiles | Qualifications, experience, fees |
| Specialties | Medical specialties | Cardiology, Neurology, etc. |
| DoctorSpecialties | Doctor-Specialty mapping | Many-to-many |
| Languages | Spoken languages | English, Hindi, Telugu, etc. |
| DoctorLanguages | Doctor-Language mapping | Many-to-many |
| Credentials | Doctor credentials | Licenses, certifications |
| Appointments | Appointment bookings | Schedule, status, payments |
| DoctorAvailability | Doctor schedules | Weekly availability |
| DoctorLeaves | Leave management | Dates doctor is unavailable |
| AppointmentReminders | Reminder scheduling | Email, SMS, push |
| Reviews | Hospital/doctor reviews | Ratings and comments |
| HospitalAccreditations | Certifications | NABH, JCI, etc. |
| Diseases | Disease catalog | ICD codes, treatment costs |

### TAServiceDb (8 Tables)

| Table | Purpose | Key Features |
|-------|---------|--------------|
| Flights | Flight availability | International & domestic |
| Trains | Train schedules | IRCTC integration ready |
| TransportBookings | Transport reservations | Flights, trains, buses |
| Hotels | Hotel listings | Near hospitals, amenities |
| HotelRooms | Room inventory | Types, pricing, availability |
| AccommodationBookings | Hotel reservations | Check-in/out, guests |
| CostBreakdowns | Cost estimates | Medical + Travel + Stay |
| Payments | Payment records | Transactions, refunds |

### MessagingDb (4 Tables)

| Table | Purpose | Key Features |
|-------|---------|--------------|
| Threads | Conversation threads | Patient-doctor communication |
| Messages | Individual messages | Encrypted content |
| MessageAttachments | File attachments | Medical reports, images |
| MessageAudit | Audit trail | Message delivery tracking |

---

## 🔧 Stored Procedures

### User Management (8 SPs)

| Procedure | Purpose | Parameters |
|-----------|---------|------------|
| `sp_GetUserWithRoles` | Get user with role list | @UserId |
| `sp_SearchUsers` | Search users with filters | @SearchTerm, @Country, @City, @PageNumber, @PageSize |
| `sp_CreateUserWithRole` | Register user with role | @Email, @PasswordHash, @FirstName, @LastName, @RoleName |
| `sp_UpdateLastLogin` | Update last login time | @UserId, @IpAddress |
| `sp_GetUserNotifications` | Get user notifications | @UserId, @UnreadOnly, @PageNumber, @PageSize |
| `sp_MarkNotificationsAsRead` | Mark notifications read | @UserId, @NotificationIds |
| `sp_GetUserSpendSummary` | Get spending summary | @UserId |
| `sp_CleanupExpiredSessions` | Remove expired sessions | None |

### Hospital Service (7 SPs)

| Procedure | Purpose | Parameters |
|-----------|---------|------------|
| `sp_SearchHospitals` | Search hospitals | @SearchTerm, @City, @Specialty, @MinRating, pagination |
| `sp_SearchDoctors` | Search doctors | @SearchTerm, @SpecialtyName, @City, @MinRating, @MaxFee, pagination |
| `sp_GetSearchSuggestions` | Type-ahead suggestions | @Term, @Limit |
| `sp_GetDoctorAvailability` | Get available slots | @DoctorId, @FromDate, @ToDate |
| `sp_BookAppointment` | Create appointment | @DoctorId, @PatientId, @ScheduledDate, @ScheduledTime, @ReasonForVisit |
| `sp_CancelAppointment` | Cancel appointment | @AppointmentId, @CancellationReason |
| `sp_UpdateHospitalRating` | Recalculate hospital rating | @HospitalId |
| `sp_UpdateDoctorRating` | Recalculate doctor rating | @DoctorId |
| `sp_GetNearbyHospitals` | Find hospitals by GPS | @Latitude, @Longitude, @RadiusKm |

### TAService (4 SPs)

| Procedure | Purpose | Parameters |
|-----------|---------|------------|
| `sp_SearchFlights` | Search available flights | @DepartureAirport, @ArrivalAirport, @DepartureDate, @FlightClass |
| `sp_GetFlightRecommendations` | Smart recommendations | @DepartureAirport, @ArrivalAirport, @AppointmentDate |
| `sp_CreateTransportBooking` | Book flight/train | @UserId, @BookingType, @ReferenceId, passenger details |
| `sp_SearchHotelsNearHospital` | Find nearby hotels | @Latitude, @Longitude, @MaxDistanceKm, @MinStarRating |
| `sp_CreateCostEstimate` | Generate cost estimate | @UserId, @MedicalCost, @TravelCost, @AccommodationCost |

---

## 📊 Sample Data Included

### User Management
- ✅ 4 Roles (patient, doctor, hospital_admin, support)
- ✅ 12+ Permissions (read, write, delete, etc.)
- ✅ 3 Sample Users (patient, doctor, admin)
- ✅ Role-Permission assignments
- ✅ 4 Notification templates

### Hospital Service
- ✅ 10 Medical Specialties (Cardiology, Orthopedics, etc.)
- ✅ 8 Languages (English, Hindi, Telugu, Tamil, etc.)
- ✅ 3 Hospitals (Apollo Hyderabad, Care Hyderabad, Apollo Bangalore)
- ✅ 3 Doctors with credentials and specialties
- ✅ Doctor availability schedules (Mon-Sat, 9 AM - 5 PM)
- ✅ Hospital accreditations (NABH)
- ✅ 5 Common diseases

### TAService
- ✅ 7 Sample Flights (International & Domestic)
- ✅ 3 Sample Trains (Major routes)
- ✅ 3 Hotels near hospitals (Taj, Novotel, ITC)
- ✅ Room types and pricing

### Messaging Service
- ❌ No sample data (clean start for privacy)

---

## 🔨 How to Run

### Method 1: Using SSMS or Azure Data Studio

1. **Connect to SQL Server**
2. **Open** `database-scripts/00-MasterScript.sql`
3. **Execute** the script
4. **Wait** for completion (~30 seconds)

### Method 2: Using sqlcmd (Command Line)

```bash
# Single command to create everything
sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i database-scripts/00-MasterScript.sql
```

### Method 3: Using Docker

```bash
# Copy scripts into SQL Server container
docker cp database-scripts medtravel-sqlserver:/tmp/

# Execute master script
docker exec -it medtravel-sqlserver /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourStrong@Passw0rd \
  -i /tmp/database-scripts/00-MasterScript.sql
```

### Method 4: Entity Framework Migrations (Automatic)

```bash
# Migrations run automatically when you start services
docker-compose up

# Or manually run migrations
cd backend/UserManagementService/src/UserManagementService.Api
dotnet ef database update
```

---

## 🧪 Verify Installation

### Check Databases Created

```sql
SELECT name, database_id, create_date 
FROM sys.databases 
WHERE name IN ('UserManagementDb', 'HospitalDb', 'TAServiceDb', 'MessagingDb');
```

### Check Tables

```sql
-- User Management (should return 13)
USE UserManagementDb;
SELECT COUNT(*) AS TableCount FROM sys.tables;

-- Hospital (should return 15)
USE HospitalDb;
SELECT COUNT(*) AS TableCount FROM sys.tables;

-- TAService (should return 8)
USE TAServiceDb;
SELECT COUNT(*) AS TableCount FROM sys.tables;

-- Messaging (should return 4)
USE MessagingDb;
SELECT COUNT(*) AS TableCount FROM sys.tables;
```

### Check Stored Procedures

```sql
-- User Management (should return 8)
USE UserManagementDb;
SELECT COUNT(*) AS ProcedureCount FROM sys.procedures;

-- Hospital (should return 7+)
USE HospitalDb;
SELECT COUNT(*) AS ProcedureCount FROM sys.procedures;

-- TAService (should return 4+)
USE TAServiceDb;
SELECT COUNT(*) AS ProcedureCount FROM sys.procedures;
```

### Check Sample Data

```sql
-- Check users
USE UserManagementDb;
SELECT COUNT(*) FROM Users; -- Should be 3+
SELECT COUNT(*) FROM Roles; -- Should be 4

-- Check hospitals
USE HospitalDb;
SELECT COUNT(*) FROM Hospitals; -- Should be 3+
SELECT COUNT(*) FROM Doctors; -- Should be 3+
SELECT COUNT(*) FROM Specialties; -- Should be 10

-- Check flights
USE TAServiceDb;
SELECT COUNT(*) FROM Flights; -- Should be 7+
SELECT COUNT(*) FROM Hotels; -- Should be 3+
```

---

## 📚 Using Stored Procedures

### Example Calls

```sql
-- Search for cardiologists in Hyderabad
USE HospitalDb;
EXEC sp_SearchDoctors 
    @SpecialtyName = 'Cardiology',
    @City = 'Hyderabad',
    @PageNumber = 1,
    @PageSize = 10;

-- Get doctor availability
DECLARE @DoctorId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Doctors);
EXEC sp_GetDoctorAvailability 
    @DoctorId = @DoctorId,
    @FromDate = '2025-10-20',
    @ToDate = '2025-10-27';

-- Book an appointment
DECLARE @AppointmentId UNIQUEIDENTIFIER;
DECLARE @PatientId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM UserManagementDb.dbo.Users WHERE Email LIKE '%patient%');
EXEC sp_BookAppointment
    @DoctorId = @DoctorId,
    @PatientId = @PatientId,
    @ScheduledDate = '2025-10-25',
    @ScheduledTime = '10:00:00',
    @ReasonForVisit = 'Cardiac consultation',
    @AppointmentId = @AppointmentId OUTPUT;
SELECT @AppointmentId AS NewAppointmentId;

-- Search flights
USE TAServiceDb;
EXEC sp_SearchFlights
    @DepartureAirport = 'JFK',
    @ArrivalAirport = 'HYD',
    @DepartureDate = '2025-10-20',
    @MinSeats = 1;

-- Get nearby hotels
EXEC sp_SearchHotelsNearHospital
    @Latitude = 17.4239,
    @Longitude = 78.4501,
    @MaxDistanceKm = 10,
    @MinStarRating = 4;
```

---

## 🔄 Updating Schema

### Adding New Tables

1. Create new SQL file in appropriate `01-Schema/` folder
2. Follow naming convention: `02-CreateNewTables.sql`
3. Use `IF NOT EXISTS` checks
4. Add to master script

### Adding New Stored Procedures

1. Create in appropriate `02-StoredProcedures/` folder
2. Use `CREATE OR ALTER PROCEDURE`
3. Include documentation comments
4. Add to master script

### Modifying Existing Tables

```sql
-- Always use IF NOT EXISTS for columns
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'NewColumn')
BEGIN
    ALTER TABLE Users ADD NewColumn NVARCHAR(100);
END
GO
```

---

## 🛠️ Troubleshooting

### Issue: "Database already exists"

**Solution**: Scripts use `IF NOT EXISTS` checks - safe to run multiple times

### Issue: "Cannot insert duplicate key"

**Solution**: Sample data scripts also use `IF NOT EXISTS` - safe to re-run

### Issue: "Login failed for user 'sa'"

**Solution**: Check password in connection string or docker-compose.yml

### Issue: "SQL Server not running"

**Solution**:
```bash
# Start SQL Server container
docker-compose up sqlserver

# Or check if running
docker ps | grep sqlserver
```

---

## 🔐 Security Notes

### Default Credentials (Development Only)

- **Username**: `sa`
- **Password**: `YourStrong@Passw0rd`

**⚠️ WARNING**: Change these for production!

### Sample User Passwords

All sample users have password: `SecurePass123!`

**Accounts**:
- `patient@medtravel.com` - Patient role
- `doctor@medtravel.com` - Doctor role
- `admin@medtravel.com` - Support role

**⚠️ WARNING**: These are for development only. Remove or change for production!

---

## 📊 Database Statistics

### Total Objects Created

| Object Type | Count |
|-------------|-------|
| Databases | 4 |
| Tables | 40 |
| Stored Procedures | 19 |
| Indexes | 80+ |
| Foreign Keys | 30+ |
| Check Constraints | 5+ |
| Unique Constraints | 15+ |

### Sample Data Records

| Database | Records |
|----------|---------|
| UserManagementDb | ~100+ |
| HospitalDb | ~200+ |
| TAServiceDb | ~50+ |
| MessagingDb | 0 |

---

## 🚀 Next Steps

After running the scripts:

1. **Update Connection Strings** in each service's `appsettings.json`
2. **Test Database Connections** from each API service
3. **Run Migrations** if using Entity Framework
4. **Verify Sample Data** using the verification queries above
5. **Start Services** with `docker-compose up`

---

## 📞 Support

### Need Help?

- Check **DOTNET-BUILD-INSTRUCTIONS.md** for complete build guide
- See **QUICK-START-GUIDE.md** for quick setup
- Review **docs/GETTING-STARTED.md** for detailed instructions

### Common Issues

**Q: Should I use these SQL scripts or Entity Framework migrations?**  
A: Both work! SQL scripts give you full control. EF migrations are automatic.

**Q: Can I modify the schema?**  
A: Yes! Edit the SQL files or modify DbContext and create new EF migrations.

**Q: How do I add more sample data?**  
A: Add INSERT statements to the `03-SampleData` files.

---

**Created**: October 2025  
**Total Scripts**: 12 SQL files  
**Total Tables**: 40  
**Total Stored Procedures**: 19  
**Status**: ✅ Ready to Use
