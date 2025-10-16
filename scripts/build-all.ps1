# MedTravel Platform - Complete Build Script (Windows)
# Builds NuGet packages and entire solution

Write-Host "======================================" -ForegroundColor Blue
Write-Host "  MedTravel Platform - Build Script" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue
Write-Host ""

# Navigate to solution root
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$solutionRoot = Split-Path -Parent $scriptPath
Set-Location $solutionRoot

Write-Host "Solution root: $solutionRoot" -ForegroundColor Cyan
Write-Host ""

# Step 1: Build NuGet Packages
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Step 1: Building NuGet Packages" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

New-Item -ItemType Directory -Force -Path "nupkgs" | Out-Null

Set-Location backend\Shared

Write-Host "Building MedTravel.Shared..." -ForegroundColor Yellow
dotnet pack MedTravel.Shared -c Release -o ..\..\nupkgs
Write-Host "✅ MedTravel.Shared.1.0.0.nupkg created" -ForegroundColor Green

Write-Host "Building MedTravel.Shared.Auth..." -ForegroundColor Yellow
dotnet pack MedTravel.Shared.Auth -c Release -o ..\..\nupkgs
Write-Host "✅ MedTravel.Shared.Auth.1.0.0.nupkg created" -ForegroundColor Green

Write-Host "Building MedTravel.Shared.Logging..." -ForegroundColor Yellow
dotnet pack MedTravel.Shared.Logging -c Release -o ..\..\nupkgs
Write-Host "✅ MedTravel.Shared.Logging.1.0.0.nupkg created" -ForegroundColor Green

Write-Host "Building MedTravel.Shared.Validation..." -ForegroundColor Yellow
dotnet pack MedTravel.Shared.Validation -c Release -o ..\..\nupkgs
Write-Host "✅ MedTravel.Shared.Validation.1.0.0.nupkg created" -ForegroundColor Green

Set-Location $solutionRoot

Write-Host ""
Write-Host "✅ All NuGet packages built successfully" -ForegroundColor Green
Write-Host ""

# Step 2: Add local NuGet source
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Step 2: Configuring NuGet Sources" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

# Remove existing LocalDev source if it exists
dotnet nuget remove source LocalDev 2>$null

# Add local NuGet source
$nupkgsPath = Join-Path $solutionRoot "nupkgs"
dotnet nuget add source $nupkgsPath --name "LocalDev"
Write-Host "✅ Local NuGet source configured" -ForegroundColor Green
Write-Host ""

# Step 3: Restore packages
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Step 3: Restoring Packages" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

dotnet restore MedTravel.sln
Write-Host "✅ Packages restored" -ForegroundColor Green
Write-Host ""

# Step 4: Build solution
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Step 4: Building Solution" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

dotnet build MedTravel.sln --configuration Release --no-restore
Write-Host "✅ Solution built successfully" -ForegroundColor Green
Write-Host ""

# Step 5: Build frontend
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Step 5: Building Frontend" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue

Set-Location frontend
npm install
npm run build
Set-Location $solutionRoot

Write-Host "✅ Frontend built successfully" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "======================================" -ForegroundColor Blue
Write-Host "  Build Complete!" -ForegroundColor Blue
Write-Host "======================================" -ForegroundColor Blue
Write-Host ""
Write-Host "✅ NuGet packages: 4" -ForegroundColor Green
Write-Host "✅ Backend services: 4" -ForegroundColor Green
Write-Host "✅ Frontend: Built" -ForegroundColor Green
Write-Host ""
Write-Host "To start the platform:" -ForegroundColor Cyan
Write-Host "  docker-compose up" -ForegroundColor White
Write-Host ""
Write-Host "Or run services individually:" -ForegroundColor Cyan
Write-Host "  cd backend\UserManagementService\src\UserManagementService.Api" -ForegroundColor White
Write-Host "  dotnet run" -ForegroundColor White
Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green
