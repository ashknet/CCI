# NuGet Packaging Guide for MedTravel Shared Libraries

## ✅ Independent Microservices Architecture

The shared libraries have been converted to NuGet packages to enable **true microservices independence**. Each service can now be deployed independently without requiring the entire solution.

---

## 📦 Available NuGet Packages

### 1. MedTravel.Shared (v1.0.0)
**Purpose**: Core models, exceptions, and utilities

**Contents**:
- `ApiResponse<T>` - Standard API response wrapper
- `PagedResult<T>` - Pagination model
- `BusinessException` family - Custom exceptions

**Dependencies**:
- Microsoft.Extensions.Configuration.Abstractions 8.0.0
- Microsoft.Extensions.DependencyInjection.Abstractions 8.0.0
- Newtonsoft.Json 13.0.3

### 2. MedTravel.Shared.Auth (v1.0.0)
**Purpose**: Authentication and authorization utilities

**Contents**:
- JWT service and configuration
- Local dev authentication middleware
- Auth extensions

**Dependencies**:
- MedTravel.Shared 1.0.0
- Microsoft.AspNetCore.Authentication.JwtBearer 8.0.0
- System.IdentityModel.Tokens.Jwt 7.0.3

### 3. MedTravel.Shared.Logging (v1.0.0)
**Purpose**: Logging and correlation utilities

**Contents**:
- Serilog configuration
- Correlation ID middleware
- Structured logging setup

**Dependencies**:
- MedTravel.Shared 1.0.0
- Serilog 3.1.1
- Serilog.AspNetCore 8.0.0
- Serilog.Sinks.Console 5.0.1
- Serilog.Sinks.File 5.0.0

### 4. MedTravel.Shared.Validation (v1.0.0)
**Purpose**: Validation middleware and utilities

**Contents**:
- Validation middleware
- FluentValidation setup
- Error response formatting

**Dependencies**:
- MedTravel.Shared 1.0.0
- FluentValidation 11.9.2
- FluentValidation.DependencyInjectionExtensions 11.9.2

---

## 🔨 Building NuGet Packages

### Build All Shared Packages

```bash
# Navigate to shared libraries directory
cd backend/Shared

# Build and pack MedTravel.Shared (build this first - others depend on it)
cd MedTravel.Shared
dotnet pack -c Release -o ../../../nupkgs

# Build and pack MedTravel.Shared.Auth
cd ../MedTravel.Shared.Auth
dotnet pack -c Release -o ../../../nupkgs

# Build and pack MedTravel.Shared.Logging
cd ../MedTravel.Shared.Logging
dotnet pack -c Release -o ../../../nupkgs

# Build and pack MedTravel.Shared.Validation
cd ../MedTravel.Shared.Validation
dotnet pack -c Release -o ../../../nupkgs
```

**Output**: All `.nupkg` files will be in `nupkgs/` folder at solution root.

### Build Single Package

```bash
dotnet pack backend/Shared/MedTravel.Shared/MedTravel.Shared.csproj \
  -c Release \
  -o nupkgs \
  /p:PackageVersion=1.0.0
```

---

## 📤 Publishing NuGet Packages

### Option 1: Private NuGet Feed (Recommended)

#### Azure Artifacts
```bash
# Add Azure Artifacts feed
dotnet nuget add source "https://pkgs.dev.azure.com/{org}/_packaging/{feed}/nuget/v3/index.json" \
  --name "MedTravelFeed" \
  --username "your-username" \
  --password "your-pat"

# Push packages
dotnet nuget push nupkgs/MedTravel.Shared.1.0.0.nupkg \
  --source "MedTravelFeed" \
  --api-key "your-api-key"
```

#### GitHub Packages
```bash
# Add GitHub Packages source
dotnet nuget add source "https://nuget.pkg.github.com/YOUR-ORG/index.json" \
  --name "GitHubPackages" \
  --username "your-username" \
  --password "your-github-pat"

# Push to GitHub Packages
dotnet nuget push nupkgs/MedTravel.Shared.1.0.0.nupkg \
  --source "GitHubPackages"
```

#### JFrog Artifactory
```bash
dotnet nuget add source "https://your-company.jfrog.io/artifactory/api/nuget/v3/nuget-local" \
  --name "JFrogNuGet" \
  --username "your-username" \
  --password "your-api-key"

dotnet nuget push nupkgs/MedTravel.Shared.1.0.0.nupkg \
  --source "JFrogNuGet"
```

### Option 2: Local NuGet Feed (Development)

```bash
# Create local feed directory
mkdir -p ~/nuget-local-feed

# Copy packages to local feed
cp nupkgs/*.nupkg ~/nuget-local-feed/

# Add local feed as source
dotnet nuget add source ~/nuget-local-feed --name "LocalFeed"
```

### Option 3: Public NuGet.org (Open Source Only)

```bash
# Get API key from nuget.org
# Then push packages
dotnet nuget push nupkgs/MedTravel.Shared.1.0.0.nupkg \
  --source https://api.nuget.org/v3/index.json \
  --api-key YOUR_NUGET_ORG_API_KEY
```

---

## 📥 Using NuGet Packages in Services

### Services Already Configured ✅

All services have been updated to use `PackageReference` instead of `ProjectReference`:

**UserManagementService.Api.csproj**:
```xml
<ItemGroup>
  <PackageReference Include="MedTravel.Shared" Version="1.0.0" />
  <PackageReference Include="MedTravel.Shared.Auth" Version="1.0.0" />
  <PackageReference Include="MedTravel.Shared.Logging" Version="1.0.0" />
  <PackageReference Include="MedTravel.Shared.Validation" Version="1.0.0" />
</ItemGroup>
```

### Restoring Packages

```bash
# Restore packages for a service
cd backend/UserManagementService/src/UserManagementService.Api
dotnet restore

# Or restore entire solution
dotnet restore MedTravel.sln
```

---

## 🔄 Updating Package Versions

### Bump Version Numbers

1. Update version in `.csproj` file:
```xml
<PackageId>MedTravel.Shared</PackageId>
<Version>1.1.0</Version> <!-- Increment version -->
```

2. Rebuild and pack:
```bash
dotnet pack -c Release -o nupkgs
```

3. Push to feed:
```bash
dotnet nuget push nupkgs/MedTravel.Shared.1.1.0.nupkg --source "YourFeed"
```

4. Update service references:
```bash
cd backend/UserManagementService/src/UserManagementService.Api
dotnet add package MedTravel.Shared --version 1.1.0
```

### Semantic Versioning

- **Patch** (1.0.X): Bug fixes, no API changes
- **Minor** (1.X.0): New features, backwards compatible
- **Major** (X.0.0): Breaking changes

---

## 🏗️ CI/CD Integration

### GitHub Actions Workflow

```yaml
name: Build and Publish NuGet Packages

on:
  push:
    paths:
      - 'backend/Shared/**'
    branches:
      - main

jobs:
  publish-packages:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      
      - name: Build and Pack Shared Libraries
        run: |
          dotnet pack backend/Shared/MedTravel.Shared -c Release -o nupkgs
          dotnet pack backend/Shared/MedTravel.Shared.Auth -c Release -o nupkgs
          dotnet pack backend/Shared/MedTravel.Shared.Logging -c Release -o nupkgs
          dotnet pack backend/Shared/MedTravel.Shared.Validation -c Release -o nupkgs
      
      - name: Push to NuGet Feed
        run: |
          dotnet nuget push nupkgs/*.nupkg \
            --source ${{ secrets.NUGET_FEED_URL }} \
            --api-key ${{ secrets.NUGET_API_KEY }}
```

### Azure DevOps Pipeline

```yaml
trigger:
  paths:
    include:
      - backend/Shared/*

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: UseDotNet@2
  inputs:
    version: '8.0.x'

- script: |
    dotnet pack backend/Shared/MedTravel.Shared -c Release -o $(Build.ArtifactStagingDirectory)
    dotnet pack backend/Shared/MedTravel.Shared.Auth -c Release -o $(Build.ArtifactStagingDirectory)
    dotnet pack backend/Shared/MedTravel.Shared.Logging -c Release -o $(Build.ArtifactStagingDirectory)
    dotnet pack backend/Shared/MedTravel.Shared.Validation -c Release -o $(Build.ArtifactStagingDirectory)
  displayName: 'Build and Pack'

- task: NuGetCommand@2
  inputs:
    command: 'push'
    packagesToPush: '$(Build.ArtifactStagingDirectory)/**/*.nupkg'
    nuGetFeedType: 'internal'
    publishVstsFeed: 'your-feed-id'
```

---

## 🎯 Benefits of NuGet Packaging

### 1. **Independent Deployment** ✅
- Each service can be deployed without the entire solution
- No cross-service project dependencies
- True microservices independence

### 2. **Version Control** ✅
- Services can use different versions of shared libraries
- Gradual rollout of breaking changes
- Semantic versioning support

### 3. **Build Performance** ✅
- Services only build what they need
- No unnecessary rebuilds
- Faster CI/CD pipelines

### 4. **Team Autonomy** ✅
- Different teams can own different services
- No merge conflicts in shared code
- Independent release cycles

### 5. **Clear Dependencies** ✅
- Explicit version dependencies
- No hidden coupling
- Better dependency management

---

## 📋 Configuration Files

### NuGet.config (Solution Root)

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
    <add key="MedTravelFeed" value="https://your-private-feed-url" />
    <add key="LocalFeed" value="../nupkgs" />
  </packageSources>
  <packageSourceCredentials>
    <MedTravelFeed>
      <add key="Username" value="%NUGET_USERNAME%" />
      <add key="ClearTextPassword" value="%NUGET_PASSWORD%" />
    </MedTravelFeed>
  </packageSourceCredentials>
</configuration>
```

### .gitignore Updates

```gitignore
# NuGet packages
*.nupkg
nupkgs/
!nupkgs/.gitkeep

# NuGet caches
.nuget/packages/
```

---

## 🔍 Verification

### Check Package References

```bash
# List all package references in a project
dotnet list backend/UserManagementService/src/UserManagementService.Api/UserManagementService.Api.csproj package

# Should show:
# MedTravel.Shared 1.0.0
# MedTravel.Shared.Auth 1.0.0
# MedTravel.Shared.Logging 1.0.0
# MedTravel.Shared.Validation 1.0.0
```

### Verify No Project References to Shared

```bash
# Should return empty/no matches
grep -r "ProjectReference.*Shared" backend/UserManagementService/
grep -r "ProjectReference.*Shared" backend/HospitalService/
grep -r "ProjectReference.*Shared" backend/TAService/
grep -r "ProjectReference.*Shared" backend/MessagingService/
```

---

## 🚀 Quick Start

### For Local Development

```bash
# 1. Build shared packages
cd backend/Shared
for dir in MedTravel.Shared*; do
  cd $dir
  dotnet pack -c Release -o ../../../nupkgs
  cd ..
done

# 2. Add local feed
dotnet nuget add source $(pwd)/nupkgs --name "LocalDev"

# 3. Restore and build services
cd ../../
dotnet restore MedTravel.sln
dotnet build MedTravel.sln
```

### For CI/CD

```bash
# Packages are automatically published to private feed
# Services restore from private feed during build
dotnet restore --source "https://your-private-feed"
dotnet build
```

---

## 📞 Support

### Troubleshooting

**Problem**: Package not found
```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Re-restore packages
dotnet restore --force
```

**Problem**: Version conflict
```bash
# Check installed versions
dotnet list package --include-transitive

# Update to specific version
dotnet add package MedTravel.Shared --version 1.0.0
```

---

## ✅ Migration Complete

All services now use NuGet packages instead of project references:

- ✅ UserManagementService.Api
- ✅ HospitalService.Api
- ✅ TAService.Api
- ✅ MessagingService.Api
- ✅ All Infrastructure projects

**Each service can now be deployed independently!**

---

**Created**: October 2025  
**Status**: ✅ Ready for Use  
**Package Version**: 1.0.0
