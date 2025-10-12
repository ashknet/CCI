# Medical Travel Booking Platform

A comprehensive, full-stack medical travel booking platform built with .NET 8 microservices architecture and React. This platform connects patients with top hospitals, doctors, and comprehensive travel services worldwide.

## 🏗️ Architecture Overview

### Microservices Architecture
- **12+ Independent Microservices**: Each service is independently deployable and scalable
- **API Gateway**: Centralized entry point using YARP (Yet Another Reverse Proxy)
- **Event-Driven**: RabbitMQ for asynchronous messaging
- **Database per Service**: SQL Server with individual databases for data isolation
- **Distributed Caching**: Redis for performance optimization

### Technology Stack

#### Backend
- **.NET 8.0**: Latest stable version for all microservices
- **Entity Framework Core 8.0**: ORM for database operations
- **ASP.NET Core**: Web API framework
- **MassTransit**: Message bus abstraction for RabbitMQ
- **Serilog**: Structured logging
- **JWT**: Secure authentication
- **Swagger/OpenAPI**: API documentation

#### Frontend
- **React 18**: Modern UI library
- **TypeScript**: Type-safe JavaScript
- **Material-UI (MUI)**: Component library
- **Vite**: Fast build tool
- **React Router**: Navigation
- **Zustand**: State management
- **React Query**: Server state management
- **Axios**: HTTP client
- **i18next**: Internationalization

#### Infrastructure
- **Azure Functions**: Background processing
- **Docker**: Containerization
- **Docker Compose**: Local development orchestration
- **GitHub Actions**: CI/CD pipeline
- **SQL Server 2022**: Primary database
- **RabbitMQ**: Message broker
- **Redis**: Caching layer

## 📁 Project Structure

```
MedicalTravelBooking/
├── Database/                          # SQL Server database scripts
│   ├── 01_UserDatabase.sql
│   ├── 02_ProviderDatabase.sql
│   ├── 03_AppointmentDatabase.sql
│   ├── 04_TransportationDatabase.sql
│   ├── 05_AccommodationDatabase.sql
│   ├── 06_PaymentDatabase.sql
│   ├── 07_MessagingDatabase.sql
│   ├── 08_NotificationDatabase.sql
│   ├── 09_AnalyticsDatabase.sql
│   ├── 10_ReviewDatabase.sql
│   └── 11_ChecklistDatabase.sql
│
├── Services/                          # Microservices
│   ├── UserService/                  # User management & authentication
│   ├── ProviderService/              # Hospitals & doctors directory
│   ├── SearchService/                # Full-text search
│   ├── AppointmentService/           # Appointment booking & scheduling
│   ├── TransportationService/        # Flight, train, bus booking
│   ├── AccommodationService/         # Hotel & accommodation booking
│   ├── PaymentService/               # Payment processing
│   ├── MessagingService/             # In-app messaging
│   ├── NotificationService/          # Email, SMS, push notifications
│   ├── AnalyticsService/             # Usage analytics & tracking
│   ├── ReviewService/                # Reviews & ratings
│   └── ChecklistService/             # Travel checklists & guidance
│
├── Gateway/                           # API Gateway
│   └── ApiGateway/                   # YARP-based gateway
│
├── Functions/                         # Azure Functions
│   ├── UserServiceFunction/          # Background jobs for users
│   ├── AppointmentFunction/          # Appointment reminders
│   ├── NotificationFunction/         # Notification processing
│   └── AnalyticsFunction/            # Analytics aggregation
│
├── Frontend/                          # React application
│   └── medical-travel-app/
│       ├── src/
│       │   ├── api/                  # API client
│       │   ├── components/           # Reusable components
│       │   ├── pages/                # Page components
│       │   ├── store/                # State management
│       │   ├── hooks/                # Custom hooks
│       │   ├── utils/                # Utility functions
│       │   └── types/                # TypeScript types
│       └── public/
│
├── docker-compose.yml                 # Docker orchestration
├── Dockerfile                         # Multi-service Dockerfile
├── .github/workflows/ci-cd.yml       # CI/CD pipeline
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **.NET 8.0 SDK**: [Download](https://dotnet.microsoft.com/download)
- **Node.js 18+**: [Download](https://nodejs.org/)
- **SQL Server 2022**: [Download](https://www.microsoft.com/sql-server/sql-server-downloads)
- **Docker Desktop**: [Download](https://www.docker.com/products/docker-desktop)
- **Visual Studio 2022** or **VS Code**

### Local Development Setup

#### 1. Database Setup

Run all SQL scripts in the `Database/` folder in order:

```bash
sqlcmd -S localhost -U sa -P YourPassword -i Database/01_UserDatabase.sql
sqlcmd -S localhost -U sa -P YourPassword -i Database/02_ProviderDatabase.sql
# ... continue for all scripts
```

Or use SQL Server Management Studio to execute the scripts.

#### 2. Backend Services

```bash
# Restore dependencies
dotnet restore

# Run User Service
cd Services/UserService
dotnet run

# Run Provider Service (in new terminal)
cd Services/ProviderService
dotnet run

# Continue for other services...
```

Each service will start on a different port:
- UserService: https://localhost:5001
- ProviderService: https://localhost:5002
- AppointmentService: https://localhost:5003
- etc.

#### 3. Frontend Application

```bash
cd Frontend/medical-travel-app

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend will be available at: http://localhost:3000

#### 4. Using Docker Compose (Recommended)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

Services will be available at:
- Frontend: http://localhost:3000
- API Gateway: http://localhost:5000
- Individual services: 5001-5012

## 🔧 Configuration

### Backend Configuration

Each service has an `appsettings.json` file:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=YourDB;..."
  },
  "JwtSettings": {
    "SecretKey": "your-secret-key",
    "Issuer": "MedicalTravelPlatform",
    "Audience": "MedicalTravelUsers"
  },
  "RabbitMQ": {
    "Host": "localhost",
    "Username": "guest",
    "Password": "guest"
  }
}
```

### Frontend Configuration

Create `.env.local` file:

```
VITE_API_BASE_URL=http://localhost:5000/api
VITE_APP_NAME=Medical Travel Platform
```

## 📚 API Documentation

### Swagger Documentation

Each microservice exposes Swagger documentation:

- User Service: https://localhost:5001/swagger
- Provider Service: https://localhost:5002/swagger
- Appointment Service: https://localhost:5003/swagger
- etc.

### Key API Endpoints

#### Authentication & User Management
```
POST   /api/auth/register          - Register new user
POST   /api/auth/login             - User login
POST   /api/auth/refresh-token     - Refresh access token
GET    /api/users/me               - Get current user
PUT    /api/users/me               - Update user profile
```

#### Provider Directory
```
GET    /api/hospitals              - List hospitals
GET    /api/hospitals/{id}         - Get hospital details
GET    /api/doctors                - Search doctors
GET    /api/doctors/{id}           - Get doctor profile
GET    /api/specialties            - List specialties
```

#### Appointments
```
GET    /api/appointments/availability   - Check availability
POST   /api/appointments                - Book appointment
GET    /api/appointments/{id}           - Get appointment details
PUT    /api/appointments/{id}           - Update appointment
DELETE /api/appointments/{id}           - Cancel appointment
```

#### Transportation
```
GET    /api/transportation/flights      - Search flights
GET    /api/transportation/trains       - Search trains
GET    /api/transportation/buses        - Search buses
POST   /api/transportation/book         - Book transportation
```

#### Accommodation
```
GET    /api/accommodation/search        - Search accommodations
GET    /api/accommodation/{id}          - Get accommodation details
POST   /api/accommodation/book          - Book accommodation
```

#### Payment
```
POST   /api/payments/process            - Process payment
GET    /api/payments/{id}               - Get payment status
POST   /api/payments/refund             - Request refund
GET    /api/invoices/{id}               - Get invoice
```

#### Reviews
```
GET    /api/reviews/doctor/{id}         - Get doctor reviews
GET    /api/reviews/hospital/{id}       - Get hospital reviews
POST   /api/reviews                     - Submit review
PUT    /api/reviews/{id}                - Update review
```

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Role-Based Authorization**: Patient, Doctor, Admin, SystemAdmin roles
- **Password Hashing**: Using ASP.NET Core Identity password hasher
- **HTTPS**: Enforced in production
- **CORS**: Configured for frontend access
- **Input Validation**: FluentValidation for request validation
- **SQL Injection Protection**: Parameterized queries via EF Core
- **XSS Protection**: Content security headers
- **Rate Limiting**: API throttling (recommended for production)

## 🌐 Internationalization

The platform supports multiple languages:
- English (default)
- Spanish
- French
- German
- Arabic
- Hindi
- Mandarin

Frontend uses i18next for translations. Backend returns localized content based on Accept-Language header.

## 📊 Monitoring & Logging

- **Serilog**: Structured logging across all services
- **Application Insights**: Azure monitoring (production)
- **Health Checks**: `/health` endpoint on each service
- **Metrics**: Performance and usage metrics
- **Error Tracking**: Centralized error logging

## 🧪 Testing

```bash
# Run all tests
dotnet test

# Run specific service tests
cd Services/UserService
dotnet test

# Frontend tests
cd Frontend/medical-travel-app
npm test
```

## 🚢 Deployment

### Azure Deployment

1. **Provision Azure Resources**:
   - Azure App Service (for microservices)
   - Azure SQL Database
   - Azure Service Bus
   - Azure Functions
   - Azure Storage
   - Azure CDN (for frontend)

2. **Configure CI/CD**:
   - GitHub Actions workflow is pre-configured
   - Set secrets in GitHub repository settings
   - Push to `main` branch to trigger deployment

3. **Environment Variables**:
   - Set production connection strings
   - Configure API keys (SendGrid, payment gateways)
   - Set JWT secret keys

### Docker Deployment

```bash
# Build images
docker-compose build

# Push to registry
docker-compose push

# Deploy to production
docker-compose -f docker-compose.prod.yml up -d
```

## 📈 Features

### Core Features
- ✅ Advanced search (doctors, hospitals, diseases, locations)
- ✅ Doctor profiles with reviews and ratings
- ✅ Real-time appointment booking
- ✅ Transportation booking (flights, trains, buses)
- ✅ Accommodation booking near hospitals
- ✅ Secure payment processing
- ✅ In-app messaging between patients and providers
- ✅ Email/SMS/Push notifications
- ✅ Multi-language support
- ✅ Travel checklists and guidance
- ✅ Post-treatment follow-up scheduling
- ✅ Cost estimates and transparency
- ✅ User analytics and tracking
- ✅ Review and rating system

### Admin Features
- Dashboard with analytics
- User management
- Provider management
- Content moderation
- System monitoring
- Report generation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👥 Team

- **Architecture**: Microservices, Event-Driven Design
- **Backend**: .NET 8, Entity Framework Core, ASP.NET Core
- **Frontend**: React, TypeScript, Material-UI
- **DevOps**: Docker, Azure, GitHub Actions
- **Database**: SQL Server, Redis

## 📞 Support

For support and questions:
- Email: support@medicaltravel.com
- Documentation: https://docs.medicaltravel.com
- Issues: GitHub Issues

## 🗺️ Roadmap

### Phase 1 (Current)
- ✅ Core microservices implementation
- ✅ User authentication and management
- ✅ Provider directory
- ✅ Booking system
- ✅ Frontend application

### Phase 2 (Q2 2025)
- [ ] Mobile applications (iOS/Android)
- [ ] Advanced AI-powered recommendations
- [ ] Telemedicine integration
- [ ] Insurance claim processing
- [ ] Multi-currency support

### Phase 3 (Q3 2025)
- [ ] Blockchain-based medical records
- [ ] IoT device integration
- [ ] Advanced analytics dashboard
- [ ] Partnership marketplace
- [ ] White-label solutions

## 🎯 Best Practices Implemented

- **Clean Architecture**: Separation of concerns
- **SOLID Principles**: Maintainable and scalable code
- **Domain-Driven Design**: Business logic focused
- **CQRS Pattern**: Command-Query Responsibility Segregation
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Loose coupling
- **Async/Await**: Non-blocking operations
- **Error Handling**: Comprehensive exception management
- **Logging**: Structured and searchable logs
- **Security**: Industry-standard practices
- **Testing**: Unit, integration, and E2E tests
- **Documentation**: Comprehensive inline and external docs
- **Code Quality**: Consistent formatting and standards

---

Built with ❤️ for global healthcare access
