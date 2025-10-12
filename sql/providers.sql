-- Provider Directory SQL schema
CREATE SCHEMA provider AUTHORIZATION dbo;

CREATE TABLE provider.Hospitals (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(256) NOT NULL,
    City NVARCHAR(128) NOT NULL,
    State NVARCHAR(128) NULL,
    Country NVARCHAR(128) NOT NULL,
    Address NVARCHAR(512) NULL,
    Latitude DECIMAL(9,6) NULL,
    Longitude DECIMAL(9,6) NULL,
    Accreditation NVARCHAR(128) NULL,
    Rating DECIMAL(3,2) NULL,
    CreatedAtUtc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE provider.Doctors (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    HospitalId BIGINT NOT NULL REFERENCES provider.Hospitals(Id),
    FullName NVARCHAR(256) NOT NULL,
    Specialty NVARCHAR(128) NOT NULL,
    ExperienceYears INT NOT NULL,
    Languages NVARCHAR(256) NULL,
    Bio NVARCHAR(MAX) NULL,
    Rating DECIMAL(3,2) NULL,
    ProfileImageUrl NVARCHAR(512) NULL,
    CreatedAtUtc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE provider.Diseases (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(256) NOT NULL,
    Description NVARCHAR(MAX) NULL
);

CREATE TABLE provider.DoctorDiseases (
    DoctorId BIGINT NOT NULL REFERENCES provider.Doctors(Id),
    DiseaseId BIGINT NOT NULL REFERENCES provider.Diseases(Id),
    PRIMARY KEY(DoctorId, DiseaseId)
);

GO

CREATE OR ALTER VIEW provider.vDoctorProfiles AS
SELECT d.Id AS DoctorId, d.FullName, d.Specialty, d.ExperienceYears, d.Languages, d.Rating,
       h.Name AS HospitalName, h.City, h.State, h.Country, h.Accreditation, h.Rating AS HospitalRating
FROM provider.Doctors d
JOIN provider.Hospitals h ON d.HospitalId = h.Id;
GO

CREATE OR ALTER PROCEDURE provider.sp_SearchProviders
    @q NVARCHAR(256) = NULL,
    @hospital NVARCHAR(256) = NULL,
    @doctor NVARCHAR(256) = NULL,
    @city NVARCHAR(128) = NULL,
    @disease NVARCHAR(256) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DISTINCT d.Id AS DoctorId, d.FullName, d.Specialty, d.Rating,
           h.Name AS HospitalName, h.City, h.State, h.Country
    FROM provider.Doctors d
    JOIN provider.Hospitals h ON d.HospitalId = h.Id
    LEFT JOIN provider.DoctorDiseases dd ON dd.DoctorId = d.Id
    LEFT JOIN provider.Diseases dis ON dis.Id = dd.DiseaseId
    WHERE (@q IS NULL OR d.FullName LIKE '%' + @q + '%' OR h.Name LIKE '%' + @q + '%' OR dis.Name LIKE '%' + @q + '%' OR h.City LIKE '%' + @q + '%')
      AND (@hospital IS NULL OR h.Name LIKE '%' + @hospital + '%')
      AND (@doctor IS NULL OR d.FullName LIKE '%' + @doctor + '%')
      AND (@city IS NULL OR h.City LIKE '%' + @city + '%')
      AND (@disease IS NULL OR dis.Name LIKE '%' + @disease + '%')
    ORDER BY d.Rating DESC;
END
GO

-- seed
INSERT INTO provider.Hospitals(Name, City, State, Country, Accreditation, Rating)
VALUES
('Apollo Hospitals', 'Hyderabad', 'Telangana', 'India', 'NABH', 4.6),
('Fortis Hospital', 'Bangalore', 'Karnataka', 'India', 'NABH', 4.5),
('Lilavati Hospital', 'Mumbai', 'Maharashtra', 'India', 'NABH', 4.4);

INSERT INTO provider.Doctors(HospitalId, FullName, Specialty, ExperienceYears, Languages, Rating)
VALUES
(1, 'Dr. Priya Sharma', 'Cardiology', 12, 'English,Hindi,Telugu', 4.8),
(1, 'Dr. Arjun Rao', 'Orthopedics', 10, 'English,Telugu', 4.5),
(2, 'Dr. Kavya Iyer', 'Neurology', 15, 'English,Kannada,Hindi', 4.7),
(3, 'Dr. Rohan Mehta', 'Oncology', 9, 'English,Hindi,Marathi', 4.6);

INSERT INTO provider.Diseases(Name)
VALUES('Cardiac Arrhythmia'), ('Knee Replacement'), ('Brain Tumor'), ('Breast Cancer');

INSERT INTO provider.DoctorDiseases(DoctorId, DiseaseId)
VALUES (1,1),(2,2),(3,3),(4,4);
