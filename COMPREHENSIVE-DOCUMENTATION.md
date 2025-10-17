# 📚 MedTravel Platform - Comprehensive Documentation

## 🎯 Project Overview

MedTravel is a comprehensive medical tourism platform built with microservices architecture, designed to connect patients with healthcare providers across India. The platform facilitates hospital search, doctor appointments, medical consultations, and travel arrangements.

---

## 🏗️ Architecture Overview

### **Microservices Architecture**
- **User Management Service**: User authentication, profiles, and preferences
- **Hospital Service**: Hospital and doctor management, appointments, reviews
- **Transportation & Accommodation Service (TAService)**: Travel and hotel bookings
- **Messaging Service**: Doctor-patient communication

### **Technology Stack**
- **Backend**: .NET 8 with Entity Framework Core
- **Frontend**: React 19.2 with TypeScript, Redux Toolkit, Tailwind CSS
- **Database**: SQL Server with microservices-specific schemas
- **Authentication**: JWT with role-based access control
- **API**: RESTful APIs with OpenAPI/Swagger documentation

---

## 🗄️ Database Architecture

### **Database Schemas**
- **UserManagement**: Users, roles, preferences, sessions
- **Hospital**: Hospitals, doctors, appointments, reviews, specialties
- **Messaging**: Message threads and individual messages
- **TAService**: Hotels, flights, bookings, payments
- **Metadata**: Countries, cities, languages, diseases, specialties

### **Key Features**
- Database per service pattern
- Proper foreign key relationships
- Comprehensive indexing for performance
- Full-text search capabilities

---

## 🚀 Quick Start Guide

### **Prerequisites**
- .NET 8 SDK
- SQL Server 2019+
- Node.js 18+
- Visual Studio 2022 or VS Code

### **Backend Setup**
```bash
# Clone repository
git clone <repository-url>
cd MedTravel

# Restore NuGet packages
dotnet restore

# Build solution
dotnet build

# Run Hospital Service (example)
cd backend/HospitalService/src/HospitalService.Api
dotnet run
```

### **Frontend Setup**
```bash
# Navigate to frontend
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

### **Database Setup**
```sql
-- Execute database scripts in order
:r "MedTravel.Database/MedTravel-Complete-Database.sql"
:r "MedTravel.Database/TestData/00-Execute-All-TestData.sql"
```

---

## 📊 Test Data Overview

### **Comprehensive Test Data (1,500+ Records)**

| Entity | Count | Description |
|--------|-------|-------------|
| 👥 Users | 100 | Real Indian names, Hyderabad addresses |
| 🏥 Hospitals | 50 | Actual Hyderabad hospitals with real data |
| 👨‍⚕️ Doctors | 150 | Specialists with qualifications and fees |
| ⚕️ Specialties | 30 | Medical specializations |
| 📅 Appointments | 200 | Past/future appointments with statuses |
| ⭐ Reviews | 150 | Authentic hospital and doctor reviews |
| 💬 Threads | 100 | Patient-doctor conversations |
| 📝 Messages | 500 | Individual messages in threads |
| 🏨 Hotels | 50 | Hyderabad accommodation options |

### **Test Data Scripts**
- `01-Insert-Users-100.sql` - Test patients with verified accounts
- `02-Insert-Hospitals-50.sql` - Real Hyderabad hospitals
- `03-Insert-Specialties-30.sql` - Medical specialties
- `04-Insert-Doctors-150.sql` - Doctors across hospitals
- `05-Insert-Appointments-200.sql` - Appointments with realistic statuses
- `06-Insert-Reviews-150.sql` - Hospital and doctor reviews
- `07-Insert-MessageThreads-100.sql` - Patient-doctor conversations
- `08-Insert-Messages-500.sql` - Individual messages
- `09-Insert-Hotels-50.sql` - Hyderabad hotels
- `10-Insert-UserRoles-Preferences.sql` - User roles and preferences

### **Execution**
```sql
-- Run all test data
:r "00-Execute-All-TestData.sql"
```

---

## 🔧 API Documentation

### **Hospital Service API (v1)**

#### **Search Endpoints**
- `GET /api/v1/search/suggest?query={term}` - Fast search suggestions
- `POST /api/v1/search/hospitals` - Search hospitals
- `POST /api/v1/search/doctors` - Search doctors

#### **Hospital Endpoints**
- `GET /api/v1/Hospitals/{id}` - Get hospital by ID
- `GET /api/v1/Hospitals/{id}/reviews` - Get hospital reviews
- `GET /api/v1/Hospitals/{id}/departments` - Get departments
- `GET /api/v1/Hospitals/{id}/accreditations` - Get accreditations

#### **Doctor Endpoints**
- `GET /api/v1/Doctors/{id}` - Get doctor by ID
- `GET /api/v1/Doctors/hospital/{hospitalId}` - Get doctors by hospital
- `GET /api/v1/Doctors/specialty/{specialty}` - Get doctors by specialty
- `GET /api/v1/Doctors/{id}/reviews` - Get doctor reviews

#### **Appointment Endpoints**
- `POST /api/v1/Appointments` - Create appointment
- `GET /api/v1/Appointments/my-appointments` - Get my appointments
- `GET /api/v1/Appointments/doctor/{id}/available-slots` - Get available slots
- `DELETE /api/v1/Appointments/{id}/cancel` - Cancel appointment

#### **Health Check**
- `GET /health` - Health check endpoint

### **API Configuration**
```typescript
// Frontend API configuration
const API_BASE_URL = 'https://localhost:64685/api/v1';

// Example usage
apiClient.get(`${API_ENDPOINTS.SEARCH.SUGGESTIONS}?query=apollo`);
```

---

## ⚡ Performance Optimizations

### **Fast Search Implementation**
- **Backend**: ADO.NET with stored procedures for direct database access
- **Caching**: In-memory caching for frequently accessed data
- **Database**: Full-text search indexes for optimal performance
- **Frontend**: Debouncing to limit API calls during user input

### **Search Stored Procedure**
```sql
-- Optimized search procedure
EXEC Search.GetSearchSuggestions @SearchTerm = 'apollo', @MaxResults = 10;
```

### **Caching Strategy**
- 5-minute cache duration for search suggestions
- Automatic cache invalidation
- Memory-efficient caching with proper cleanup

---

## 🔐 Authentication & Security

### **JWT Authentication**
- Token-based authentication with refresh tokens
- Role-based access control (RBAC)
- Local development mode bypass for testing

### **User Roles**
- **Patient**: Can book appointments, view doctors, send messages
- **Doctor**: Can manage appointments, respond to messages
- **Hospital Admin**: Can manage hospital data and doctors
- **Support**: Can access all features for customer support

### **Security Features**
- Password hashing with BCrypt
- Email and phone verification
- Two-factor authentication support
- Session management and timeout

---

## 🎨 Frontend Architecture

### **Technology Stack**
- **React 19.2**: Latest React with concurrent features
- **TypeScript**: Type-safe development
- **Redux Toolkit**: State management
- **Tailwind CSS**: Utility-first styling
- **i18next**: Internationalization support

### **Key Components**
- **SearchBar**: Google-like instant search with debouncing
- **HospitalCard**: Hospital information display
- **DoctorProfile**: Doctor details and booking
- **AppointmentBooking**: Appointment scheduling
- **MessageThread**: Doctor-patient communication

### **State Management**
```typescript
// Redux slices
- authSlice: Authentication state
- searchSlice: Search functionality
- appointmentSlice: Appointment management
- hospitalSlice: Hospital data
```

---

## 🧪 Testing Scenarios

### **Search Testing**
```sql
-- Test hospital search
SELECT * FROM Hospital.Hospitals WHERE Name LIKE '%Apollo%';

-- Test doctor search
SELECT * FROM Hospital.Doctors WHERE FirstName LIKE '%Suresh%';

-- Test specialty search
SELECT * FROM Metadata.Specialties WHERE Name LIKE '%Cardio%';
```

### **Appointment Testing**
```sql
-- View all appointments
SELECT 
    u.FirstName + ' ' + u.LastName AS Patient,
    d.FirstName + ' ' + d.LastName AS Doctor,
    h.Name AS Hospital,
    a.ScheduledDate,
    a.Status
FROM Hospital.Appointments a
JOIN UserManagement.Users u ON a.PatientId = u.Id
JOIN Hospital.Doctors d ON a.DoctorId = d.Id
JOIN Hospital.Hospitals h ON d.HospitalId = h.Id;
```

### **Review Testing**
```sql
-- View all reviews
SELECT 
    u.FirstName + ' ' + u.LastName AS Reviewer,
    COALESCE(d.FirstName + ' ' + d.LastName, h.Name) AS ReviewedEntity,
    r.Rating,
    r.Comment
FROM Hospital.Reviews r
JOIN UserManagement.Users u ON r.PatientId = u.Id
LEFT JOIN Hospital.Doctors d ON r.DoctorId = d.Id
LEFT JOIN Hospital.Hospitals h ON r.HospitalId = h.Id;
```

### **Messaging Testing**
```sql
-- View message threads with counts
SELECT 
    t.Subject,
    t.IsActive,
    COUNT(m.Id) AS MessageCount,
    t.LastMessageAt
FROM Messaging.Threads t
LEFT JOIN Messaging.Messages m ON t.Id = m.ThreadId
GROUP BY t.Id, t.Subject, t.IsActive, t.LastMessageAt;
```

---

## 🚀 Deployment Guide

### **Docker Deployment**
```yaml
# docker-compose.yml
version: '3.8'
services:
  hospital-service:
    build: ./backend/HospitalService
    ports:
      - "64685:80"
    environment:
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=MedTravelDb;...
  
  frontend:
    build: ./frontend
    ports:
      - "3000:80"
    depends_on:
      - hospital-service
```

### **Kubernetes Deployment**
```yaml
# kubernetes deployment files in infrastructure/kubernetes/
- namespace.yaml
- ingress.yaml
- sqlserver-deployment.yaml
- user-management-deployment.yaml
```

### **Environment Configuration**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MedTravelDb;Trusted_Connection=true;"
  },
  "AuthSettings": {
    "LocalDevMode": false,
    "JwtSecretKey": "your-secret-key",
    "TokenExpiryMinutes": 60
  }
}
```

---

## 🔧 Troubleshooting

### **Common Issues**

#### **Build Errors**
```bash
# Clean and rebuild
dotnet clean
dotnet restore
dotnet build
```

#### **Database Connection Issues**
```sql
-- Check connection
SELECT @@VERSION;
SELECT DB_NAME();
```

#### **API Versioning Issues**
- Ensure all endpoints use `/api/v1/` prefix
- Check frontend API configuration
- Verify controller routing

#### **Search Performance Issues**
- Check full-text search indexes
- Verify stored procedure execution
- Monitor cache hit rates

### **Logging and Monitoring**
- Structured logging with Serilog
- Health checks for all services
- Prometheus metrics integration
- OpenTelemetry tracing

---

## 📈 Performance Metrics

### **Search Performance**
- **Target**: < 100ms response time for search suggestions
- **Implementation**: ADO.NET + Stored Procedures + Caching
- **Monitoring**: Response time tracking and cache hit rates

### **Database Performance**
- **Indexing**: Optimized indexes for search operations
- **Query Optimization**: Stored procedures for complex queries
- **Connection Pooling**: Efficient database connection management

### **Frontend Performance**
- **Bundle Size**: Optimized with code splitting
- **Loading**: Lazy loading for non-critical components
- **Caching**: Browser caching for static assets

---

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflows**
- **Build**: Automated build and test execution
- **Security**: SAST/DAST security scanning
- **Deploy**: Automated deployment to staging/production
- **Quality**: Code quality checks and coverage reports

### **Quality Gates**
- Unit test coverage > 80%
- Security scan passing
- Performance benchmarks met
- Code review approval

---

## 📚 Additional Resources

### **Documentation Files**
- `API-REFERENCE-V1.md` - Complete API documentation
- `ARCHITECTURE.md` - Detailed architecture overview
- `GETTING-STARTED.md` - Step-by-step setup guide

### **Scripts and Tools**
- `scripts/build-all.ps1` - Build automation script
- `scripts/create-local-nuget.ps1` - NuGet package creation
- `scripts/setup-local.ps1` - Local environment setup

### **Database Scripts**
- `MedTravel-Complete-Database.sql` - Complete database schema
- `Search-StoredProcedures.sql` - Optimized search procedures
- `TestData/` - Comprehensive test data scripts

---

## 🎯 Future Enhancements

### **Planned Features**
- Real-time notifications
- Video consultation integration
- Mobile app development
- Advanced analytics dashboard
- Multi-language support expansion

### **Performance Improvements**
- Redis caching implementation
- CDN integration for static assets
- Database sharding for scalability
- Microservices communication optimization

---

## 📞 Support and Contact

### **Development Team**
- **Backend**: .NET 8 microservices
- **Frontend**: React 19.2 with TypeScript
- **Database**: SQL Server with optimized schemas
- **DevOps**: Docker and Kubernetes deployment

### **Getting Help**
1. Check this documentation first
2. Review troubleshooting section
3. Check GitHub issues
4. Contact development team

---

## ✅ Project Status

### **Completed Features**
- ✅ Microservices architecture implementation
- ✅ Comprehensive test data (1,500+ records)
- ✅ Fast search with ADO.NET and caching
- ✅ API versioning and documentation
- ✅ Frontend with React 19.2
- ✅ Database optimization and indexing
- ✅ Authentication and authorization
- ✅ Doctor-patient messaging system

### **Ready for Production**
- ✅ All APIs implemented and tested
- ✅ Database with realistic test data
- ✅ Frontend with modern UI/UX
- ✅ Performance optimizations in place
- ✅ Security measures implemented
- ✅ Comprehensive documentation

**The MedTravel platform is ready for comprehensive testing and production deployment!** 🚀
