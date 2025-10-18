#!/bin/bash
set -e

echo "Starting build process..."

# Navigate to the API project directory
cd backend/HospitalService/src/HospitalService.Api

echo "Restoring packages..."
dotnet restore

echo "Building project..."
dotnet build --configuration Release

echo "Build completed successfully!"
