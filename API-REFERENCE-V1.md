# MedTravel Platform - Complete v1 API Reference

## Overview

All APIs follow RESTful conventions with `/api/v1/` versioning. All endpoints support:
- **Authentication**: JWT Bearer tokens (except public endpoints)
- **Correlation IDs**: `X-Correlation-ID` header for request tracing
- **Pagination**: `pageNumber` and `pageSize` query parameters
- **Filtering**: Service-specific filter parameters
- **Sorting**: `sortBy` and `sortOrder` parameters where applicable
- **Idempotency**: POST/PUT operations for bookings and payments

## Response Format

All responses follow this structure:

```json
{
  "success": true|false,
  "data": { ... },
  "message": "Optional message",
  "errors": ["Error 1", "Error 2"],
  "correlationId": "abc-123",
  "timestamp": "2025-10-14T10:30:00Z"
}
```

## Base URLs

- **Local Development**: 
  - User Management: `http://localhost:5001`
  - Hospital: `http://localhost:5002`
  - TAService: `http://localhost:5003`
  - Messaging: `http://localhost:5004`

- **Production**: `https://api.medtravel.com`

---

## 🔐 User Management Service

Base URL: `/api/v1`

### Authentication & Session

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/auth/register` | Register new user | No |
| POST | `/auth/login` | Login with credentials | No |
| POST | `/auth/logout` | Logout current session | Yes |
| POST | `/auth/refresh` | Refresh access token | No |
| POST | `/auth/mfa/verify` | Verify MFA code | Yes |
| POST | `/auth/password/forgot` | Request password reset | No |
| POST | `/auth/password/reset` | Reset password with token | No |

### Users & Profiles

| Method | Endpoint | Description | Auth Required | Roles |
|--------|----------|-------------|---------------|-------|
| GET | `/users/{userId}` | Get user by ID | Yes | Self/Admin |
| PUT | `/users/{userId}` | Update user information | Yes | Self/Admin |
| DELETE | `/users/{userId}` | Delete user | Yes | Admin only |
| GET | `/users` | Get all users (paginated) | Yes | Admin only |
| GET | `/users/{userId}/profile` | Get user profile | Yes | Self/Admin |
| PUT | `/users/{userId}/profile` | Update user profile | Yes | Self/Admin |
| GET | `/users/{userId}/preferences` | Get user preferences | Yes | Self/Admin |
| PUT | `/users/{userId}/preferences` | Update user preferences | Yes | Self |

### Roles & Permissions

| Method | Endpoint | Description | Auth Required | Roles |
|--------|----------|-------------|---------------|-------|
| GET | `/roles` | Get all roles | Yes | Admin |
| POST | `/roles` | Create new role | Yes | Admin |
| DELETE | `/roles/{roleId}` | Delete role | Yes | Admin |
| GET | `/users/{userId}/roles` | Get user roles | Yes | Self/Admin |
| PUT | `/users/{userId}/roles` | Update user roles | Yes | Admin only |

### Bookings & Visits

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/{userId}/bookings` | Get user bookings | Yes |
| GET | `/users/{userId}/visits` | Get user visits | Yes |
| GET | `/users/{userId}/invoices` | Get user invoices | Yes |

### Documents & Insurance

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/{userId}/documents` | Get user documents | Yes |
| POST | `/users/{userId}/documents` | Upload document | Yes |
| DELETE | `/users/{userId}/documents/{documentId}` | Delete document | Yes |
| GET | `/users/{userId}/insurance` | Get insurance info | Yes |
| PUT | `/users/{userId}/insurance` | Update insurance | Yes |

### Spend & Experience

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/{userId}/spend-summary` | Get spend summary | Yes |
| GET | `/users/{userId}/reviews` | Get user reviews | Yes |
| POST | `/users/{userId}/reviews` | Submit review | Yes |

### Care Plans & Requirements

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/{userId}/care-plans` | Get care plans | Yes |
| GET | `/procedures/{code}/requirements` | Get procedure requirements | Yes |
| GET | `/procedures` | Get procedures by disease/condition | Yes |

### Notifications & Reminders

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/users/{userId}/notifications` | Get user notifications | Yes |
| PUT | `/users/{userId}/notification-preferences` | Update notification preferences | Yes |
| POST | `/reminders/appointments` | Schedule appointment reminder | Yes |
| POST | `/reminders/travel` | Schedule travel reminder | Yes |
| POST | `/reminders/instructions` | Schedule instruction reminder | Yes |

### Local Dev Mode

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/dev/default-user` | Get default user (local dev mode only) | No |

---

## 🏥 Hospital Service

Base URL: `/api/v1`

### Search & Suggestions

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/search?q={term}&category={type}` | Universal search | No |
| GET | `/suggest?term={partial}` | Type-ahead suggestions (3+ chars) | No |
| GET | `/diseases` | Browse/filter diseases | No |

### Hospitals, Clinics, Facilities

| Method | Endpoint | Description | Auth Required | Roles |
|--------|----------|-------------|---------------|-------|
| GET | `/hospitals` | Get all hospitals | No | - |
| POST | `/hospitals` | Register new hospital | Yes | Admin |
| GET | `/hospitals/{hospitalId}` | Get hospital details | No | - |
| PUT | `/hospitals/{hospitalId}` | Update hospital | Yes | Admin |
| GET | `/hospitals/{hospitalId}/facilities` | Get hospital facilities | No | - |
| POST | `/hospitals/{hospitalId}/facilities` | Add facility | Yes | Admin |
| GET | `/clinics` | Get all clinics | No | - |
| POST | `/clinics` | Register new clinic | Yes | Admin |
| GET | `/clinics/{clinicId}` | Get clinic details | No | - |
| PUT | `/clinics/{clinicId}` | Update clinic | Yes | Admin |

### Doctors & Profiles

| Method | Endpoint | Description | Auth Required | Roles |
|--------|----------|-------------|---------------|-------|
| GET | `/doctors` | Get all doctors (paginated, filtered) | No | - |
| POST | `/doctors` | Register new doctor | Yes | Admin |
| GET | `/doctors/{doctorId}` | Get doctor profile | No | - |
| PUT | `/doctors/{doctorId}` | Update doctor profile | Yes | Doctor/Admin |
| GET | `/doctors/{doctorId}/credentials` | Get doctor credentials | No | - |
| GET | `/doctors/{doctorId}/specialties` | Get doctor specialties | No | - |
| GET | `/doctors/{doctorId}/languages` | Get doctor languages | No | - |
| GET | `/doctors/{doctorId}/reviews` | Get doctor reviews | No | - |
| POST | `/doctors/{doctorId}/reviews` | Add doctor review | Yes | Patient |

### Scheduling & Appointments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/doctors/{doctorId}/availability?from=&to=` | Get doctor availability | Yes |
| POST | `/doctors/{doctorId}/appointments` | Book appointment | Yes |
| GET | `/appointments/{appointmentId}` | Get appointment details | Yes |
| PUT | `/appointments/{appointmentId}/reschedule` | Reschedule appointment | Yes |
| DELETE | `/appointments/{appointmentId}/cancel` | Cancel appointment | Yes |
| GET | `/appointments/{appointmentId}/ical` | Export to calendar (iCal) | Yes |
| POST | `/appointments/{appointmentId}/reminders` | Set appointment reminders | Yes |

### Accreditations & Departments

| Method | Endpoint | Description | Auth Required | Roles |
|--------|----------|-------------|---------------|-------|
| GET | `/hospitals/{hospitalId}/accreditations` | Get hospital accreditations | No | - |
| POST | `/hospitals/{hospitalId}/accreditations` | Add accreditation | Yes | Admin |
| GET | `/hospitals/{hospitalId}/departments` | Get hospital departments | No | - |
| POST | `/hospitals/{hospitalId}/departments` | Add department | Yes | Admin |

### Locations

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/cities` | Get all cities | No |
| GET | `/cities/{cityId}` | Get city details | No |
| GET | `/locations/nearby?lat=&lng=&radius=` | Find nearby locations | No |

---

## ✈️ TAService (Transportation & Accommodation)

Base URL: `/api/v1`

### Flights

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/travel/flights/search?from=&to=&date=` | Search flights | Yes |
| GET | `/travel/flights/recommendations?appointmentDate=&preference=` | Get flight recommendations | Yes |
| POST | `/travel/flights/book` | Book flight | Yes |
| GET | `/travel/flights/itineraries/{itineraryId}` | Get itinerary details | Yes |
| DELETE | `/travel/flights/bookings/{bookingId}/cancel` | Cancel flight booking | Yes |

### Trains & Buses (Domestic)

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/travel/trains/search?from=&to=&date=` | Search trains | Yes |
| GET | `/travel/buses/search?from=&to=&date=` | Search buses | Yes |
| POST | `/travel/trains/book` | Book train (or get redirect token) | Yes |
| POST | `/travel/buses/book` | Book bus (or get redirect token) | Yes |
| GET | `/travel/{mode}/bookings/{bookingId}` | Get booking details | Yes |

### Hotels & Rentals

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/stay/search?nearHospitalId=&maxDistance=&costRange=&amenities=&condition=&durationDays=` | Search accommodations | Yes |
| GET | `/stay/properties/{propertyId}` | Get property details | Yes |
| POST | `/stay/book` | Book accommodation | Yes |
| DELETE | `/stay/bookings/{bookingId}/cancel` | Cancel booking | Yes |

### Estimates & Cost Breakdown

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/costs/estimate` | Create cost estimate | Yes |
| GET | `/costs/estimates/{estimateId}` | Get estimate | Yes |
| GET | `/costs/estimates/{estimateId}/line-items` | Get itemized costs | Yes |

### Payments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/payments` | Initiate payment | Yes |
| POST | `/payments/{paymentId}/capture` | Capture payment | Yes |
| POST | `/payments/{paymentId}/refund` | Refund payment | Yes |
| GET | `/payments/{paymentId}/receipt` | Get receipt | Yes |
| GET | `/payments/ledger?userId=` | Get payment ledger | Yes |

### Integrations & Redirects

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/integrations/redirect-token` | Generate partner redirect token | Yes |
| GET | `/integrations/providers` | List configured providers | No |

---

## 💬 Messaging Service

Base URL: `/api/v1`

### Threads & Messages

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/messages/threads` | Get user's message threads | Yes |
| GET | `/messages/threads/{threadId}` | Get thread messages | Yes |
| POST | `/messages/threads` | Create new thread | Yes |
| POST | `/messages/threads/{threadId}/messages` | Send message | Yes |
| PATCH | `/messages/threads/{threadId}/messages/{messageId}/read` | Mark as read | Yes |
| PATCH | `/messages/threads/{threadId}/archive` | Archive thread | Yes |

---

## 📊 Implementation Status

### ✅ Completed APIs

#### User Management Service
- ✅ 7 Authentication endpoints
- ✅ 8 User & Profile endpoints
- ✅ 5 Role & Permission endpoints
- ✅ 3 Booking & Visit endpoints
- ✅ 5 Document & Insurance endpoints
- ✅ 3 Spend & Experience endpoints
- ✅ 3 Care Plan endpoints
- ✅ 5 Notification endpoints
- ✅ 1 Local dev endpoint

**Total**: 40+ endpoints

#### Hospital Service
- ✅ 3 Search & Suggestion endpoints
- ✅ 10 Hospital & Clinic endpoints
- ✅ 9 Doctor & Profile endpoints
- ✅ 7 Scheduling & Appointment endpoints
- ✅ 4 Accreditation & Department endpoints
- ✅ 3 Location endpoints

**Total**: 36+ endpoints

#### TAService
- ✅ 5 Flight endpoints
- ✅ 5 Train & Bus endpoints
- ✅ 4 Hotel & Rental endpoints
- ✅ 3 Cost & Estimate endpoints
- ✅ 5 Payment endpoints
- ✅ 2 Integration endpoints

**Total**: 24+ endpoints

#### Messaging Service
- ✅ 6 Messaging endpoints

**Total**: 6+ endpoints

### Grand Total: **106+ RESTful v1 API Endpoints**

---

## 🔒 Security Features

- ✅ JWT Bearer authentication
- ✅ Role-based authorization (patient, doctor, hospital_admin, support)
- ✅ Local dev mode with auth bypass (configurable)
- ✅ Correlation IDs for distributed tracing
- ✅ Input validation on all endpoints
- ✅ Rate limiting on public endpoints
- ✅ Idempotent operations for bookings/payments

## 📝 Standards Compliance

- ✅ RESTful naming conventions
- ✅ Plural nouns for resources
- ✅ Version prefix (`/api/v1/`)
- ✅ Consistent error responses
- ✅ OpenAPI/Swagger documentation
- ✅ Pagination support
- ✅ Filtering and sorting
- ✅ WCAG 2.2 AA accessibility considerations

---

**Last Updated**: October 2025  
**API Version**: v1.0  
**Status**: Production Ready
