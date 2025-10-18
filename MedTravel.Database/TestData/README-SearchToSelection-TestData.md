# Search-to-Selection Test Data Documentation

## Overview

This document describes the comprehensive test data created to support the search-to-selection workflow functionality in the MedTravel system. The test data includes diseases, doctor-disease relationships, doctor availability, and doctor language capabilities.

## Test Data Scripts

### Core Test Data Scripts

1. **11-Insert-Diseases-50.sql**
   - Inserts 50 common diseases across various medical categories
   - Includes cardiovascular, neurological, endocrine, respiratory, gastrointestinal, musculoskeletal, mental health, cancer, kidney, liver, skin, eye, infectious, autoimmune, pediatric, gynecological, and urological diseases
   - Each disease includes name, category, description, symptoms, ICD10 code, treatment options, and average treatment cost

2. **12-Insert-DoctorDiseases-300.sql**
   - Creates realistic doctor-disease relationships based on medical specialties
   - Ensures doctors are linked to diseases they would actually treat
   - Includes both primary and secondary disease relationships
   - Adds years of experience and treatment notes for each relationship

3. **13-Insert-DoctorAvailability-150.sql**
   - Creates availability schedules for all active doctors
   - Generates realistic working hours (Monday-Friday, some weekend availability)
   - Includes different slot durations (30 or 45 minutes)
   - Special patterns for emergency medicine and surgical specialties

4. **14-Insert-DoctorLanguages-200.sql**
   - Adds language capabilities for doctors
   - Ensures all doctors speak English
   - Adds regional Indian languages (Hindi, Telugu, Tamil, etc.)
   - Includes international languages for some doctors
   - Proficiency levels: Native, Fluent, Intermediate, Basic

5. **15-Test-SearchToSelection-Queries.sql**
   - Comprehensive test queries to validate the search-to-selection functionality
   - Tests all four main workflows: Doctor, Hospital, City, and Disease selection
   - Includes performance analysis and data distribution checks

## Data Categories

### Diseases (50 total)

#### Cardiovascular Diseases
- Hypertension
- Coronary Artery Disease
- Heart Failure
- Atrial Fibrillation

#### Neurological Diseases
- Migraine
- Epilepsy
- Parkinson Disease
- Alzheimer Disease

#### Endocrine Diseases
- Type 2 Diabetes
- Type 1 Diabetes
- Hypothyroidism
- Hyperthyroidism

#### Respiratory Diseases
- Asthma
- COPD
- Pneumonia

#### Gastrointestinal Diseases
- Gastroesophageal Reflux Disease
- Irritable Bowel Syndrome
- Crohn Disease
- Ulcerative Colitis

#### Musculoskeletal Diseases
- Osteoarthritis
- Rheumatoid Arthritis
- Osteoporosis

#### Mental Health Diseases
- Major Depressive Disorder
- Generalized Anxiety Disorder
- Bipolar Disorder

#### Cancer Diseases
- Breast Cancer
- Lung Cancer
- Prostate Cancer
- Colorectal Cancer

#### And many more across all medical specialties...

### Doctor-Disease Relationships

The relationships are created based on medical logic:

- **Cardiology doctors** treat cardiovascular diseases
- **Neurology doctors** treat neurological conditions
- **Endocrinology doctors** treat diabetes and thyroid disorders
- **Pulmonology doctors** treat respiratory diseases
- **Gastroenterology doctors** treat digestive system diseases
- **Orthopedics doctors** treat musculoskeletal conditions
- **Psychiatry doctors** treat mental health disorders
- **Oncology doctors** treat cancer
- **Nephrology doctors** treat kidney diseases
- **Dermatology doctors** treat skin conditions
- **Ophthalmology doctors** treat eye diseases
- **Urology doctors** treat urological conditions
- **Gynecology doctors** treat women's health issues
- **Pediatrics doctors** treat childhood conditions

### Doctor Availability Patterns

- **Standard Pattern**: Monday-Friday, 8-10 hours per day
- **Emergency Medicine**: 24/7 availability
- **Surgical Specialties**: Limited days (e.g., Tuesday, Thursday, Saturday)
- **Part-time Doctors**: 20% of doctors work reduced hours
- **Weekend Availability**: 30% of doctors work on Saturdays

### Language Distribution

- **English**: 100% of doctors (Native proficiency)
- **Hindi**: 80% of doctors (various proficiency levels)
- **Telugu**: 30% of doctors (regional language)
- **Tamil**: 25% of doctors (regional language)
- **Other Regional Languages**: 15% each (Kannada, Malayalam, Bengali, etc.)
- **International Languages**: 10% each (Arabic, French, German, Spanish)

## Search-to-Selection Workflows Supported

### 1. Doctor Selection Flow
```
Search for Doctor → Select Doctor → View Profile & Availability → Book Appointment
```

**Test Data Includes:**
- Doctor profiles with qualifications, experience, ratings
- Availability schedules with working hours and slot durations
- Recent reviews and ratings
- Hospital information and location
- Specialties and languages spoken

### 2. Hospital Selection Flow
```
Search for Hospital → Select Hospital → Browse Doctors → Select Doctor → Book Appointment
```

**Test Data Includes:**
- Hospital details with amenities and ratings
- List of doctors at each hospital
- Available specialties at each hospital
- Doctor availability and consultation fees

### 3. City Selection Flow
```
Search for City → Select City → Browse Hospitals → Select Hospital → Browse Doctors → Book Appointment
```

**Test Data Includes:**
- City information with location details
- List of hospitals in each city
- Total doctor count per city
- Available specialties in each city
- Hospital ratings and bed capacity

### 4. Disease Selection Flow
```
Search for Disease → Select Disease → Find Specialists → Select Doctor → Book Appointment
```

**Test Data Includes:**
- Disease information with symptoms and treatment options
- List of specialists who treat each disease
- Related medical specialties
- Top hospitals for each disease
- Doctor experience with specific diseases

## Data Quality Features

### Realistic Relationships
- Doctors are only linked to diseases they would actually treat
- Availability patterns match real-world medical practice
- Language distribution reflects Indian healthcare context
- Hospital-doctor relationships are geographically logical

### Comprehensive Coverage
- 50 diseases across all major medical categories
- 300+ doctor-disease relationships
- 150+ availability records
- 200+ language relationships
- All 150 doctors have complete profiles

### Performance Optimized
- Proper indexing on frequently queried fields
- Efficient foreign key relationships
- Optimized query patterns for search operations
- Realistic data distribution for testing

## Usage Instructions

### Running the Test Data Scripts

1. **Execute the main script:**
   ```sql
   :r "00-Execute-All-TestData.sql"
   ```

2. **Or run individual scripts:**
   ```sql
   :r "11-Insert-Diseases-50.sql"
   :r "12-Insert-DoctorDiseases-300.sql"
   :r "13-Insert-DoctorAvailability-150.sql"
   :r "14-Insert-DoctorLanguages-200.sql"
   ```

3. **Test the functionality:**
   ```sql
   :r "15-Test-SearchToSelection-Queries.sql"
   ```

### Expected Results

After running all scripts, you should have:
- 50 diseases in the `Metadata.Diseases` table
- 300+ relationships in the `Hospital.DoctorDiseases` table
- 150+ availability records in the `Hospital.DoctorAvailability` table
- 200+ language relationships in the `Hospital.DoctorLanguages` table
- 15 languages in the `Metadata.Languages` table

## Testing the Search-to-Selection Workflows

### Sample Queries

1. **Find doctors treating diabetes:**
   ```sql
   SELECT d.FirstName + ' ' + d.LastName AS DoctorName, h.Name AS Hospital
   FROM Hospital.Doctors d
   INNER JOIN Hospital.DoctorDiseases dd ON d.Id = dd.DoctorId
   INNER JOIN Metadata.Diseases dis ON dd.DiseaseId = dis.Id
   INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
   WHERE dis.Name = 'Type 2 Diabetes' AND d.IsActive = 1;
   ```

2. **Find hospitals in a city:**
   ```sql
   SELECT h.Name, h.Address, COUNT(d.Id) AS DoctorCount
   FROM Hospital.Hospitals h
   INNER JOIN Metadata.Cities c ON h.CityId = c.Id
   LEFT JOIN Hospital.Doctors d ON h.Id = d.HospitalId
   WHERE c.Name = 'Hyderabad' AND h.IsActive = 1
   GROUP BY h.Id, h.Name, h.Address;
   ```

3. **Check doctor availability:**
   ```sql
   SELECT d.FirstName + ' ' + d.LastName AS DoctorName,
          CASE da.DayOfWeek
              WHEN 1 THEN 'Monday'
              WHEN 2 THEN 'Tuesday'
              -- ... etc
          END AS DayOfWeek,
          da.StartTime, da.EndTime
   FROM Hospital.Doctors d
   INNER JOIN Hospital.DoctorAvailability da ON d.Id = da.DoctorId
   WHERE d.IsActive = 1 AND da.IsActive = 1;
   ```

## Maintenance and Updates

### Adding New Diseases
1. Add disease to `11-Insert-Diseases-50.sql`
2. Update `12-Insert-DoctorDiseases-300.sql` to include relationships
3. Re-run the scripts

### Adding New Languages
1. Add language to `14-Insert-DoctorLanguages-200.sql`
2. Update the language distribution logic
3. Re-run the script

### Modifying Availability Patterns
1. Update the logic in `13-Insert-DoctorAvailability-150.sql`
2. Adjust the availability generation algorithms
3. Re-run the script

## Performance Considerations

- All scripts use efficient bulk insert operations
- Proper indexing is maintained on foreign key relationships
- Data is distributed realistically to avoid performance bottlenecks
- Query patterns are optimized for the search-to-selection workflows

## Troubleshooting

### Common Issues

1. **Foreign Key Violations**: Ensure all referenced entities exist before running relationship scripts
2. **Duplicate Data**: Scripts use `IF NOT EXISTS` checks to prevent duplicates
3. **Performance Issues**: Run scripts during off-peak hours for large datasets

### Validation Queries

Run these queries to validate the data:

```sql
-- Check data counts
SELECT 'Diseases' AS Entity, COUNT(*) AS Count FROM Metadata.Diseases
UNION ALL
SELECT 'Doctor-Disease Relationships', COUNT(*) FROM Hospital.DoctorDiseases
UNION ALL
SELECT 'Doctor Availability', COUNT(*) FROM Hospital.DoctorAvailability
UNION ALL
SELECT 'Doctor Languages', COUNT(*) FROM Hospital.DoctorLanguages;

-- Check for orphaned records
SELECT COUNT(*) AS OrphanedDoctorDiseases
FROM Hospital.DoctorDiseases dd
LEFT JOIN Hospital.Doctors d ON dd.DoctorId = d.Id
WHERE d.Id IS NULL;
```

This comprehensive test data ensures that the search-to-selection workflows can be thoroughly tested with realistic, medically accurate data that reflects real-world healthcare scenarios.
