# Search-to-Selection API Documentation

## Overview

This document describes the API endpoints and data payloads implemented to support the search-to-selection workflow in the MedTravel system. The system enables users to search for locations (cities), hospitals, doctors, and diseases, with each search result type triggering a distinct follow-up journey leading to appointment booking.

## API Base URL

All endpoints are prefixed with `/api/v1/selection/`

## Authentication

Most endpoints are marked as `[AllowAnonymous]` for public access, but some may require authentication for booking operations.

## API Endpoints

### 1. Doctor Selection Flow

#### Get Doctor Selection with Profile and Availability
```
GET /api/v1/selection/doctors/{doctorId}
```

**Query Parameters:**
- `startDate` (optional): Start date for availability search (ISO 8601 format)
- `endDate` (optional): End date for availability search (ISO 8601 format)
- `includeReviews` (optional): Include recent reviews (default: true)
- `reviewLimit` (optional): Number of reviews to include (default: 5)

**Response:**
```json
{
  "success": true,
  "data": {
    "doctor": {
      "id": "guid",
      "firstName": "string",
      "lastName": "string",
      "qualification": "string",
      "yearsOfExperience": 0,
      "consultationFee": 0.00,
      "averageRating": 0.0,
      "totalReviews": 0,
      "isAcceptingPatients": true,
      "profileImageUrl": "string",
      "hospital": {
        "id": "guid",
        "name": "string",
        "address": "string",
        "city": "string",
        "phone": "string",
        "averageRating": 0.0,
        "totalReviews": 0,
        "bedCapacity": 0
      },
      "specialties": [
        {
          "id": "guid",
          "name": "string",
          "description": "string",
          "category": "string",
          "isPrimary": true,
          "yearsOfExperience": 0
        }
      ],
      "languages": [
        {
          "id": "guid",
          "name": "string",
          "code": "string",
          "proficiencyLevel": "string"
        }
      ],
      "credentials": [
        {
          "id": "guid",
          "name": "string",
          "issuingOrganization": "string",
          "issueDate": "datetime",
          "expiryDate": "datetime"
        }
      ]
    },
    "availability": {
      "doctorId": "guid",
      "availableSlots": [
        {
          "date": "datetime",
          "timeSlots": [
            {
              "time": "timespan",
              "duration": 0,
              "isAvailable": true,
              "slotId": "guid"
            }
          ]
        }
      ],
      "timeZone": "string",
      "workingHours": {
        "Monday": "09:00 - 17:00",
        "Tuesday": "09:00 - 17:00"
      }
    },
    "recentReviews": [
      {
        "id": "guid",
        "rating": 0,
        "comment": "string",
        "createdAt": "datetime",
        "userId": "guid"
      }
    ]
  },
  "message": "Doctor selection retrieved successfully"
}
```

#### Get Doctor Availability
```
GET /api/v1/selection/doctors/{doctorId}/availability
```

**Query Parameters:**
- `startDate` (optional): Start date for availability search
- `endDate` (optional): End date for availability search

**Response:**
```json
{
  "success": true,
  "data": {
    "doctorId": "guid",
    "availableSlots": [
      {
        "date": "datetime",
        "timeSlots": [
          {
            "time": "timespan",
            "duration": 0,
            "isAvailable": true,
            "slotId": "guid"
          }
        ]
      }
    ],
    "timeZone": "string",
    "workingHours": {}
  }
}
```

### 2. Hospital Selection Flow

#### Get Hospital Selection with Doctors and Specialties
```
GET /api/v1/selection/hospitals/{hospitalId}
```

**Query Parameters:**
- `specialty` (optional): Filter doctors by specialty
- `page` (optional): Page number (default: 1)
- `pageSize` (optional): Page size (default: 20)
- `sortBy` (optional): Sort by rating, experience, or fee (default: rating)
- `includeAvailability` (optional): Include availability info (default: true)

**Response:**
```json
{
  "success": true,
  "data": {
    "hospital": {
      "id": "guid",
      "name": "string",
      "description": "string",
      "address": "string",
      "city": "string",
      "state": "string",
      "country": "string",
      "phone": "string",
      "email": "string",
      "website": "string",
      "bedCapacity": 0,
      "yearEstablished": 0,
      "averageRating": 0.0,
      "totalReviews": 0,
      "specialties": [],
      "amenities": [],
      "reviews": []
    },
    "doctors": {
      "items": [
        {
          "id": "guid",
          "firstName": "string",
          "lastName": "string",
          "qualification": "string",
          "yearsOfExperience": 0,
          "consultationFee": 0.00,
          "averageRating": 0.0,
          "totalReviews": 0,
          "isAcceptingPatients": true,
          "profileImageUrl": "string",
          "specialties": []
        }
      ],
      "totalCount": 0,
      "pageNumber": 1,
      "pageSize": 20,
      "totalPages": 0
    },
    "availableSpecialties": [
      {
        "id": "guid",
        "name": "string",
        "description": "string",
        "category": "string"
      }
    ]
  }
}
```

#### Get Hospital Doctors
```
GET /api/v1/selection/hospitals/{hospitalId}/doctors
```

**Query Parameters:** Same as hospital selection endpoint

**Response:** Returns the doctors portion of the hospital selection response

### 3. City Selection Flow

#### Get City Selection with Hospitals and Specialties
```
GET /api/v1/selection/cities/{cityId}
```

**Query Parameters:**
- `specialty` (optional): Filter hospitals by specialty
- `page` (optional): Page number (default: 1)
- `pageSize` (optional): Page size (default: 20)
- `sortBy` (optional): Sort by rating, distance, or capacity (default: rating)
- `maxDistance` (optional): Maximum distance from city center in km

**Response:**
```json
{
  "success": true,
  "data": {
    "city": {
      "id": "guid",
      "name": "string",
      "state": "string",
      "country": "string"
    },
    "hospitals": {
      "items": [
        {
          "id": "guid",
          "name": "string",
          "address": "string",
          "city": "string",
          "phone": "string",
          "averageRating": 0.0,
          "totalReviews": 0,
          "bedCapacity": 0,
          "doctorCount": 0,
          "specialties": [],
          "amenities": [],
          "distanceFromCityCenter": 0.0,
          "isAcceptingAppointments": true
        }
      ],
      "totalCount": 0,
      "pageNumber": 1,
      "pageSize": 20,
      "totalPages": 0
    },
    "availableSpecialties": [],
    "totalDoctors": 0
  }
}
```

#### Get City Hospitals
```
GET /api/v1/selection/cities/{cityId}/hospitals
```

**Query Parameters:** Same as city selection endpoint

**Response:** Returns the hospitals portion of the city selection response

### 4. Disease Selection Flow

#### Get Disease Selection with Doctors and Specialties
```
GET /api/v1/selection/diseases/{diseaseId}
```

**Query Parameters:**
- `cityId` (optional): Filter doctors by city
- `specialty` (optional): Filter doctors by specialty
- `page` (optional): Page number (default: 1)
- `pageSize` (optional): Page size (default: 20)
- `sortBy` (optional): Sort by experience, rating, or fee (default: experience)
- `includeAvailability` (optional): Include availability info (default: true)

**Response:**
```json
{
  "success": true,
  "data": {
    "disease": {
      "id": "guid",
      "name": "string",
      "category": "string",
      "description": "string",
      "symptoms": "string",
      "treatmentOptions": "string"
    },
    "doctors": {
      "items": [
        {
          "id": "guid",
          "firstName": "string",
          "lastName": "string",
          "qualification": "string",
          "yearsOfExperience": 0,
          "consultationFee": 0.00,
          "averageRating": 0.0,
          "totalReviews": 0,
          "isAcceptingPatients": true,
          "profileImageUrl": "string",
          "hospital": {
            "id": "guid",
            "name": "string",
            "address": "string",
            "city": "string",
            "phone": "string",
            "averageRating": 0.0,
            "totalReviews": 0,
            "bedCapacity": 0
          },
          "specialties": [],
          "languages": [],
          "hasAvailability": true,
          "nextAvailableSlot": "datetime"
        }
      ],
      "totalCount": 0,
      "pageNumber": 1,
      "pageSize": 20,
      "totalPages": 0
    },
    "relatedSpecialties": [],
    "topHospitals": [
      {
        "id": "guid",
        "name": "string",
        "address": "string",
        "city": "string",
        "phone": "string",
        "averageRating": 0.0,
        "totalReviews": 0,
        "bedCapacity": 0
      }
    ]
  }
}
```

#### Get Disease Doctors
```
GET /api/v1/selection/diseases/{diseaseId}/doctors
```

**Query Parameters:** Same as disease selection endpoint

**Response:** Returns the doctors portion of the disease selection response

### 5. Common Helper Endpoints

#### Get Available Specialties
```
GET /api/v1/selection/specialties
```

**Query Parameters:**
- `cityId` (optional): Filter specialties by city
- `hospitalId` (optional): Filter specialties by hospital

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "guid",
      "name": "string",
      "description": "string",
      "category": "string"
    }
  ]
}
```

#### Check Doctor Availability
```
GET /api/v1/selection/doctors/{doctorId}/check-availability
```

**Query Parameters:**
- `date`: Date to check (ISO 8601 format)
- `time`: Time to check (HH:mm format)

**Response:**
```json
{
  "success": true,
  "data": true
}
```

#### Get Next Available Slot
```
GET /api/v1/selection/doctors/{doctorId}/next-available
```

**Response:**
```json
{
  "success": true,
  "data": "2024-01-15T09:00:00Z"
}
```

## Database Schema Updates

### New Tables Added

1. **DoctorDiseases** - Links doctors to diseases they treat
2. **DoctorAvailability** - Stores doctor working hours and availability
3. **DoctorLanguages** - Links doctors to languages they speak
4. **DiseaseSpecialties** - Links diseases to relevant specialties

### Enhanced Relationships

- **Diseases → Doctors**: Through `DiseaseSpecialties` → `Specialties` → `DoctorSpecialties` → `Doctors`
- **Cities → Hospitals**: Direct relationship via `Hospitals.CityId`
- **Hospitals → Doctors**: Direct relationship via `Doctors.HospitalId`
- **Doctor Availability**: Stored in `DoctorAvailability` table with day-of-week and time ranges

## Frontend Integration

### SearchWorkflow Component Updates

The `SearchWorkflow` component has been enhanced to:

1. **Load Real Data**: Uses the new selection flow APIs to fetch actual data
2. **Display Rich Information**: Shows doctor profiles, hospital details, city information, and disease specialists
3. **Handle Loading States**: Provides loading indicators during API calls
4. **Support Pagination**: Handles paginated results for large datasets
5. **Enable Filtering**: Supports filtering by specialty, city, and other criteria

### New Service Layer

A new `selectionFlowService` has been created to handle all API calls to the selection endpoints, providing a clean interface for the frontend components.

## Error Handling

All endpoints return consistent error responses:

```json
{
  "success": false,
  "data": null,
  "message": "Error message",
  "errors": ["Detailed error 1", "Detailed error 2"],
  "correlationId": "guid"
}
```

## Performance Considerations

1. **Efficient Indexing**: Database indexes on frequently queried fields
2. **Pagination**: All list endpoints support pagination to handle large datasets
3. **Eager Loading**: Related entities are loaded efficiently using Entity Framework includes
4. **Caching**: Memory cache is used for frequently accessed data
5. **Async Operations**: All database operations are asynchronous

## Usage Examples

### Example 1: Doctor Selection Flow
```javascript
// 1. User searches for "Dr. Smith"
// 2. Selects doctor from search results
// 3. System loads doctor profile and availability
const doctorSelection = await selectionFlowService.getDoctorSelection(doctorId, {
  includeReviews: true,
  reviewLimit: 5
});

// 4. User can then book appointment
```

### Example 2: Hospital Selection Flow
```javascript
// 1. User searches for "Mayo Clinic"
// 2. Selects hospital from search results
// 3. System loads hospital details and doctors
const hospitalSelection = await selectionFlowService.getHospitalSelection(hospitalId, {
  specialty: "Cardiology",
  page: 1,
  pageSize: 20
});

// 4. User selects a doctor from the list
// 5. System loads doctor profile and availability
```

### Example 3: City Selection Flow
```javascript
// 1. User searches for "New York"
// 2. Selects city from search results
// 3. System loads city hospitals
const citySelection = await selectionFlowService.getCitySelection(cityId, {
  specialty: "Oncology",
  sortBy: "rating"
});

// 4. User selects a hospital
// 5. System loads hospital doctors
```

### Example 4: Disease Selection Flow
```javascript
// 1. User searches for "Diabetes"
// 2. Selects disease from search results
// 3. System loads specialists who treat the disease
const diseaseSelection = await selectionFlowService.getDiseaseSelection(diseaseId, {
  cityId: "city-guid",
  sortBy: "experience"
});

// 4. User selects a specialist
// 5. System loads doctor profile and availability
```

## Testing

The implementation includes comprehensive error handling and logging. All endpoints should be tested with:

1. **Valid requests** with proper parameters
2. **Invalid IDs** to test 404 responses
3. **Missing parameters** to test validation
4. **Large datasets** to test pagination
5. **Concurrent requests** to test performance

## Future Enhancements

1. **Real-time Availability**: WebSocket integration for real-time slot updates
2. **Advanced Filtering**: More sophisticated filtering options
3. **Recommendation Engine**: AI-powered doctor/hospital recommendations
4. **Multi-language Support**: Internationalization for global users
5. **Mobile Optimization**: Enhanced mobile experience
