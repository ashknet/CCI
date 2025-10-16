# 🔧 Update Connection Strings for Single Database

## ✅ Single Connection String for All Services

Now that we're using a single database (`MedTravelDb`) with multiple schemas, **all services use the same connection string**!

---

## 📝 The New Connection String

```
Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
```

---

## 🔧 Update Each Service

### 1. UserManagementService

**File**: `backend/UserManagementService/src/UserManagementService.Api/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

**Update DbContext** to use schema:

**File**: `backend/UserManagementService/src/UserManagementService.Infrastructure/Data/UserManagementDbContext.cs`

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Set default schema for UserManagement service
    modelBuilder.HasDefaultSchema("UserManagement");
    
    base.OnModelCreating(modelBuilder);
    
    // Rest of your model configuration...
}
```

---

### 2. HospitalService

**File**: `backend/HospitalService/src/HospitalService.Api/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true"
  }
}
```

**Update DbContext**:

**File**: `backend/HospitalService/src/HospitalService.Infrastructure/Data/HospitalDbContext.cs`

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Set default schema for Hospital service
    modelBuilder.HasDefaultSchema("Hospital");
    
    base.OnModelCreating(modelBuilder);
    
    // Rest of your model configuration...
}
```

---

### 3. TAService

**File**: `backend/TAService/src/TAService.Api/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true"
  }
}
```

**Update DbContext**:

**File**: `backend/TAService/src/TAService.Infrastructure/Data/TransportationDbContext.cs`

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Set default schema for TAService
    modelBuilder.HasDefaultSchema("TAService");
    
    base.OnModelCreating(modelBuilder);
    
    // Rest of your model configuration...
}
```

---

### 4. MessagingService

**File**: `backend/MessagingService/src/MessagingService.Api/appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true"
  }
}
```

**Update DbContext**:

**File**: `backend/MessagingService/src/MessagingService.Infrastructure/Data/MessagingDbContext.cs`

```csharp
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    // Set default schema for Messaging service
    modelBuilder.HasDefaultSchema("Messaging");
    
    base.OnModelCreating(modelBuilder);
    
    // Rest of your model configuration...
}
```

---

## 🐳 Update docker-compose.yml

**File**: `docker-compose.yml`

```yaml
services:
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    container_name: medtravel-sqlserver
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourStrong@Passw0rd
      - MSSQL_PID=Express
    ports:
      - "1433:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql
    networks:
      - medtravel-network
    healthcheck:
      test: /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -Q "SELECT 1"
      interval: 10s
      timeout: 5s
      retries: 10

  user-management-service:
    build:
      context: .
      dockerfile: backend/UserManagementService/src/UserManagementService.Api/Dockerfile
    container_name: medtravel-user-service
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ASPNETCORE_URLS=http://+:80
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
    ports:
      - "5001:80"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - medtravel-network

  hospital-service:
    build:
      context: .
      dockerfile: backend/HospitalService/src/HospitalService.Api/Dockerfile
    container_name: medtravel-hospital-service
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ASPNETCORE_URLS=http://+:80
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
    ports:
      - "5002:80"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - medtravel-network

  taservice:
    build:
      context: .
      dockerfile: backend/TAService/src/TAService.Api/Dockerfile
    container_name: medtravel-taservice
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ASPNETCORE_URLS=http://+:80
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
    ports:
      - "5003:80"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - medtravel-network

  messaging-service:
    build:
      context: .
      dockerfile: backend/MessagingService/src/MessagingService.Api/Dockerfile
    container_name: medtravel-messaging-service
    environment:
      - ASPNETCORE_ENVIRONMENT=Development
      - ASPNETCORE_URLS=http://+:80
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=MedTravelDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;MultipleActiveResultSets=true
    ports:
      - "5004:80"
    depends_on:
      sqlserver:
        condition: service_healthy
    networks:
      - medtravel-network

volumes:
  sqlserver-data:

networks:
  medtravel-network:
    driver: bridge
```

**Key Change**: All services now use the **same database** (`MedTravelDb`) instead of separate databases.

---

## 🔄 Entity Framework Migrations

### Generate Initial Migration for Each Service

```bash
# UserManagement
cd backend/UserManagementService/src/UserManagementService.Api
dotnet ef migrations add InitialCreate --context UserManagementDbContext

# Hospital
cd backend/HospitalService/src/HospitalService.Api
dotnet ef migrations add InitialCreate --context HospitalDbContext

# TAService
cd backend/TAService/src/TAService.Api
dotnet ef migrations add InitialCreate --context TransportationDbContext

# Messaging
cd backend/MessagingService/src/MessagingService.Api
dotnet ef migrations add InitialCreate --context MessagingDbContext
```

### Apply Migrations

```bash
# All services can run migrations concurrently - they use different schemas!
dotnet ef database update --context UserManagementDbContext
dotnet ef database update --context HospitalDbContext
dotnet ef database update --context TransportationDbContext
dotnet ef database update --context MessagingDbContext
```

---

## ✅ Verification

### Test Connection from Each Service

**UserManagementService**:
```bash
curl http://localhost:5001/api/v1/health
```

**HospitalService**:
```bash
curl http://localhost:5002/api/v1/health
```

**TAService**:
```bash
curl http://localhost:5003/api/v1/health
```

**MessagingService**:
```bash
curl http://localhost:5004/api/v1/health
```

All should return healthy status! ✅

---

## 🎯 Summary

| Service | Old Connection | New Connection |
|---------|---------------|----------------|
| **UserManagement** | `UserManagementDb` | `MedTravelDb` (schema: UserManagement) |
| **Hospital** | `HospitalDb` | `MedTravelDb` (schema: Hospital) |
| **TAService** | `TAServiceDb` | `MedTravelDb` (schema: TAService) |
| **Messaging** | `MessagingDb` | `MedTravelDb` (schema: Messaging) |

**Result**: ✅ One database, four schemas, simpler management!

---

**Updated**: October 2025  
**Status**: ✅ Ready to Deploy
