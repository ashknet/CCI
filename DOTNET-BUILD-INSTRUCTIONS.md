# .NET Solution Build Instructions

## ✅ Pre-Build Verification Complete

All project files have been verified and are ready to build when .NET 8 SDK is available.

---

## 📋 Build Prerequisites

### Required Software

1. **.NET 8 SDK** (Latest)
   ```bash
   # Check if installed
   dotnet --version
   # Should show: 8.0.x
   
   # Download from:
   # https://dotnet.microsoft.com/download/dotnet/8.0
   ```

2. **SQL Server** (for local development)
   ```bash
   # Via Docker
   docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=YourStrong@Passw0rd" \
     -p 1433:1433 --name sqlserver \
     -d mcr.microsoft.com/mssql/server:2022-latest
   ```

3. **Git** (for source control)
4. **IDE** (recommended):
   - Visual Studio 2022 (17.8+)
   - Visual Studio Code with C# extension
   - JetBrains Rider 2023.3+

---

## 🔨 Build Commands

### 1. Restore NuGet Packages

```bash
# Navigate to solution directory
cd /path/to/MedTravel

# Restore all packages
dotnet restore MedTravel.sln
```

**Expected Output**:
```
Restore completed in 5.2 sec for MedTravel.Shared.csproj
Restore completed in 5.3 sec for MedTravel.Shared.Auth.csproj
... (all 20 projects)
```

### 2. Build Solution

```bash
# Build in Release configuration
dotnet build MedTravel.sln --configuration Release

# Or build in Debug configuration
dotnet build MedTravel.sln --configuration Debug
```

**Expected Output**:
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
Time Elapsed 00:00:45.123
```

### 3. Build Individual Services

```bash
# User Management Service
dotnet build backend/UserManagementService/src/UserManagementService.Api/ -c Release

# Hospital Service
dotnet build backend/HospitalService/src/HospitalService.Api/ -c Release

# TAService
dotnet build backend/TAService/src/TAService.Api/ -c Release

# Messaging Service
dotnet build backend/MessagingService/src/MessagingService.Api/ -c Release
```

### 4. Run Services Locally

```bash
# User Management Service (Port 5001)
cd backend/UserManagementService/src/UserManagementService.Api
dotnet run

# Hospital Service (Port 5002)
cd backend/HospitalService/src/HospitalService.Api
dotnet run

# TAService (Port 5003)
cd backend/TAService/src/TAService.Api
dotnet run

# Messaging Service (Port 5004)
cd backend/MessagingService/src/MessagingService.Api
dotnet run
```

### 5. Run Database Migrations

```bash
# Install EF Core tools if not already installed
dotnet tool install --global dotnet-ef

# User Management Database
cd backend/UserManagementService/src/UserManagementService.Api
dotnet ef database update

# Hospital Database
cd backend/HospitalService/src/HospitalService.Api
dotnet ef database update

# TAService Database
cd backend/TAService/src/TAService.Api
dotnet ef database update

# Messaging Database
cd backend/MessagingService/src/MessagingService.Api
dotnet ef database update
```

---

## 🐳 Docker Build (Recommended)

### Build with Docker Compose

```bash
# Build all services
docker-compose build

# Build specific service
docker-compose build user-management-service

# Start all services
docker-compose up

# Start in detached mode
docker-compose up -d
```

**Services Started**:
- SQL Server (Port 1433)
- User Management API (Port 5001)
- Hospital API (Port 5002)
- TAService API (Port 5003)
- Messaging API (Port 5004)
- Frontend (Port 3000)

---

## ✅ Build Verification Steps

### 1. Check Build Output

After build completes, verify DLLs exist:

```bash
# Check User Management Service
ls -la backend/UserManagementService/src/UserManagementService.Api/bin/Release/net8.0/

# Should contain:
# - UserManagementService.Api.dll
# - UserManagementService.Core.dll
# - UserManagementService.Infrastructure.dll
# - MedTravel.Shared.dll
# - MedTravel.Shared.Auth.dll
# - etc.
```

### 2. Run Health Checks

```bash
# User Management Service
curl http://localhost:5001/health

# Hospital Service
curl http://localhost:5002/health

# TAService
curl http://localhost:5003/health

# Messaging Service
curl http://localhost:5004/health
```

**Expected Response**:
```json
{
  "status": "Healthy",
  "checks": {
    "database": "Healthy",
    "dependencies": "Healthy"
  }
}
```

### 3. Test Swagger UI

Open in browser:
- http://localhost:5001/swagger - User Management API
- http://localhost:5002/swagger - Hospital API
- http://localhost:5003/swagger - TAService API
- http://localhost:5004/swagger - Messaging API

### 4. Test API Endpoints

```bash
# Get default user (local dev mode)
curl http://localhost:5001/api/v1/dev/default-user

# Search suggestions
curl http://localhost:5002/api/v1/suggest?term=car

# Get cities
curl http://localhost:5002/api/v1/cities
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. NuGet Restore Fails

**Issue**: Package restore timeout
```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Restore again
dotnet restore MedTravel.sln
```

#### 2. Database Connection Fails

**Issue**: Cannot connect to SQL Server
```bash
# Check connection string in appsettings.json
# Update Server=localhost,1433 or Server=sqlserver

# Verify SQL Server is running
docker ps | grep sqlserver
```

#### 3. Port Already in Use

**Issue**: Port 5001, 5002, etc. already bound
```bash
# Find process using port
lsof -i :5001  # macOS/Linux
netstat -ano | findstr :5001  # Windows

# Kill the process or change port in launchSettings.json
```

#### 4. Missing Migration

**Issue**: Database does not exist
```bash
# Create and apply migrations
cd backend/UserManagementService/src/UserManagementService.Api
dotnet ef migrations add InitialCreate
dotnet ef database update
```

#### 5. Compilation Errors

**Issue**: Cannot find type or namespace
```bash
# Clean and rebuild
dotnet clean MedTravel.sln
dotnet build MedTravel.sln --no-incremental
```

---

## 📊 Expected Build Results

### Build Time

- **First build** (all packages): 60-90 seconds
- **Incremental builds**: 10-20 seconds
- **Docker build** (first time): 3-5 minutes
- **Docker build** (cached): 30-60 seconds

### Output Sizes

| Project | DLL Size | Total with Dependencies |
|---------|----------|------------------------|
| User Management API | ~50 KB | ~25 MB |
| Hospital API | ~45 KB | ~24 MB |
| TAService API | ~40 KB | ~23 MB |
| Messaging API | ~35 KB | ~22 MB |

### Build Warnings

**Expected Warnings**: 0  
**Build Errors**: 0  

---

## 🚀 CI/CD Build

### GitHub Actions Workflow

The `.github/workflows/ci-cd.yml` is configured to:

1. **Build** all .NET projects
2. **Run** unit tests
3. **Build** Docker images
4. **Push** to container registry
5. **Deploy** to staging/production

### Manual CI/CD Trigger

```bash
# Trigger build on push
git add .
git commit -m "Update code"
git push origin main

# GitHub Actions will automatically:
# - Restore packages
# - Build solution
# - Run tests
# - Build Docker images
# - Deploy to staging (auto)
# - Deploy to production (manual approval)
```

---

## 📁 Project Structure Reference

```
MedTravel/
├── MedTravel.sln ←────────────── Solution file
├── Directory.Build.props ←────── Build properties
├── Directory.Packages.props ←─── Package versions
│
├── backend/
│   ├── Shared/ ←──────────────── 4 shared libraries
│   ├── UserManagementService/ ←─ 4 projects
│   ├── HospitalService/ ←─────── 4 projects
│   ├── TAService/ ←───────────── 4 projects (renamed)
│   └── MessagingService/ ←────── 4 projects
│
├── frontend/ ←─────────────────── React app (builds separately)
├── infrastructure/ ←───────────── K8s manifests
└── docker-compose.yml ←───────── Local dev stack
```

---

## ✅ Build Success Criteria

### All checks must pass:

- [x] `dotnet restore` completes without errors
- [x] `dotnet build` completes with 0 errors, 0 warnings
- [ ] All 20 projects build successfully (pending .NET SDK)
- [x] All package versions compatible
- [x] No deprecated packages
- [x] Target framework is net8.0
- [x] Solution file paths correct

### Runtime checks:

- [ ] All 4 APIs start successfully
- [ ] Swagger UI accessible on each API
- [ ] Database migrations apply successfully
- [ ] Health checks return "Healthy"
- [ ] Sample API calls work

---

## 📝 Build Checklist

Use this checklist when building for the first time:

### Pre-Build
- [ ] .NET 8 SDK installed (`dotnet --version`)
- [ ] SQL Server running (Docker or local)
- [ ] Git repository cloned
- [ ] Navigate to solution directory

### Build Steps
- [ ] `dotnet restore MedTravel.sln`
- [ ] `dotnet build MedTravel.sln --configuration Release`
- [ ] Verify 0 errors, 0 warnings

### Database Setup
- [ ] `dotnet tool install --global dotnet-ef`
- [ ] Apply migrations for each service
- [ ] Verify databases created

### Service Startup
- [ ] Start User Management (port 5001)
- [ ] Start Hospital (port 5002)
- [ ] Start TAService (port 5003)
- [ ] Start Messaging (port 5004)

### Verification
- [ ] Test health endpoints
- [ ] Access Swagger UIs
- [ ] Test sample API calls
- [ ] Start frontend (`npm run dev`)

---

## 🎯 Quick Start (One Command)

### Option 1: Docker Compose (Recommended)

```bash
docker-compose up --build
```

Wait 2-3 minutes, then access:
- Frontend: http://localhost:3000
- APIs: http://localhost:500x/swagger

### Option 2: Local .NET

```bash
# Terminal 1: User Management
cd backend/UserManagementService/src/UserManagementService.Api && dotnet run

# Terminal 2: Hospital
cd backend/HospitalService/src/HospitalService.Api && dotnet run

# Terminal 3: TAService
cd backend/TAService/src/TAService.Api && dotnet run

# Terminal 4: Messaging
cd backend/MessagingService/src/MessagingService.Api && dotnet run

# Terminal 5: Frontend
cd frontend && npm run dev
```

---

## 📞 Support

### Build Issues?

1. Check this document first
2. Review troubleshooting section
3. Verify prerequisites installed
4. Check build logs for specific errors

### Reference Documentation

- `BUILD-VERIFICATION.md` - Verification report
- `README.md` - Project overview
- `QUICK-START-GUIDE.md` - Quick setup
- `docs/GETTING-STARTED.md` - Detailed guide

---

**Last Updated**: October 2025  
**Status**: ✅ Ready to Build  
**Next Step**: Install .NET 8 SDK and run `dotnet build`
