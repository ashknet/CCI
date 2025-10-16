# API Documentation

Complete API reference for MedTravel Platform microservices.

## Base URLs

- **Local Development**:
  - User Management: `http://localhost:5001`
  - Hospital Service: `http://localhost:5002`
  - Transportation: `http://localhost:5003`
  - Messaging: `http://localhost:5004`

- **Production**:
  - All services: `https://api.medtravel.com`

## Authentication

### Production Mode

All requests (except registration and login) require a JWT bearer token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Local Development Mode

Authentication is bypassed. The system automatically injects a default user.

## Common Headers

```
Content-Type: application/json
Accept: application/json
X-Correlation-ID: unique-request-id (optional)
```

## Response Format

All API responses follow this structure:

**Success Response**:
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Optional success message",
  "correlationId": "abc-123",
  "timestamp": "2025-10-14T10:30:00Z"
}
```

**Error Response**:
```json
{
  "success": false,
  "data": null,
  "message": "Error message",
  "errors": ["Detailed error 1", "Detailed error 2"],
  "correlationId": "abc-123",
  "timestamp": "2025-10-14T10:30:00Z"
}
```

## User Management Service API

### Register User
`POST /api/auth/register`

**Request**:
```json
{
  "email": "patient@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1-555-0123",
  "dateOfBirth": "1990-01-01",
  "gender": "Male",
  "nationality": "American",
  "country": "USA",
  "city": "New York",
  "address": "123 Main St",
  "postalCode": "10001",
  "passportNumber": "AB1234567"
}
```

**Response**: Login response with tokens

### Login
`POST /api/auth/login`

**Request**:
```json
{
  "email": "patient@example.com",
  "password": "SecurePass123!",
  "deviceInfo": "Chrome on Windows"
}
```

**Response**:
```json
{
  "accessToken": "eyJhbGciOi...",
  "refreshToken": "550e8400-e29b...",
  "expiresAt": "2025-10-14T11:30:00Z",
  "user": {
    "id": "user-id",
    "email": "patient@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "roles": ["patient"]
  }
}
```

### Get Profile
`GET /api/auth/profile`

**Headers**: `Authorization: Bearer {token}`

**Response**: User object with full profile data

### Update Profile
`PUT /api/auth/profile`

**Request**:
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1-555-0123",
  "address": "456 Oak Ave"
}
```

### Get Notifications
`GET /api/notifications?pageNumber=1&pageSize=20`

**Response**:
```json
{
  "items": [
    {
      "id": "notif-id",
      "type": "email",
      "channel": "appointment",
      "subject": "Appointment Reminder",
      "message": "Your appointment is tomorrow",
      "status": "sent",
      "scheduledFor": "2025-10-14T09:00:00Z",
      "readAt": null
    }
  ],
  "totalCount": 45,
  "pageNumber": 1,
  "pageSize": 20,
  "totalPages": 3
}
```

## Hospital Service API

### Get Search Suggestions
`GET /api/search/suggestions?query={term}`

**Parameters**:
- `query` (string, min 3 chars): Search term

**Response**:
```json
[
  {
    "text": "Cardiology",
    "category": "specialty",
    "id": "specialty-id"
  },
  {
    "text": "Apollo Hospitals Hyderabad",
    "category": "hospital",
    "id": "hospital-id"
  },
  {
    "text": "Hyderabad",
    "category": "location",
    "id": null
  }
]
```

### Search Hospitals
`POST /api/search/hospitals`

**Request**:
```json
{
  "query": "cardiology",
  "city": "Hyderabad",
  "latitude": 17.4239,
  "longitude": 78.4738,
  "maxDistance": 50,
  "pageNumber": 1,
  "pageSize": 10,
  "sortBy": "rating"
}
```

**Response**: Paged result of hospital objects

### Search Doctors
`POST /api/search/doctors`

**Request**: Same as search hospitals

**Response**:
```json
{
  "items": [
    {
      "id": "doctor-id",
      "hospitalId": "hospital-id",
      "hospitalName": "Apollo Hospitals",
      "firstName": "Rajesh",
      "lastName": "Kumar",
      "email": "dr.kumar@apollo.com",
      "qualification": "MBBS, MD (Cardiology)",
      "yearsOfExperience": 15,
      "consultationFee": 2000,
      "averageRating": 4.8,
      "totalReviews": 250,
      "specialties": ["Cardiology", "Interventional Cardiology"],
      "languages": ["English", "Hindi", "Telugu"],
      "credentials": [
        {
          "type": "degree",
          "name": "MBBS",
          "issuingOrganization": "AIIMS",
          "issueDate": "2005-06-01",
          "isVerified": true
        }
      ]
    }
  ],
  "totalCount": 156,
  "pageNumber": 1,
  "pageSize": 10
}
```

### Get Available Slots
`GET /api/appointments/doctor/{doctorId}/available-slots?startDate={date}&endDate={date}`

**Parameters**:
- `doctorId` (guid): Doctor ID
- `startDate` (date): Start date (YYYY-MM-DD)
- `endDate` (date): End date (YYYY-MM-DD)

**Response**:
```json
[
  {
    "date": "2025-10-20",
    "startTime": "09:00:00",
    "endTime": "09:30:00",
    "isAvailable": true
  },
  {
    "date": "2025-10-20",
    "startTime": "09:30:00",
    "endTime": "10:00:00",
    "isAvailable": false
  }
]
```

### Book Appointment
`POST /api/appointments`

**Request**:
```json
{
  "doctorId": "doctor-id",
  "scheduledDate": "2025-10-20",
  "scheduledTime": "09:00:00",
  "reasonForVisit": "Cardiac checkup"
}
```

**Response**: Appointment object with confirmation

### Get My Appointments
`GET /api/appointments/my-appointments?pageNumber=1&pageSize=20`

**Response**: Paged list of appointments

### Cancel Appointment
`PATCH /api/appointments/{id}/cancel`

**Request**:
```json
"Reason for cancellation"
```

## Transportation & Accommodation Service API

### Search Flights
`POST /api/transport/search-flights`

**Request**:
```json
{
  "from": "New York",
  "to": "Hyderabad",
  "departureDate": "2025-10-15",
  "returnDate": "2025-10-25",
  "passengers": 1,
  "preference": "cheapest"
}
```

**Response**: List of flight options

### Book Transportation
`POST /api/transport/book`

**Request**:
```json
{
  "type": "flight",
  "referenceId": "flight-id",
  "passengerDetails": { /* ... */ }
}
```

### Search Accommodation
`GET /api/accommodation/search?city={city}&nearHospitalId={id}&checkIn={date}&checkOut={date}`

**Response**: List of hotels with availability

### Book Accommodation
`POST /api/accommodation/book`

**Request**:
```json
{
  "hotelId": "hotel-id",
  "roomId": "room-id",
  "checkInDate": "2025-10-15",
  "checkOutDate": "2025-10-25",
  "numberOfGuests": 2,
  "numberOfRooms": 1,
  "specialRequests": "Wheelchair accessible"
}
```

### Get Cost Breakdown
`GET /api/cost-breakdown/{userId}`

**Response**:
```json
{
  "id": "breakdown-id",
  "medicalCost": 50000,
  "transportCost": 85000,
  "accommodationCost": 30000,
  "totalCost": 165000,
  "currency": "INR"
}
```

## Messaging Service API

### Get Threads
`GET /api/messages/threads?pageNumber=1&pageSize=20`

**Response**:
```json
{
  "items": [
    {
      "id": "thread-id",
      "patientId": "patient-id",
      "providerId": "doctor-id",
      "providerType": "doctor",
      "subject": "Post-operative questions",
      "status": "active",
      "lastMessageAt": "2025-10-14T10:30:00Z"
    }
  ]
}
```

### Get Thread Messages
`GET /api/messages/threads/{threadId}`

**Response**: Thread with all messages

### Send Message
`POST /api/messages/threads/{threadId}/messages`

**Request**:
```json
{
  "content": "Hello, I have a question about my medication",
  "attachments": []
}
```

### Create Thread
`POST /api/messages/threads`

**Request**:
```json
{
  "providerId": "doctor-id",
  "providerType": "doctor",
  "subject": "Question about treatment",
  "relatedAppointmentId": "appointment-id"
}
```

## Error Codes

| Status Code | Meaning |
|------------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request - Invalid input |
| 401 | Unauthorized - Missing or invalid token |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource doesn't exist |
| 422 | Validation Error - Input validation failed |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error |
| 503 | Service Unavailable |

## Rate Limiting

- **Public endpoints**: 100 requests per minute
- **Authenticated endpoints**: 1000 requests per minute
- **Search endpoints**: 60 requests per minute

Headers in response:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1634208000
```

## Pagination

All list endpoints support pagination with these parameters:
- `pageNumber` (integer, default: 1)
- `pageSize` (integer, default: 20, max: 100)

Response includes:
```json
{
  "items": [ /* ... */ ],
  "totalCount": 500,
  "pageNumber": 1,
  "pageSize": 20,
  "totalPages": 25,
  "hasPrevious": false,
  "hasNext": true
}
```

## Sorting and Filtering

Many endpoints support:
- `sortBy`: Field to sort by (e.g., "name", "rating", "date")
- `sortOrder`: "asc" or "desc"
- Custom filters per endpoint (check Swagger docs)

## Best Practices

1. **Always include correlation ID** for request tracing
2. **Handle rate limits** with exponential backoff
3. **Cache responses** where appropriate
4. **Use pagination** for large datasets
5. **Validate input** on client side before sending
6. **Handle errors gracefully** with user-friendly messages

## Interactive Documentation

For interactive API exploration, visit:
- http://localhost:5001/swagger (User Management)
- http://localhost:5002/swagger (Hospital Service)
- http://localhost:5003/swagger (Transportation)
- http://localhost:5004/swagger (Messaging)

---

**API Version**: 1.0  
**Last Updated**: October 2025
