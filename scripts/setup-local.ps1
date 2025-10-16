# MedTravel Platform - Local Setup Script (Windows)

Write-Host "🚀 MedTravel Platform - Local Setup Script" -ForegroundColor Cyan
Write-Host "==========================================`n" -ForegroundColor Cyan

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

$dockerInstalled = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerInstalled) {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

$dockerComposeInstalled = Get-Command docker-compose -ErrorAction SilentlyContinue
if (-not $dockerComposeInstalled) {
    Write-Host "❌ Docker Compose is not installed." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Prerequisites satisfied`n" -ForegroundColor Green

# Start services
Write-Host "Starting all services with Docker Compose..." -ForegroundColor Yellow
docker-compose up -d --build

Write-Host "`n⏳ Waiting for services to be healthy..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Check health
Write-Host "`nChecking service health..." -ForegroundColor Yellow

$services = @{
    "http://localhost:5001/health" = "User Management"
    "http://localhost:5002/health" = "Hospital"
    "http://localhost:5003/health" = "Transportation"
    "http://localhost:5004/health" = "Messaging"
    "http://localhost:3000" = "Frontend"
}

$allHealthy = $true

foreach ($url in $services.Keys) {
    $name = $services[$url]
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
        Write-Host "✅ $name Service is healthy" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ $name Service is not responding" -ForegroundColor Red
        $allHealthy = $false
    }
}

Write-Host ""
if ($allHealthy) {
    Write-Host "🎉 All services are running!" -ForegroundColor Green
    Write-Host "`nAccess the platform:" -ForegroundColor Cyan
    Write-Host "  Frontend:        http://localhost:3000"
    Write-Host "  User API:        http://localhost:5001/swagger"
    Write-Host "  Hospital API:    http://localhost:5002/swagger"
    Write-Host "  Transport API:   http://localhost:5003/swagger"
    Write-Host "  Messaging API:   http://localhost:5004/swagger"
    Write-Host "`nDefault credentials (Local Dev Mode):" -ForegroundColor Cyan
    Write-Host "  Email: devuser@medtravel.local"
    Write-Host "  (Authentication bypassed in local mode)"
}
else {
    Write-Host "⚠️  Some services failed to start. Check logs with:" -ForegroundColor Yellow
    Write-Host "  docker-compose logs"
}
