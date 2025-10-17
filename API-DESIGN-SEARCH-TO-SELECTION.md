# 🔍 Search-to-Selection API Design

## 📋 Overview

This document defines the REST API endpoints and data models for the search-to-selection workflow in the MedTravel platform. The system enables users to search for locations, hospitals, doctors, and diseases, then navigate through a structured selection process to book appointments.

## 🎯 API Endpoints

### **1. Doctor Selection Flow**

#### **Get Doctor Profile**
```http
GET /api/v1/doctors/{doctorId}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "guid",
    "firstName": "Dr. Suresh",
    "lastName": "Reddy",
    "email": "dr.suresh.reddy@apollo.com",
    "phone": "+91-9876502001",
    "qualification": "MBBS, MD, DM (Cardiology)",
    "yearsOfExperience": 18,
    "biography": "Senior Interventional Cardiologist...",
    "profileImageUrl": "https://...",
    "consultationFee": 2500.00,
    "averageRating": 4.7,
    "totalReviews": 450,
    "isAcceptingPatients": true,
    "hospital": {
      "id": "guid",
      "name": "Apollo Hospital Jubilee Hills",
      "address": "Road No. 72, Film Nagar, Jubilee Hills",
      "city": "Hyderabad",
      "phone": "+91-40-23607777"
    },
    "specialties": [
      {
        "id": "guid",
        "name": "Cardiology",
        "category": "Internal Medicine",
        "isPrimary": true,
        "yearsOfExperience": 18
      }
    ],
    "languages": [
      {
        "id": "guid",
        "name": "English",
        "code": "en"
      },
      {
        "id": "guid", 
        "name": "Hindi",
        "code": "hi"
      }
    ],
    "credentials": [
      {
        "type": "Medical License",
        "name": "Medical Council of India Registration",
        "issuingOrganization": "MCI",
        "issueDate": "2005-06-15",
        "expiryDate": null,
        "isVerified": true
      }
    ],
    "reviews": [
      {
        "id": "guid",
        "rating": 5,
        "comment": "Excellent doctor! Very thorough...",
        "patientName": "Rajesh K.",
        "treatmentDate": "2024-01-15",
        "createdAt": "2024-01-20T10:30:00Z"
      }
    ]
  }
}
```

#### **Get Doctor Availability**
```http
GET /api/v1/doctors/{doctorId}/availability?startDate=2024-01-01&endDate=2024-01-31
```

**Response:**
```json
{
  "success": true,
  "data": {
    "doctorId": "guid",
    "availableSlots": [
      {
        "date": "2024-01-15",
        "timeSlots": [
          {
            "time": "09:00:00",
            "duration": 30,
            "isAvailable": true,
            "slotId": "guid"
          },
          {
            "time": "09:30:00", 
            "duration": 30,
            "isAvailable": false,
            "slotId": "guid"
          }
        ]
      }
    ],
    "timeZone": "Asia/Kolkata",
    "workingHours": {
      "monday": "09:00-17:00",
      "tuesday": "09:00-17:00",
      "wednesday": "09:00-17:00",
      "thursday": "09:00-17:00", 
      "friday": "09:00-17:00",
      "saturday": "09:00-13:00",
      "sunday": "closed"
    }
  }
}
```

#### **Book Appointment**
```http
POST /api/v1/doctors/{doctorId}/appointments
```

**Request:**
```json
{
  "scheduledDate": "2024-01-15",
  "scheduledTime": "09:00:00",
  "reasonForVisit": "Chest pain and breathlessness",
  "notes": "Patient has been experiencing chest pain for 2 days",
  "patientId": "guid"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "guid",
    "doctorId": "guid",
    "patientId": "guid",
    "scheduledDate": "2024-01-15",
    "scheduledTime": "09:00:00",
    "durationMinutes": 30,
    "status": "scheduled",
    "reasonForVisit": "Chest pain and breathlessness",
    "notes": "Patient has been experiencing chest pain for 2 days",
    "fee": 2500.00,
    "isPaid": false,
    "createdAt": "2024-01-10T14:30:00Z",
    "confirmationNumber": "APT-2024-001234"
  }
}
```

### **2. Hospital Selection Flow**

#### **Get Hospital Profile**
```http
GET /api/v1/hospitals/{hospitalId}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "guid",
    "name": "Apollo Hospital Jubilee Hills",
    "description": "Premier multi-specialty hospital...",
    "address": "Road No. 72, Film Nagar, Jubilee Hills",
    "city": "Hyderabad",
    "state": "Telangana",
    "country": "India",
    "postalCode": "500033",
    "latitude": 17.4346,
    "longitude": 78.4066,
    "phone": "+91-40-23607777",
    "email": "info@apollohyd.com",
    "website": "www.apollohospitals.com",
    "bedCapacity": 750,
    "yearEstablished": 1988,
    "averageRating": 4.5,
    "totalReviews": 2500,
    "isActive": true,
    "specialties": [
      {
        "id": "guid",
        "name": "Cardiology",
        "description": "Heart and cardiovascular system"
      },
      {
        "id": "guid",
        "name": "Oncology", 
        "description": "Cancer treatment and care"
      }
    ],
    "amenities": [
      "WiFi",
      "Parking",
      "Cafeteria",
      "Pharmacy",
      "Emergency Services"
    ],
    "reviews": [
      {
        "id": "guid",
        "rating": 5,
        "comment": "Excellent hospital with great facilities...",
        "patientName": "Priya S.",
        "createdAt": "2024-01-20T10:30:00Z"
      }
    ]
  }
}
```

#### **Get Hospital Doctors**
```http
GET /api/v1/hospitals/{hospitalId}/doctors?specialty=cardiology&page=1&pageSize=20
```

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "guid",
        "firstName": "Dr. Suresh",
        "lastName": "Reddy",
        "qualification": "MBBS, MD, DM (Cardiology)",
        "yearsOfExperience": 18,
        "consultationFee": 2500.00,
        "averageRating": 4.7,
        "totalReviews": 450,
        "isAcceptingPatients": true,
        "specialties": [
          {
            "id": "guid",
            "name": "Cardiology",
            "isPrimary": true
          }
        ],
        "profileImageUrl": "https://..."
      }
    ],
    "totalCount": 25,
    "pageNumber": 1,
    "pageSize": 20,
    "totalPages": 2
  }
}
```

### **3. City Selection Flow**

#### **Get City Hospitals**
```http
GET /api/v1/cities/{cityId}/hospitals?specialty=cardiology&page=1&pageSize=20
```

**Response:**
```json
{
  "success": true,
  "data": {
    "city": {
      "id": "guid",
      "name": "Hyderabad",
      "state": "Telangana",
      "country": "India"
    },
    "hospitals": {
      "items": [
        {
          "id": "guid",
          "name": "Apollo Hospital Jubilee Hills",
          "address": "Road No. 72, Film Nagar, Jubilee Hills",
          "phone": "+91-40-23607777",
          "averageRating": 4.5,
          "totalReviews": 2500,
          "bedCapacity": 750,
          "specialties": [
            {
              "id": "guid",
              "name": "Cardiology"
            }
          ],
          "distanceFromCityCenter": 5.2
        }
      ],
      "totalCount": 15,
      "pageNumber": 1,
      "pageSize": 20,
      "totalPages": 1
    }
  }
}
```

### **4. Disease Selection Flow**

#### **Get Disease Doctors**
```http
GET /api/v1/diseases/{diseaseId}/doctors?city=hyderabad&page=1&pageSize=20
```

**Response:**
```json
{
  "success": true,
  "data": {
    "disease": {
      "id": "guid",
      "name": "Cardiac Disease",
      "category": "Cardiology",
      "description": "Heart and cardiovascular system diseases",
      "symptoms": "Chest pain, shortness of breath, fatigue",
      "treatmentOptions": "Medication, surgery, lifestyle changes"
    },
    "doctors": {
      "items": [
        {
          "id": "guid",
          "firstName": "Dr. Suresh",
          "lastName": "Reddy",
          "qualification": "MBBS, MD, DM (Cardiology)",
          "yearsOfExperience": 18,
          "consultationFee": 2500.00,
          "averageRating": 4.7,
          "totalReviews": 450,
          "hospital": {
            "id": "guid",
            "name": "Apollo Hospital Jubilee Hills",
            "city": "Hyderabad"
          },
          "specialties": [
            {
              "id": "guid",
              "name": "Cardiology",
              "isPrimary": true
            }
          ]
        }
      ],
      "totalCount": 12,
      "pageNumber": 1,
      "pageSize": 20,
      "totalPages": 1
    }
  }
}
```

## 🔐 Authentication & Authorization

### **Authentication Headers**
```http
Authorization: Bearer {jwt_token}
```

### **Role-Based Access**
- **Patient**: Can view all data, book appointments
- **Doctor**: Can view own profile, manage appointments
- **Hospital Admin**: Can manage hospital and doctor data
- **Support**: Full access for customer support

## 📊 Data Models

### **Doctor Model**
```typescript
interface Doctor {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  phone: string;
  qualification: string;
  yearsOfExperience: number;
  biography: string;
  profileImageUrl?: string;
  consultationFee: number;
  averageRating: number;
  totalReviews: number;
  isAcceptingPatients: boolean;
  hospital: Hospital;
  specialties: DoctorSpecialty[];
  languages: Language[];
  credentials: Credential[];
  reviews: Review[];
}
```

### **Hospital Model**
```typescript
interface Hospital {
  id: string;
  name: string;
  description: string;
  address: string;
  city: string;
  state: string;
  country: string;
  postalCode: string;
  latitude: number;
  longitude: number;
  phone: string;
  email: string;
  website: string;
  bedCapacity: number;
  yearEstablished: number;
  averageRating: number;
  totalReviews: number;
  isActive: boolean;
  specialties: Specialty[];
  amenities: string[];
  reviews: Review[];
}
```

### **Appointment Model**
```typescript
interface Appointment {
  id: string;
  doctorId: string;
  patientId: string;
  scheduledDate: string;
  scheduledTime: string;
  durationMinutes: number;
  status: 'scheduled' | 'confirmed' | 'completed' | 'cancelled';
  reasonForVisit: string;
  notes?: string;
  fee: number;
  isPaid: boolean;
  paidAt?: string;
  cancellationReason?: string;
  cancelledAt?: string;
  createdAt: string;
  updatedAt?: string;
  confirmationNumber: string;
}
```

## 🎯 Workflow Sequence

### **1. Doctor Selection Flow**
```
Search → Select Doctor → View Profile → Check Availability → Book Appointment
```

### **2. Hospital Selection Flow**
```
Search → Select Hospital → View Hospital → Select Doctor → View Profile → Check Availability → Book Appointment
```

### **3. City Selection Flow**
```
Search → Select City → View Hospitals → Select Hospital → Select Doctor → View Profile → Check Availability → Book Appointment
```

### **4. Disease Selection Flow**
```
Search → Select Disease → View Doctors → Select Doctor → View Profile → Check Availability → Book Appointment
```

## 🧪 Test Scenarios

### **Happy Path Tests**
- ✅ Doctor selection with available slots
- ✅ Hospital selection with multiple doctors
- ✅ City selection with multiple hospitals
- ✅ Disease selection with multiple doctors

### **Edge Cases**
- ❌ No doctors available for selected hospital
- ❌ No hospitals in selected city
- ❌ No doctors treating selected disease
- ❌ Doctor not accepting new patients
- ❌ No available appointment slots
- ❌ Invalid doctor/hospital/city/disease IDs

### **Error Responses**
```json
{
  "success": false,
  "error": {
    "code": "DOCTOR_NOT_FOUND",
    "message": "Doctor with ID {doctorId} not found",
    "details": "The requested doctor does not exist or is inactive"
  },
  "traceId": "guid"
}
```

## 📈 Performance Considerations

- **Pagination**: All list endpoints support pagination
- **Caching**: Doctor profiles and hospital data cached for 5 minutes
- **Indexing**: Database indexes on all search and filter columns
- **Eager Loading**: Related entities loaded in single query
- **Rate Limiting**: 100 requests per minute per user

## 🔄 Next Steps

1. Implement API endpoints in HospitalService
2. Update database schema with proper relationships
3. Create React UI components for each workflow
4. Add authentication and authorization
5. Implement comprehensive test coverage
6. Add API documentation with OpenAPI spec
