#!/bin/bash
set -e

echo "======================================"
echo "  MedTravel Platform - Build Script  "
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for .NET SDK
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION=$(dotnet --version)
    echo -e "${GREEN}✓${NC} .NET SDK found: $DOTNET_VERSION"
    BUILD_BACKEND=true
else
    echo -e "${RED}✗${NC} .NET SDK not found. Backend build will be skipped."
    echo "  Install from: https://dot.net/download"
    BUILD_BACKEND=false
fi

# Check for Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓${NC} Node.js found: $NODE_VERSION"
    BUILD_FRONTEND=true
else
    echo -e "${RED}✗${NC} Node.js not found. Frontend build will be skipped."
    echo "  Install from: https://nodejs.org"
    BUILD_FRONTEND=false
fi

echo ""

# Build Backend
if [ "$BUILD_BACKEND" = true ]; then
    echo -e "${BLUE}Building Backend...${NC}"
    echo "----------------------------------------"
    
    echo "Restoring dependencies..."
    dotnet restore MedTravel.sln
    
    echo "Building solution..."
    dotnet build MedTravel.sln --configuration Release --no-restore
    
    echo -e "${GREEN}✓ Backend build completed successfully!${NC}"
    echo ""
fi

# Build Frontend
if [ "$BUILD_FRONTEND" = true ]; then
    echo -e "${BLUE}Building Frontend...${NC}"
    echo "----------------------------------------"
    
    cd frontend
    
    echo "Installing dependencies..."
    npm install
    
    echo "Building React application..."
    npm run build
    
    cd ..
    
    echo -e "${GREEN}✓ Frontend build completed successfully!${NC}"
    echo ""
fi

# Summary
echo "======================================"
echo "  Build Summary"
echo "======================================"
if [ "$BUILD_BACKEND" = true ]; then
    echo -e "Backend:  ${GREEN}✓ SUCCESS${NC}"
else
    echo -e "Backend:  ${RED}⏭ SKIPPED${NC} (No .NET SDK)"
fi

if [ "$BUILD_FRONTEND" = true ]; then
    echo -e "Frontend: ${GREEN}✓ SUCCESS${NC}"
else
    echo -e "Frontend: ${RED}⏭ SKIPPED${NC} (No Node.js)"
fi
echo "======================================"

if [ "$BUILD_BACKEND" = true ] && [ "$BUILD_FRONTEND" = true ]; then
    echo -e "${GREEN}🎉 All builds completed successfully!${NC}"
    exit 0
elif [ "$BUILD_BACKEND" = true ] || [ "$BUILD_FRONTEND" = true ]; then
    echo -e "${BLUE}ℹ Some builds completed. Install missing tools to build everything.${NC}"
    exit 0
else
    echo -e "${RED}❌ No builds completed. Install .NET SDK and/or Node.js.${NC}"
    exit 1
fi
