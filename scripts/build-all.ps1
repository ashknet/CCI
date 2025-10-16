# MedTravel Platform - Build Script (PowerShell)
# Builds both backend and frontend

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  MedTravel Platform - Build Script  " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$buildBackend = $false
$buildFrontend = $false

# Check for .NET SDK
try {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK found: $dotnetVersion" -ForegroundColor Green
    $buildBackend = $true
}
catch {
    Write-Host "✗ .NET SDK not found. Backend build will be skipped." -ForegroundColor Red
    Write-Host "  Install from: https://dot.net/download" -ForegroundColor Yellow
}

# Check for Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js found: $nodeVersion" -ForegroundColor Green
    $buildFrontend = $true
}
catch {
    Write-Host "✗ Node.js not found. Frontend build will be skipped." -ForegroundColor Red
    Write-Host "  Install from: https://nodejs.org" -ForegroundColor Yellow
}

Write-Host ""

# Build Backend
if ($buildBackend) {
    Write-Host "Building Backend..." -ForegroundColor Blue
    Write-Host "----------------------------------------"
    
    Write-Host "Restoring dependencies..."
    dotnet restore MedTravel.sln
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Backend restore failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Building solution..."
    dotnet build MedTravel.sln --configuration Release --no-restore
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Backend build failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✓ Backend build completed successfully!" -ForegroundColor Green
    Write-Host ""
}

# Build Frontend
if ($buildFrontend) {
    Write-Host "Building Frontend..." -ForegroundColor Blue
    Write-Host "----------------------------------------"
    
    Set-Location frontend
    
    Write-Host "Installing dependencies..."
    npm install
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Frontend install failed!" -ForegroundColor Red
        Set-Location ..
        exit 1
    }
    
    Write-Host "Building React application..."
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Frontend build failed!" -ForegroundColor Red
        Set-Location ..
        exit 1
    }
    
    Set-Location ..
    
    Write-Host "✓ Frontend build completed successfully!" -ForegroundColor Green
    Write-Host ""
}

# Summary
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Build Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if ($buildBackend) {
    Write-Host "Backend:  " -NoNewline
    Write-Host "✓ SUCCESS" -ForegroundColor Green
}
else {
    Write-Host "Backend:  " -NoNewline
    Write-Host "⏭ SKIPPED (No .NET SDK)" -ForegroundColor Yellow
}

if ($buildFrontend) {
    Write-Host "Frontend: " -NoNewline
    Write-Host "✓ SUCCESS" -ForegroundColor Green
}
else {
    Write-Host "Frontend: " -NoNewline
    Write-Host "⏭ SKIPPED (No Node.js)" -ForegroundColor Yellow
}

Write-Host "======================================" -ForegroundColor Cyan

if ($buildBackend -and $buildFrontend) {
    Write-Host "🎉 All builds completed successfully!" -ForegroundColor Green
    exit 0
}
elseif ($buildBackend -or $buildFrontend) {
    Write-Host "ℹ Some builds completed. Install missing tools to build everything." -ForegroundColor Blue
    exit 0
}
else {
    Write-Host "❌ No builds completed. Install .NET SDK and/or Node.js." -ForegroundColor Red
    exit 1
}
