# MedTravel Platform - Architecture

## System Overview

MedTravel is a microservices-based platform designed for medical tourism, enabling patients to discover, book, and manage medical treatments in India with integrated travel and accommodation services.

## Architecture Principles

1. **Microservices Architecture**: Each service is independently deployable and scalable
2. **API-First Design**: RESTful APIs with OpenAPI documentation
3. **Database per Service**: Each microservice owns its data store
4. **Event-Driven Communication**: Asynchronous messaging for cross-service communication
5. **Container-Native**: Designed for Kubernetes deployment
6. **Security by Design**: Authentication, authorization, and encryption at every layer

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Frontend (React)                     │
│              Port 3000 - Web Application                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ HTTPS/REST
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                    API Gateway / Ingress                     │
│            (Load Balancing, Rate Limiting, SSL)              │
└─────┬────────────────┬──────────────┬──────────────┬────────┘
      │                │              │              │
      │                │              │              │
┌─────▼─────┐   ┌─────▼─────┐  ┌────▼──────┐  ┌───▼────────┐
│   User    │   │ Hospital  │  │Transport  │  │ Messaging  │
│Management │   │  Service  │  │& Accomm.  │  │  Service   │
│ Service   │   │           │  │ Service   │  │            │
│Port 5001  │   │Port 5002  │  │Port 5003  │  │Port 5004   │
└─────┬─────┘   └─────┬─────┘  └────┬──────┘  └─────┬──────┘
      │               │              │               │
┌─────▼─────┐   ┌────▼──────┐  ┌───▼────────┐ ┌────▼───────┐
│   User    │   │ Hospital  │  │Transport   │ │ Messaging  │
│    DB     │   │    DB     │  │& Accomm. DB│ │     DB     │
│ (SQL)     │   │  (SQL)    │  │   (SQL)    │ │   (SQL)    │
└───────────┘   └───────────┘  └────────────┘ └────────────┘
```

## Microservices

### 1. User Management Service
**Responsibility**: User authentication, authorization, profiles, and notifications

**Key Features**:
- User registration and login (JWT-based auth)
- Profile management
- Role-based access control (patient, doctor, hospital_admin, support)
- User preferences and settings
- Insurance policy management
- Notification scheduling and delivery
- Audit logging

**Database Tables**:
- Users, Roles, UserRoles, Permissions, Sessions
- UserPreferences, InsurancePolicies, UserDocuments
- Notifications, NotificationTemplates, AuditLogs

**APIs**:
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/profile`
- `GET /api/notifications`

### 2. Hospital Service
**Responsibility**: Hospital/doctor discovery, appointment booking, and reviews

**Key Features**:
- Full-text search for hospitals, doctors, diseases, locations
- Type-ahead suggestions (3+ characters)
- Doctor profiles with credentials, specialties, languages
- Real-time appointment availability
- Booking and rescheduling
- Patient reviews and ratings

**Database Tables**:
- Hospitals, Departments, Doctors
- Specialties, Languages, Credentials, Accreditations
- Appointments, DoctorAvailability, Reviews
- Diseases, DiseaseSpecialty mappings

**APIs**:
- `GET /api/search/suggestions`
- `POST /api/search/hospitals`
- `POST /api/search/doctors`
- `GET /api/appointments/doctor/{id}/available-slots`
- `POST /api/appointments`

### 3. Transportation & Accommodation Service
**Responsibility**: Travel and hotel booking management

**Key Features**:
- International flight search and recommendations
- Domestic train/bus integration
- Hotel search near hospitals
- Filters by cost, amenities, medical needs
- Unified cost breakdown
- Payment integration

**Database Tables**:
- Flights, Airlines, Trains
- TransportBookings
- Hotels, HotelRooms, AccommodationBookings
- CostBreakdowns

**APIs**:
- `POST /api/transport/search-flights`
- `POST /api/transport/book`
- `GET /api/accommodation/search`
- `POST /api/accommodation/book`
- `GET /api/cost-breakdown/{userId}`

### 4. Messaging Service
**Responsibility**: Secure patient-provider communication

**Key Features**:
- Threaded conversations
- Message attachments
- Read receipts
- Audit trail
- Link threads to bookings/appointments

**Database Tables**:
- Threads, Messages, MessageAttachments
- MessageAudit

**APIs**:
- `GET /api/messages/threads`
- `POST /api/messages/threads/{id}/messages`
- `GET /api/messages/threads/{id}`

## Background Workers (Azure Functions)

Each service has dedicated background workers for:

1. **User Management**:
   - Notification dispatch (email/SMS/push)
   - Session cleanup
   - User activity aggregation

2. **Hospital Service**:
   - Search index updates
   - Appointment reminders
   - Review aggregation for ratings

3. **Transportation & Accommodation**:
   - Availability polling
   - Price updates
   - Booking confirmation processing

4. **Messaging**:
   - Message delivery retries
   - Thread archival
   - Audit log compaction

## Data Flow Examples

### Booking Flow
1. User searches for doctors → Hospital Service
2. User views doctor profile → Hospital Service
3. User books appointment → Hospital Service
4. User books flight → Transportation Service
5. User books hotel → Transportation Service
6. User completes checkout → Cost breakdown aggregated
7. Notifications sent → User Management Service
8. User messages doctor → Messaging Service

### Authentication Flow
1. User registers/logs in → User Management Service
2. Service generates JWT access token + refresh token
3. Token stored in browser localStorage
4. Subsequent requests include JWT in Authorization header
5. Each service validates JWT using shared secret
6. **Local Dev Mode**: Authentication bypassed, default user injected

## Security Architecture

### Authentication
- **Production**: JWT-based with RS256 signing
- **Local Dev**: Configurable bypass with default user injection

### Authorization
- Role-based access control (RBAC)
- Permission checks at API endpoints
- Service-to-service authentication

### Data Protection
- TLS 1.3 for all communications
- Database encryption at rest
- Secrets management via environment variables and vaults
- Input validation and sanitization
- SQL injection prevention
- XSS protection

## Scalability & Performance

### Horizontal Scaling
- Stateless services enable horizontal scaling
- Kubernetes HPA (Horizontal Pod Autoscaler)
- Load balancing via Ingress controller

### Caching Strategy
- Redis for session storage
- Database query result caching
- CDN for static frontend assets

### Database Optimization
- Indexed queries for search operations
- Stored procedures for complex operations
- Connection pooling
- Read replicas for reporting

## Observability

### Logging
- Structured logging with Serilog
- Correlation IDs for distributed tracing
- Log levels: Debug, Info, Warning, Error, Critical

### Monitoring
- Prometheus metrics
- Grafana dashboards
- Health check endpoints
- Kubernetes liveness/readiness probes

### Tracing
- OpenTelemetry integration
- Distributed tracing across services
- Request/response tracking

## Deployment Architecture

### Kubernetes Resources
- **Deployments**: One per microservice
- **Services**: ClusterIP for internal, LoadBalancer for external
- **ConfigMaps**: Configuration data
- **Secrets**: Sensitive data (connection strings, API keys)
- **Ingress**: External traffic routing
- **HPA**: Auto-scaling based on CPU/memory

### CI/CD Pipeline
1. Code push to GitHub
2. GitHub Actions triggers
3. Build & test all services
4. Security scans (SAST/DAST)
5. Build Docker images
6. Push to container registry
7. Deploy to staging (automatic)
8. Deploy to production (manual approval)

## Disaster Recovery

### Backup Strategy
- Daily database backups
- Point-in-time recovery enabled
- Backup retention: 30 days
- Backup testing: Monthly

### High Availability
- Multi-AZ deployment
- Database replication
- Service replicas: Minimum 3 per service
- Health checks and auto-restart

## Future Enhancements

1. **Event Sourcing**: Implement CQRS pattern for audit trail
2. **GraphQL Gateway**: Unified API interface
3. **Machine Learning**: Doctor recommendation engine
4. **Blockchain**: Immutable medical records
5. **Real-time Updates**: WebSocket support for live notifications

---

**Document Version**: 1.0  
**Last Updated**: October 2025
