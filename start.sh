#!/bin/bash
set -e

echo "Starting Hospital Service API..."

# Navigate to the API project directory
cd backend/HospitalService/src/HospitalService.Api

echo "Running the application..."
dotnet run --configuration Release --urls http://0.0.0.0:$PORT
