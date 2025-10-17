# Create Local NuGet Packages for MedTravel Shared Libraries
# This script builds and creates local NuGet packages for all shared libraries

Write-Host "🚀 Creating Local NuGet Packages for MedTravel Shared Libraries" -ForegroundColor Green
Write-Host ""

# Create nupkgs directory if it doesn't exist
$nupkgsDir = "nupkgs"
if (!(Test-Path $nupkgsDir)) {
    New-Item -ItemType Directory -Path $nupkgsDir | Out-Null
    Write-Host "✅ Created nupkgs directory" -ForegroundColor Green
}

# Function to build and pack a project
function Build-And-Pack {
    param(
        [string]$ProjectPath,
        [string]$ProjectName
    )
    
    Write-Host "📦 Building and packing $ProjectName..." -ForegroundColor Yellow
    
    # Navigate to project directory
    Push-Location $ProjectPath
    
    try {
        # Clean and restore
        Write-Host "  🔄 Cleaning and restoring packages..." -ForegroundColor Cyan
        dotnet clean -c Release --verbosity quiet
        dotnet restore --verbosity quiet
        
        # Build
        Write-Host "  🔨 Building project..." -ForegroundColor Cyan
        dotnet build -c Release --no-restore --verbosity quiet
        
        if ($LASTEXITCODE -eq 0) {
            # Pack
            Write-Host "  📦 Creating NuGet package..." -ForegroundColor Cyan
            dotnet pack -c Release --no-build --output "../../../$nupkgsDir" --verbosity quiet
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✅ $ProjectName package created successfully" -ForegroundColor Green
            } else {
                Write-Host "  ❌ Failed to pack $ProjectName" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "  ❌ Failed to build $ProjectName" -ForegroundColor Red
            return $false
        }
    }
    finally {
        Pop-Location
    }
    
    return $true
}

# Build packages in dependency order
Write-Host "📋 Building packages in dependency order..." -ForegroundColor Yellow
Write-Host ""

$projects = @(
    @{ Path = "backend/Shared/MedTravel.Shared"; Name = "MedTravel.Shared" },
    @{ Path = "backend/Shared/MedTravel.Shared.Auth"; Name = "MedTravel.Shared.Auth" },
    @{ Path = "backend/Shared/MedTravel.Shared.Logging"; Name = "MedTravel.Shared.Logging" },
    @{ Path = "backend/Shared/MedTravel.Shared.Validation"; Name = "MedTravel.Shared.Validation" }
)

$successCount = 0
foreach ($project in $projects) {
    if (Build-And-Pack -ProjectPath $project.Path -ProjectName $project.Name) {
        $successCount++
    }
    Write-Host ""
}

# Check results
Write-Host "📊 Build Results:" -ForegroundColor Yellow
Write-Host "  ✅ Successful: $successCount/$($projects.Count)" -ForegroundColor Green
Write-Host "  📁 Packages created in: $nupkgsDir/" -ForegroundColor Cyan

if ($successCount -eq $projects.Count) {
    Write-Host ""
    Write-Host "🎉 All NuGet packages created successfully!" -ForegroundColor Green
    
    # List created packages
    Write-Host ""
    Write-Host "📦 Created packages:" -ForegroundColor Yellow
    Get-ChildItem -Path $nupkgsDir -Filter "*.nupkg" | ForEach-Object {
        Write-Host "  • $($_.Name)" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Host "🔧 Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Add local feed to NuGet sources:" -ForegroundColor White
    Write-Host "     dotnet nuget add source `"$(Get-Location)\$nupkgsDir`" --name `"LocalMedTravel`"" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Restore packages in your services:" -ForegroundColor White
    Write-Host "     dotnet restore MedTravel.sln" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  3. Build the solution:" -ForegroundColor White
    Write-Host "     dotnet build MedTravel.sln" -ForegroundColor Gray
    
} else {
    Write-Host ""
    Write-Host "❌ Some packages failed to build. Please check the errors above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✨ Local NuGet packages setup complete!" -ForegroundColor Green
