#!/bin/bash

echo "🚀 MedTravel Platform - Local Setup Script"
echo "=========================================="

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ Prerequisites satisfied"

# Start services
echo ""
echo "Starting all services with Docker Compose..."
docker-compose up -d --build

echo ""
echo "⏳ Waiting for services to be healthy..."
sleep 30

# Check health
echo ""
echo "Checking service health..."

services=(
    "http://localhost:5001/health:User Management"
    "http://localhost:5002/health:Hospital"
    "http://localhost:5003/health:Transportation"
    "http://localhost:5004/health:Messaging"
    "http://localhost:3000:Frontend"
)

all_healthy=true

for service in "${services[@]}"; do
    IFS=':' read -r url name <<< "$service"
    if curl -f -s "$url" > /dev/null; then
        echo "✅ $name Service is healthy"
    else
        echo "❌ $name Service is not responding"
        all_healthy=false
    fi
done

echo ""
if [ "$all_healthy" = true ]; then
    echo "🎉 All services are running!"
    echo ""
    echo "Access the platform:"
    echo "  Frontend:        http://localhost:3000"
    echo "  User API:        http://localhost:5001/swagger"
    echo "  Hospital API:    http://localhost:5002/swagger"
    echo "  Transport API:   http://localhost:5003/swagger"
    echo "  Messaging API:   http://localhost:5004/swagger"
    echo ""
    echo "Default credentials (Local Dev Mode):"
    echo "  Email: devuser@medtravel.local"
    echo "  (Authentication bypassed in local mode)"
else
    echo "⚠️  Some services failed to start. Check logs with:"
    echo "  docker-compose logs"
fi
