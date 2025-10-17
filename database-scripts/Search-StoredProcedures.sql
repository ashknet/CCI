-- =============================================
-- High-Performance Search Stored Procedures
-- Optimized for instant search experience
-- =============================================

USE MedTravelDb;
GO

-- Drop existing procedure if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Hospital.uspGetSearchSuggestions') AND type in (N'P', N'PC'))
DROP PROCEDURE Hospital.uspGetSearchSuggestions;
GO

-- =============================================
-- Procedure: Hospital.uspGetSearchSuggestions
-- Description: Ultra-fast search suggestions across all entities
-- Performance Target: < 100ms
-- =============================================
CREATE PROCEDURE Hospital.uspGetSearchSuggestions
    @SearchTerm NVARCHAR(100),
    @MaxResults INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- For faster reads
    
    DECLARE @SearchPattern NVARCHAR(102) = '%' + @SearchTerm + '%';
    DECLARE @StartPattern NVARCHAR(102) = @SearchTerm + '%';
    
    -- Use UNION ALL for better performance (no duplicate checking)
    -- Results are ordered by relevance: exact match first, then starts with, then contains
    
    SELECT TOP (@MaxResults)
        Text,
        Category,
        Id,
        Relevance
    FROM (
        -- Hospitals (highest priority)
        SELECT 
            h.Name AS Text,
            'Hospital' AS Category,
            h.Id AS Id,
            CASE 
                WHEN h.Name = @SearchTerm THEN 1                    -- Exact match
                WHEN h.Name LIKE @StartPattern THEN 2               -- Starts with
                WHEN h.Description LIKE @SearchPattern THEN 3       -- In description
                ELSE 4                                              -- In other fields
            END AS Relevance,
            h.AverageRating AS Rating
        FROM Hospital.Hospitals h WITH (NOLOCK)
        WHERE h.IsActive = 1
          AND (h.Name LIKE @SearchPattern 
           OR h.City LIKE @SearchPattern 
           OR h.Description LIKE @SearchPattern)
        
        UNION ALL
        
        -- Doctors
        SELECT 
            CONCAT(d.FirstName, ' ', d.LastName) AS Text,
            'Doctor' AS Category,
            d.Id AS Id,
            CASE 
                WHEN d.FirstName LIKE @StartPattern OR d.LastName LIKE @StartPattern THEN 2
                WHEN d.Biography LIKE @SearchPattern THEN 3
                ELSE 4
            END AS Relevance,
            d.AverageRating AS Rating
        FROM Hospital.Doctors d WITH (NOLOCK)
        WHERE d.IsActive = 1
          AND (d.FirstName LIKE @SearchPattern 
           OR d.LastName LIKE @SearchPattern 
           OR d.Qualification LIKE @SearchPattern
           OR d.Biography LIKE @SearchPattern)
        
        UNION ALL
        
        -- Cities (from Metadata schema)
        SELECT DISTINCT
            c.Name AS Text,
            'City' AS Category,
            c.Id AS Id,
            CASE 
                WHEN c.Name = @SearchTerm THEN 1
                WHEN c.Name LIKE @StartPattern THEN 2
                ELSE 4
            END AS Relevance,
            0 AS Rating
        FROM Metadata.Cities c WITH (NOLOCK)
        WHERE c.Name LIKE @SearchPattern
        
        UNION ALL
        
        -- Specialties
        SELECT 
            s.Name AS Text,
            'Specialty' AS Category,
            s.Id AS Id,
            CASE 
                WHEN s.Name = @SearchTerm THEN 1
                WHEN s.Name LIKE @StartPattern THEN 2
                ELSE 4
            END AS Relevance,
            0 AS Rating
        FROM Hospital.Specialties s WITH (NOLOCK)
        WHERE s.Name LIKE @SearchPattern
        
        UNION ALL
        
        -- Diseases (from Metadata schema)
        SELECT 
            d.Name AS Text,
            'Disease' AS Category,
            d.Id AS Id,
            CASE 
                WHEN d.Name = @SearchTerm THEN 1
                WHEN d.Name LIKE @StartPattern THEN 2
                WHEN d.Description LIKE @SearchPattern THEN 3
                ELSE 4
            END AS Relevance,
            0 AS Rating
        FROM Metadata.Diseases d WITH (NOLOCK)
        WHERE d.Name LIKE @SearchPattern 
           OR d.Description LIKE @SearchPattern
           
    ) AS AllResults
    ORDER BY 
        Relevance ASC,      -- Best relevance first
        Rating DESC,        -- Highest rated first
        Text ASC;           -- Alphabetical
END;
GO

-- =============================================
-- Create indexes for optimal search performance
-- =============================================

-- Hospital indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Hospitals_Search' AND object_id = OBJECT_ID('Hospital.Hospitals'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Hospitals_Search
    ON Hospital.Hospitals(Name, City, IsActive)
    INCLUDE (Description, AverageRating);
END;
GO

-- Doctor indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Doctors_Search' AND object_id = OBJECT_ID('Hospital.Doctors'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Doctors_Search
    ON Hospital.Doctors(FirstName, LastName, IsActive)
    INCLUDE (Qualification, Biography, AverageRating);
END;
GO

-- City indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Cities_Search' AND object_id = OBJECT_ID('Metadata.Cities'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Cities_Search
    ON Metadata.Cities(Name)
    INCLUDE (StateId, CountryId);
END;
GO

-- Specialty indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Specialties_Search' AND object_id = OBJECT_ID('Hospital.Specialties'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Specialties_Search
    ON Hospital.Specialties(Name);
END;
GO

-- Disease indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Diseases_Search' AND object_id = OBJECT_ID('Metadata.Diseases'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Diseases_Search
    ON Metadata.Diseases(Name)
    INCLUDE (Description);
END;
GO

-- =============================================
-- Test the stored procedure
-- =============================================
PRINT 'Testing search stored procedure...';

-- Test 1: Search for "heart"
EXEC Hospital.uspGetSearchSuggestions @SearchTerm = 'heart', @MaxResults = 10;

-- Test 2: Search for "doctor"
EXEC Hospital.uspGetSearchSuggestions @SearchTerm = 'doctor', @MaxResults = 10;

-- Test 3: Search for city "hyd"
EXEC Hospital.uspGetSearchSuggestions @SearchTerm = 'hyd', @MaxResults = 10;

PRINT 'Search stored procedure created and tested successfully!';
GO
