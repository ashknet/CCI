# Getting Started with MedTravel Platform

## Quick Start (5 Minutes)

### Prerequisites
- Docker Desktop installed and running
- 8GB+ RAM available
- 20GB+ disk space

### Start the Platform

**Option 1: Using Setup Script (Recommended)**

Windows:
```powershell
.\scripts\setup-local.ps1
```

Linux/Mac:
```bash
chmod +x scripts/setup-local.sh
./scripts/setup-local.sh
```

**Option 2: Manual Start**

```bash
docker-compose up --build
```

### Access the Platform

After ~30 seconds, the platform will be available at:

- **Frontend**: http://localhost:3000
- **User Management API**: http://localhost:5001/swagger
- **Hospital Service API**: http://localhost:5002/swagger
- **Transportation Service API**: http://localhost:5003/swagger
- **Messaging Service API**: http://localhost:5004/swagger

### Default Credentials (Local Dev Mode)

Authentication is bypassed in local development mode. The system automatically logs you in as:
- **Email**: devuser@medtravel.local
- **Role**: patient
- **Location**: New York, USA

## Feature Walkthrough

### 1. Search for Hospitals and Doctors

1. Navigate to http://localhost:3000
2. Use the search bar on the homepage
3. Type at least 3 characters to see suggestions
4. Results are categorized by:
   - Hospitals
   - Doctors
   - Locations
   - Diseases/Conditions

### 2. View Doctor Profile

1. Click on any doctor from search results
2. View comprehensive profile:
   - Qualifications and credentials
   - Years of experience
   - Specialties
   - Languages spoken
   - Patient reviews and ratings
   - Consultation fees

### 3. Book an Appointment

1. From doctor profile, select a date
2. View available time slots
3. Choose a slot and provide:
   - Reason for visit
   - Any special requirements
4. Confirm booking

### 4. Plan Travel

1. After booking appointment, navigate to Travel section
2. For international users:
   - Search flights by:
     - Best option
     - Cheapest
     - Fastest
   - View recommendations based on appointment date
3. For domestic users:
   - View train and bus options
   - Redirect to booking partners

### 5. Book Accommodation

1. Navigate to Accommodation section
2. Search hotels near the hospital
3. Filter by:
   - Price range
   - Distance from hospital
   - Amenities
   - Accessibility features
   - Medical condition-specific needs
4. View stay duration recommendations

### 6. Unified Checkout

1. Review your complete booking:
   - Appointment details and cost
   - Travel costs
   - Accommodation costs
2. See transparent cost breakdown
3. Complete payment
4. Hospital/clinic automatically notified

### 7. Secure Messaging

1. Navigate to Messages
2. Start conversation with:
   - Your doctor
   - Hospital staff
   - Support team
3. Send messages and attachments
4. Messages are linked to your bookings

### 8. Manage Bookings

1. Go to "My Bookings"
2. View all:
   - Upcoming appointments
   - Travel bookings
   - Hotel reservations
3. Cancel or reschedule as needed
4. Access pre-travel checklists

## API Usage Examples

### Register a New User

```bash
curl -X POST http://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "patient@example.com",
    "password": "SecurePass123!",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+1-555-0123",
    "dateOfBirth": "1990-01-01",
    "gender": "Male",
    "nationality": "American",
    "country": "USA",
    "city": "New York"
  }'
```

### Login

```bash
curl -X POST http://localhost:5001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "patient@example.com",
    "password": "SecurePass123!"
  }'
```

### Search Hospitals

```bash
curl -X POST http://localhost:5002/api/search/hospitals \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "query": "cardiology",
    "city": "Hyderabad",
    "pageNumber": 1,
    "pageSize": 10
  }'
```

### Get Type-Ahead Suggestions

```bash
curl http://localhost:5002/api/search/suggestions?query=car \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Get Available Appointment Slots

```bash
curl "http://localhost:5002/api/appointments/doctor/DOCTOR_ID/available-slots?startDate=2025-10-15&endDate=2025-10-22" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Book an Appointment

```bash
curl -X POST http://localhost:5002/api/appointments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "doctorId": "DOCTOR_ID",
    "scheduledDate": "2025-10-20",
    "scheduledTime": "10:00:00",
    "reasonForVisit": "Annual checkup"
  }'
```

## Configuration

### Switching Between Local and Production Mode

Edit `appsettings.json` in each service:

**Local Development Mode (Default)**:
```json
{
  "AuthSettings": {
    "LocalDevMode": true,
    "LocalDevUser": {
      "UserId": "local-dev-user-001",
      "Email": "devuser@medtravel.local",
      "Role": "patient"
    }
  }
}
```

**Production Mode**:
```json
{
  "AuthSettings": {
    "LocalDevMode": false,
    "JwtSecret": "YOUR_SECURE_SECRET_KEY",
    "JwtIssuer": "MedTravelPlatform",
    "JwtAudience": "MedTravelUsers",
    "JwtExpirationMinutes": 60
  }
}
```

### Database Connection Strings

Connection strings are configured in `docker-compose.yml` and `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=sqlserver;Database=YourDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True;"
  }
}
```

## Troubleshooting

### Services Not Starting

1. Check Docker is running:
   ```bash
   docker ps
   ```

2. Check service logs:
   ```bash
   docker-compose logs user-management-service
   docker-compose logs hospital-service
   ```

3. Restart services:
   ```bash
   docker-compose down
   docker-compose up --build
   ```

### Database Connection Errors

1. Ensure SQL Server is running:
   ```bash
   docker-compose ps sqlserver
   ```

2. Wait for SQL Server to be fully initialized (30 seconds)

3. Check SQL Server logs:
   ```bash
   docker-compose logs sqlserver
   ```

### Port Conflicts

If ports are already in use, modify `docker-compose.yml`:

```yaml
services:
  user-management-service:
    ports:
      - "5011:80"  # Change 5001 to 5011
```

### Frontend Not Loading

1. Clear browser cache
2. Check if frontend container is running:
   ```bash
   docker-compose ps frontend
   ```
3. Rebuild frontend:
   ```bash
   docker-compose up --build frontend
   ```

## Development Workflow

### Backend Development

1. Make changes to service code
2. Rebuild specific service:
   ```bash
   docker-compose up --build user-management-service
   ```

### Frontend Development

For faster development, run frontend locally:

```bash
cd frontend
npm install
npm run dev
```

Frontend will be available at http://localhost:3000 with hot reload.

### Database Migrations

Run migrations for a service:

```bash
cd backend/UserManagementService/src/UserManagementService.Api
dotnet ef migrations add MigrationName
dotnet ef database update
```

## Testing

### Run All Tests

```bash
dotnet test MedTravel.sln
```

### Run Specific Service Tests

```bash
cd backend/UserManagementService/tests
dotnet test
```

### Frontend Tests

```bash
cd frontend
npm test
```

## Production Deployment

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed production deployment instructions.

Quick overview:
1. Set `LocalDevMode: false` in all services
2. Configure production connection strings and secrets
3. Build Docker images
4. Deploy to Kubernetes cluster
5. Configure Ingress and SSL certificates

## Multilingual Support

Change language in the frontend:

1. Click language toggle in header (English ⇄ हिंदी)
2. Or programmatically:
   ```typescript
   import { useTranslation } from 'react-i18next'
   const { i18n } = useTranslation()
   i18n.changeLanguage('hi') // Hindi
   i18n.changeLanguage('te') // Telugu
   i18n.changeLanguage('ta') // Tamil
   ```

## Accessibility Features

- **Keyboard Navigation**: Tab through all interactive elements
- **Screen Reader**: ARIA labels on all important elements
- **High Contrast**: Accessible color combinations
- **Focus Indicators**: Clear focus states
- **Skip Links**: Skip to main content

## Support

For help:
- Check logs: `docker-compose logs`
- Review [README.md](../README.md)
- Review [ARCHITECTURE.md](./ARCHITECTURE.md)
- Open an issue on GitHub

## Next Steps

1. Explore the Swagger documentation for each service
2. Try different search queries and filters
3. Book a sample appointment
4. Test the messaging feature
5. Review the unified cost breakdown
6. Customize the platform for your needs

---

**Happy Coding! 🚀**
