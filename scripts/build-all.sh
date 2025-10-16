#!/bin/bash

# MedTravel Platform - Complete Build Script
# Builds NuGet packages and entire solution

set -e  # Exit on error

echo "======================================"
echo "  MedTravel Platform - Build Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Navigate to solution root
cd "$(dirname "$0")/.."
SOLUTION_ROOT=$(pwd)

echo -e "${BLUE}Solution root: ${SOLUTION_ROOT}${NC}"
echo ""

# Step 1: Build NuGet Packages
echo "======================================"
echo "  Step 1: Building NuGet Packages"
echo "======================================"

mkdir -p nupkgs

cd backend/Shared

echo "Building MedTravel.Shared..."
dotnet pack MedTravel.Shared -c Release -o ../../nupkgs
echo -e "${GREEN}✅ MedTravel.Shared.1.0.0.nupkg created${NC}"

echo "Building MedTravel.Shared.Auth..."
dotnet pack MedTravel.Shared.Auth -c Release -o ../../nupkgs
echo -e "${GREEN}✅ MedTravel.Shared.Auth.1.0.0.nupkg created${NC}"

echo "Building MedTravel.Shared.Logging..."
dotnet pack MedTravel.Shared.Logging -c Release -o ../../nupkgs
echo -e "${GREEN}✅ MedTravel.Shared.Logging.1.0.0.nupkg created${NC}"

echo "Building MedTravel.Shared.Validation..."
dotnet pack MedTravel.Shared.Validation -c Release -o ../../nupkgs
echo -e "${GREEN}✅ MedTravel.Shared.Validation.1.0.0.nupkg created${NC}"

cd ../..

echo ""
echo -e "${GREEN}✅ All NuGet packages built successfully${NC}"
echo ""

# Step 2: Add local NuGet source
echo "======================================"
echo "  Step 2: Configuring NuGet Sources"
echo "======================================"

# Remove existing LocalDev source if it exists
dotnet nuget remove source LocalDev 2>/dev/null || true

# Add local NuGet source
dotnet nuget add source "${SOLUTION_ROOT}/nupkgs" --name "LocalDev"
echo -e "${GREEN}✅ Local NuGet source configured${NC}"
echo ""

# Step 3: Restore packages
echo "======================================"
echo "  Step 3: Restoring Packages"
echo "======================================"

dotnet restore MedTravel.sln
echo -e "${GREEN}✅ Packages restored${NC}"
echo ""

# Step 4: Build solution
echo "======================================"
echo "  Step 4: Building Solution"
echo "======================================"

dotnet build MedTravel.sln --configuration Release --no-restore
echo -e "${GREEN}✅ Solution built successfully${NC}"
echo ""

# Step 5: Build frontend
echo "======================================"
echo "  Step 5: Building Frontend"
echo "======================================"

cd frontend
npm install
npm run build
cd ..

echo -e "${GREEN}✅ Frontend built successfully${NC}"
echo ""

# Summary
echo "======================================"
echo "  Build Complete!"
echo "======================================"
echo ""
echo -e "${GREEN}✅ NuGet packages: 4${NC}"
echo -e "${GREEN}✅ Backend services: 4${NC}"
echo -e "${GREEN}✅ Frontend: Built${NC}"
echo ""
echo "To start the platform:"
echo "  docker-compose up"
echo ""
echo "Or run services individually:"
echo "  cd backend/UserManagementService/src/UserManagementService.Api && dotnet run"
echo ""
echo -e "${GREEN}Build completed successfully!${NC}"
