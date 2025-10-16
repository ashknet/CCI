# MedTravel - Medical Tourism Platform

A production-grade, microservices-based platform facilitating seamless medical travel and treatment booking for international and domestic patients in India.

## 🌟 Features

- **Comprehensive Search**: Type-ahead suggestions for hospitals, doctors, diseases, and locations
- **Doctor Profiles**: Detailed information including credentials, specialties, languages, and reviews
- **Real-Time Appointment Booking**: Calendar-based slot selection with instant confirmation
- **Travel Management**: International flights and domestic trains/buses booking integration
- **Accommodation**: Hotels near hospitals with filters by cost, amenities, and medical needs
- **Secure Messaging**: End-to-end encrypted communication with healthcare providers
- **Cost Transparency**: Itemized breakdowns for medical, travel, and accommodation expenses
- **Multilingual Support**: Available in English, Hindi, Telugu, Tamil, and Kannada
- **WCAG 2.2 AA Compliant**: Full accessibility features including keyboard navigation and screen reader support

## 🏗️ Architecture

### Microservices
- **User Management Service** (Port 5001): Authentication, profiles, notifications
- **Hospital Service** (Port 5002): Hospital/doctor search, appointments, reviews
- **Transportation & Accommodation Service** (Port 5003): Travel and hotel booking
- **Messaging Service** (Port 5004): Secure patient-provider communication

### Tech Stack

#### Backend
- **.NET 8** with C#
- **Entity Framework Core** with SQL Server
- **Azure Functions** for background workers
- **Serilog** for structured logging
- **JWT Authentication** with local dev mode bypass
- **OpenAPI/Swagger** documentation

#### Frontend
- **React 19.2** with TypeScript
- **Redux Toolkit** for state management
- **Tailwind CSS** for styling
- **i18next** for internationalization
- **Vite** for build tooling

#### Infrastructure
- **Docker** & **Docker Compose**
- **Kubernetes** with Helm charts
- **SQL Server 2022**
- **GitHub Actions** for CI/CD

## 🚀 Quick Start

### Prerequisites
- Docker Desktop or Docker Engine + Docker Compose
- Node.js 20+ (for frontend development)
- .NET 8 SDK (for backend development)
- SQL Server 2022 or Docker image

### Local Development (Single Command)

```bash
# Start all services with Docker Compose
docker-compose up --build

# Services will be available at:
# - Frontend: http://localhost:3000
# - User Service: http://localhost:5001
# - Hospital Service: http://localhost:5002
# - Transportation Service: http://localhost:5003
# - Messaging Service: http://localhost:5004
# - SQL Server: localhost:1433
```

### Manual Setup

#### Backend Services

```bash
# Restore dependencies
dotnet restore MedTravel.sln

# Run User Management Service
cd backend/UserManagementService/src/UserManagementService.Api
dotnet run

# Run Hospital Service
cd backend/HospitalService/src/HospitalService.Api
dotnet run

# Run other services similarly...
```

#### Frontend

```bash
cd frontend
npm install
npm run dev
```

## 🔐 Authentication

### Local Development Mode

The platform includes a **local development mode** that bypasses authentication for testing:

```json
// appsettings.json
{
  "AuthSettings": {
    "LocalDevMode": true,
    "LocalDevUser": {
      "UserId": "local-dev-user-001",
      "Email": "devuser@medtravel.local",
      "FirstName": "Dev",
      "LastName": "User",
      "Role": "patient",
      "Country": "USA",
      "City": "New York"
    }
  }
}
```

Set `LocalDevMode: false` for production with JWT authentication.

## 📚 API Documentation

Each service exposes Swagger documentation:

- User Management: http://localhost:5001/swagger
- Hospital Service: http://localhost:5002/swagger
- Transportation: http://localhost:5003/swagger
- Messaging: http://localhost:5004/swagger

### Key Endpoints

#### User Management Service
```
POST   /api/auth/register          - Register new user
POST   /api/auth/login             - Login
POST   /api/auth/refresh           - Refresh token
GET    /api/auth/profile           - Get user profile
PUT    /api/auth/profile           - Update profile
GET    /api/notifications          - Get notifications
```

#### Hospital Service
```
GET    /api/search/suggestions     - Type-ahead suggestions
POST   /api/search/hospitals       - Search hospitals
POST   /api/search/doctors         - Search doctors
GET    /api/appointments/doctor/{id}/available-slots
POST   /api/appointments           - Book appointment
GET    /api/appointments/my-appointments
PATCH  /api/appointments/{id}/cancel
```

## 🗄️ Database Schema

### User Management Database
- Users, Roles, UserRoles, Permissions, Sessions
- UserPreferences, InsurancePolicies, UserDocuments
- Notifications, NotificationTemplates, AuditLogs

### Hospital Database
- Hospitals, Departments, Doctors
- Specialties, Languages, Credentials, Accreditations
- Appointments, DoctorAvailability, Reviews

### Transportation & Accommodation Database
- Flights, Trains, TransportBookings
- Hotels, HotelRooms, AccommodationBookings
- CostBreakdowns

### Messaging Database
- Threads, Messages, MessageAttachments, MessageAudit

## 🐳 Docker Deployment

### Build Images

```bash
# Build all services
docker-compose build

# Build specific service
docker build -f backend/UserManagementService/src/UserManagementService.Api/Dockerfile -t medtravel-user-service .
```

### Environment Variables

```bash
# Connection string for SQL Server
ConnectionStrings__DefaultConnection="Server=sqlserver;Database=UserManagementDb;..."

# JWT Configuration
AuthSettings__JwtSecret="YourSuperSecretKeyThatIsAtLeast32CharactersLong!"
AuthSettings__LocalDevMode=false
```

## ☸️ Kubernetes Deployment

### Deploy with Helm

```bash
cd infrastructure/helm
helm install medtravel ./medtravel-chart

# Or with custom values
helm install medtravel ./medtravel-chart -f values.production.yaml
```

### Apply Manifests Directly

```bash
kubectl apply -f infrastructure/kubernetes/
```

## 🔄 CI/CD Pipeline

GitHub Actions workflows are configured for:

1. **Build & Test**: Runs on every push
2. **Docker Build**: Creates container images
3. **Security Scans**: SAST/DAST analysis
4. **Deploy to Staging**: Automatic deployment to staging environment
5. **Deploy to Production**: Manual approval required

```bash
# Trigger pipeline
git push origin main
```

## 🧪 Testing

### Unit Tests

```bash
dotnet test MedTravel.sln
```

### Integration Tests

```bash
cd backend/UserManagementService/tests
dotnet test
```

### Frontend Tests

```bash
cd frontend
npm run test
```

## 📊 Observability

### Logging
- Structured logging with **Serilog**
- Correlation IDs for distributed tracing
- Log aggregation to file and console

### Health Checks
- `/health` endpoint on each service
- Database connectivity checks
- Kubernetes liveness and readiness probes

### Metrics
- OpenTelemetry integration
- Prometheus-compatible metrics
- Grafana dashboards (in `infrastructure/observability/`)

## 🔒 Security

- **TLS/HTTPS** for all communications
- **JWT authentication** with refresh tokens
- **Role-based authorization** (patient, doctor, hospital_admin, support)
- **Input validation** with FluentValidation
- **SQL injection prevention** via parameterized queries
- **CORS** configuration
- **Rate limiting** on public endpoints
- **Audit logging** for sensitive operations

### Compliance
- **HIPAA** considerations for PHI handling
- **GDPR** data subject rights workflows
- Secure credential storage
- Data encryption at rest and in transit

## 🌐 Internationalization

Supported languages:
- English (en)
- Hindi (hi)
- Telugu (te)
- Tamil (ta)
- Kannada (kn)

```typescript
// Frontend usage
import { useTranslation } from 'react-i18next'
const { t, i18n } = useTranslation()
i18n.changeLanguage('hi')
```

## 🎨 Accessibility

- WCAG 2.2 AA compliant
- Keyboard navigation support
- Screen reader compatibility
- High contrast mode
- Focus management
- ARIA labels and roles

## 📁 Project Structure

```
medtravel/
├── backend/
│   ├── Shared/
│   │   ├── MedTravel.Shared/
│   │   ├── MedTravel.Shared.Auth/
│   │   ├── MedTravel.Shared.Logging/
│   │   └── MedTravel.Shared.Validation/
│   ├── UserManagementService/
│   │   └── src/
│   │       ├── UserManagementService.Api/
│   │       ├── UserManagementService.Core/
│   │       ├── UserManagementService.Infrastructure/
│   │       └── UserManagementService.Functions/
│   ├── HospitalService/
│   ├── TransportationAccommodationService/
│   └── MessagingService/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── store/
│   │   └── App.tsx
│   └── package.json
├── infrastructure/
│   ├── kubernetes/
│   ├── helm/
│   └── scripts/
├── docker-compose.yml
├── MedTravel.sln
└── README.md
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Email: support@medtravel.com
- Documentation: https://docs.medtravel.com

## 🗺️ Roadmap

- [ ] Mobile applications (iOS/Android)
- [ ] AI-powered doctor recommendations
- [ ] Telemedicine integration
- [ ] Insurance claim processing
- [ ] Multi-currency support
- [ ] Advanced analytics dashboard
- [ ] Patient health records integration

## 👥 Team

Developed with ❤️ by the MedTravel team

## 🙏 Acknowledgments

- Apollo Hospitals, Manipal Hospitals, and Lilavati Hospital for partnership
- Open source community for amazing tools and libraries
- Medical tourism advisory board for domain expertise

---

**Version**: 1.0.0  
**Last Updated**: October 2025
