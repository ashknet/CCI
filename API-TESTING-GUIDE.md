# 🧪 API Testing Guide - Search-to-Selection Workflow

## 📋 Overview

This guide provides comprehensive testing scenarios for all API endpoints in the search-to-selection workflow. Test each endpoint to ensure proper functionality before production deployment.

## 🔧 Prerequisites

1. **Database Setup**
   ```sql
   -- Run these scripts in order
   :r "database-scripts/Search-StoredProcedures-Updated.sql"
   :r "database-scripts/Additional-Tables-For-Search-Workflow.sql"
   :r "MedTravel.Database/TestData/00-Execute-All-TestData.sql"
   ```

2. **Backend Running**
   ```bash
   cd backend/HospitalService/src/HospitalService.Api
   dotnet run
   ```

3. **Frontend Running**
   ```bash
   cd frontend
   npm run dev
   ```

## 🎯 Test Scenarios

### **1. Search Suggestions API**

#### **Test 1.1: Basic Search**
```bash
curl -X GET "https://localhost:64685/api/v1/search/suggest?term=apollo" \
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "success": true,
  "data": [
    {
      "text": "Apollo Hospital Jubilee Hills",
      "category": "Hospital",
      "id": "guid-here"
    }
  ],
  "message": "Found X suggestions"
}
```

#### **Test 1.2: Doctor Search**
```bash
curl -X GET "https://localhost:64685/api/v1/search/suggest?term=suresh" \
  -H "Content-Type: application/json"
```

#### **Test 1.3: City Search**
```bash
curl -X GET "https://localhost:64685/api/v1/search/suggest?term=hyderabad" \
  -H "Content-Type: application/json"
```

#### **Test 1.4: Specialty Search**
```bash
curl -X GET "https://localhost:64685/api/v1/search/suggest?term=cardio" \
  -H "Content-Type: application/json"
```

#### **Test 1.5: Disease Search**
```bash
curl -X GET "https://localhost:64685/api/v1/search/suggest?term=diabetes" \
  -H "Content-Type: application/json"
```

### **2. Doctor Selection Flow**

#### **Test 2.1: Get Doctor Profile**
```bash
# Replace {doctorId} with actual doctor ID from test data
curl -X GET "https://localhost:64685/api/v1/doctors/{doctorId}" \
  -H "Content-Type: application/json"
```

**Expected Response:**
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

#### **Test 2.2: Get Doctor Availability**
```bash
curl -X GET "https://localhost:64685/api/v1/doctors/{doctorId}/availability?startDate=2024-01-01&endDate=2024-01-31" \
  -H "Content-Type: application/json"
```

#### **Test 2.3: Book Appointment**
```bash
curl -X POST "https://localhost:64685/api/v1/doctors/{doctorId}/appointments" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {jwt_token}" \
  -d '{
    "scheduledDate": "2024-01-15",
    "scheduledTime": "09:00:00",
    "reasonForVisit": "Chest pain and breathlessness",
    "notes": "Patient has been experiencing chest pain for 2 days",
    "patientId": "guid"
  }'
```

### **3. Hospital Selection Flow**

#### **Test 3.1: Get Hospital Profile**
```bash
curl -X GET "https://localhost:64685/api/v1/hospitals/{hospitalId}" \
  -H "Content-Type: application/json"
```

#### **Test 3.2: Get Hospital Doctors**
```bash
curl -X GET "https://localhost:64685/api/v1/hospitals/{hospitalId}/doctors?specialty=cardiology&page=1&pageSize=20" \
  -H "Content-Type: application/json"
```

#### **Test 3.3: Get Hospital Reviews**
```bash
curl -X GET "https://localhost:64685/api/v1/hospitals/{hospitalId}/reviews?page=1&pageSize=20" \
  -H "Content-Type: application/json"
```

### **4. City Selection Flow**

#### **Test 4.1: Get City Hospitals**
```bash
curl -X GET "https://localhost:64685/api/v1/cities/{cityId}/hospitals?specialty=cardiology&page=1&pageSize=20" \
  -H "Content-Type: application/json"
```

#### **Test 4.2: Get All Cities**
```bash
curl -X GET "https://localhost:64685/api/v1/cities?country=India&page=1&pageSize=50" \
  -H "Content-Type: application/json"
```

#### **Test 4.3: Get City Details**
```bash
curl -X GET "https://localhost:64685/api/v1/cities/{cityId}" \
  -H "Content-Type: application/json"
```

### **5. Disease Selection Flow**

#### **Test 5.1: Get Disease Doctors**
```bash
curl -X GET "https://localhost:64685/api/v1/diseases/{diseaseId}/doctors?city=hyderabad&page=1&pageSize=20" \
  -H "Content-Type: application/json"
```

#### **Test 5.2: Get All Diseases**
```bash
curl -X GET "https://localhost:64685/api/v1/diseases?category=cardiology&page=1&pageSize=50" \
  -H "Content-Type: application/json"
```

#### **Test 5.3: Get Disease Details**
```bash
curl -X GET "https://localhost:64685/api/v1/diseases/{diseaseId}" \
  -H "Content-Type: application/json"
```

#### **Test 5.4: Get Diseases by Category**
```bash
curl -X GET "https://localhost:64685/api/v1/diseases/category/cardiology?page=1&pageSize=50" \
  -H "Content-Type: application/json"
```

## 🚨 Error Testing

### **Test 6.1: Invalid Doctor ID**
```bash
curl -X GET "https://localhost:64685/api/v1/doctors/00000000-0000-0000-0000-000000000000" \
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "success": false,
  "error": {
    "code": "DOCTOR_NOT_FOUND",
    "message": "Doctor with ID 00000000-0000-0000-0000-000000000000 not found",
    "details": "The requested doctor does not exist or is inactive"
  },
  "traceId": "guid"
}
```

### **Test 6.2: Invalid Hospital ID**
```bash
curl -X GET "https://localhost:64685/api/v1/hospitals/00000000-0000-0000-0000-000000000000" \
  -H "Content-Type: application/json"
```

### **Test 6.3: Invalid City ID**
```bash
curl -X GET "https://localhost:64685/api/v1/cities/00000000-0000-0000-0000-000000000000" \
  -H "Content-Type: application/json"
```

### **Test 6.4: Invalid Disease ID**
```bash
curl -X GET "https://localhost:64685/api/v1/diseases/00000000-0000-0000-0000-000000000000" \
  -H "Content-Type: application/json"
```

### **Test 6.5: Unauthorized Access**
```bash
curl -X POST "https://localhost:64685/api/v1/doctors/{doctorId}/appointments" \
  -H "Content-Type: application/json" \
  -d '{
    "scheduledDate": "2024-01-15",
    "scheduledTime": "09:00:00",
    "reasonForVisit": "Test appointment",
    "patientId": "guid"
  }'
```

**Expected Response:**
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication required",
    "details": "Please provide a valid JWT token"
  },
  "traceId": "guid"
}
```

## 📊 Performance Testing

### **Test 7.1: Search Performance**
```bash
# Test search response time (should be < 200ms)
time curl -X GET "https://localhost:64685/api/v1/search/suggest?term=apollo" \
  -H "Content-Type: application/json"
```

### **Test 7.2: Pagination Performance**
```bash
# Test large page size
curl -X GET "https://localhost:64685/api/v1/hospitals/{hospitalId}/doctors?page=1&pageSize=100" \
  -H "Content-Type: application/json"
```

### **Test 7.3: Concurrent Requests**
```bash
# Test multiple concurrent requests
for i in {1..10}; do
  curl -X GET "https://localhost:64685/api/v1/search/suggest?term=test$i" \
    -H "Content-Type: application/json" &
done
wait
```

## 🔍 Frontend Testing

### **Test 8.1: Search Workflow Component**
1. Navigate to `/search-workflow` in the frontend
2. Type "apollo" in the search box
3. Verify suggestions appear
4. Click on a hospital suggestion
5. Verify next step options appear
6. Test back navigation

### **Test 8.2: Search Bar Integration**
1. Navigate to the main search bar
2. Type "suresh" 
3. Verify doctor suggestions appear
4. Click on a doctor suggestion
5. Verify navigation to doctor profile

### **Test 8.3: Responsive Design**
1. Test on mobile devices
2. Verify search suggestions are touch-friendly
3. Test keyboard navigation
4. Verify accessibility features

## 📈 Load Testing

### **Test 9.1: Search Load Test**
```bash
# Using Apache Bench (if available)
ab -n 1000 -c 10 "https://localhost:64685/api/v1/search/suggest?term=test"
```

### **Test 9.2: Database Load Test**
```sql
-- Test stored procedure performance
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'apollo', @MaxResults = 10;
```

## ✅ Success Criteria

### **Functional Requirements**
- ✅ All API endpoints return correct data
- ✅ Search suggestions work for all categories
- ✅ Pagination works correctly
- ✅ Error handling is proper
- ✅ Authentication/authorization works

### **Performance Requirements**
- ✅ Search API responds in < 200ms
- ✅ Database queries complete in < 100ms
- ✅ Frontend renders in < 500ms
- ✅ No memory leaks in long-running tests

### **User Experience Requirements**
- ✅ Search is intuitive and fast
- ✅ Navigation between steps is smooth
- ✅ Error messages are user-friendly
- ✅ Mobile experience is optimized

## 🐛 Common Issues & Solutions

### **Issue 1: Empty Search Results**
**Solution:** Ensure test data is loaded
```sql
:r "MedTravel.Database/TestData/00-Execute-All-TestData.sql"
```

### **Issue 2: 404 Errors**
**Solution:** Check API versioning and routes
- Ensure using `/api/v1/` prefix
- Verify controller routes are correct

### **Issue 3: Database Connection Errors**
**Solution:** Check connection string and database availability
```bash
# Test database connection
sqlcmd -S localhost -d MedTravelDb -Q "SELECT 1"
```

### **Issue 4: CORS Issues**
**Solution:** Configure CORS in Program.cs
```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("https://localhost:3000")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});
```

## 📝 Test Results Template

```
Test Date: ___________
Tester: ___________
Environment: ___________

API Endpoints Tested:
[ ] Search Suggestions
[ ] Doctor Profile
[ ] Doctor Availability
[ ] Hospital Profile
[ ] Hospital Doctors
[ ] City Hospitals
[ ] Disease Doctors
[ ] Appointment Booking

Performance Results:
- Search API Response Time: _____ms
- Database Query Time: _____ms
- Frontend Load Time: _____ms

Issues Found:
1. ___________
2. ___________
3. ___________

Overall Status: [ ] PASS [ ] FAIL [ ] PARTIAL
```

## 🚀 Next Steps

1. **Run all tests** in the order specified
2. **Document any issues** found during testing
3. **Fix critical issues** before production deployment
4. **Set up monitoring** for production APIs
5. **Create automated test suite** for CI/CD pipeline
