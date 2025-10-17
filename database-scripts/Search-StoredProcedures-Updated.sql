-- =============================================
-- Updated Search Stored Procedures
-- Based on actual MedTravel.Database schema
-- =============================================

USE MedTravelDb;
GO

-- Create Search Schema if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Search')
BEGIN
    EXEC('CREATE SCHEMA Search');
END
GO

-- Drop existing procedure if it exists
IF OBJECT_ID('Hospital.GetSearchSuggestions', 'P') IS NOT NULL
    DROP PROCEDURE Hospital.GetSearchSuggestions;
GO

-- Create the optimized stored procedure for fast search suggestions
CREATE PROCEDURE Hospital.GetSearchSuggestions
    @SearchTerm NVARCHAR(255),
    @MaxResults INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- For maximum read performance

    DECLARE @SearchPattern NVARCHAR(257) = @SearchTerm + '%';
    DECLARE @ContainsSearchTerm NVARCHAR(257) = '%' + @SearchTerm + '%';

    -- Use a temporary table to collect and rank suggestions
    CREATE TABLE #Suggestions (
        Text NVARCHAR(255),
        Category NVARCHAR(50),
        Id UNIQUEIDENTIFIER NULL,
        Rank INT
    );

    -- 1. Hospitals (Exact match, Starts with, Contains)
    INSERT INTO #Suggestions (Text, Category, Id, Rank)
    SELECT TOP (@MaxResults)
        h.Name AS Text,
        'Hospital' AS Category,
        h.Id AS Id,
        CASE
            WHEN h.Name = @SearchTerm THEN 1 -- Exact match
            WHEN h.Name LIKE @SearchPattern THEN 2 -- Starts with
            ELSE 3 -- Contains
        END AS Rank
    FROM Hospital.Hospitals h WITH (NOLOCK)
    WHERE h.IsActive = 1 
        AND h.Name LIKE @ContainsSearchTerm
    ORDER BY Rank, h.Name;

    -- 2. Doctors (Exact match, Starts with, Contains)
    INSERT INTO #Suggestions (Text, Category, Id, Rank)
    SELECT TOP (@MaxResults)
        CONCAT(d.FirstName, ' ', d.LastName) AS Text,
        'Doctor' AS Category,
        d.Id AS Id,
        CASE
            WHEN CONCAT(d.FirstName, ' ', d.LastName) = @SearchTerm THEN 1
            WHEN CONCAT(d.FirstName, ' ', d.LastName) LIKE @SearchPattern THEN 2
            ELSE 3
        END AS Rank
    FROM Hospital.Doctors d WITH (NOLOCK)
    WHERE d.IsActive = 1 
        AND d.IsAcceptingPatients = 1
        AND (d.FirstName LIKE @ContainsSearchTerm 
             OR d.LastName LIKE @ContainsSearchTerm 
             OR CONCAT(d.FirstName, ' ', d.LastName) LIKE @ContainsSearchTerm)
    ORDER BY Rank, CONCAT(d.FirstName, ' ', d.LastName);

    -- 3. Cities
    INSERT INTO #Suggestions (Text, Category, Id, Rank)
    SELECT TOP (@MaxResults)
        c.Name AS Text,
        'City' AS Category,
        c.Id AS Id,
        CASE
            WHEN c.Name = @SearchTerm THEN 1
            WHEN c.Name LIKE @SearchPattern THEN 2
            ELSE 3
        END AS Rank
    FROM Metadata.Cities c WITH (NOLOCK)
    WHERE c.IsActive = 1 
        AND c.Name LIKE @ContainsSearchTerm
    ORDER BY Rank, c.Name;

    -- 4. Specialties
    INSERT INTO #Suggestions (Text, Category, Id, Rank)
    SELECT TOP (@MaxResults)
        s.Name AS Text,
        'Specialty' AS Category,
        s.Id AS Id,
        CASE
            WHEN s.Name = @SearchTerm THEN 1
            WHEN s.Name LIKE @SearchPattern THEN 2
            ELSE 3
        END AS Rank
    FROM Metadata.Specialties s WITH (NOLOCK)
    WHERE s.Name LIKE @ContainsSearchTerm
    ORDER BY Rank, s.Name;

    -- 5. Diseases
    INSERT INTO #Suggestions (Text, Category, Id, Rank)
    SELECT TOP (@MaxResults)
        d.Name AS Text,
        'Disease' AS Category,
        d.Id AS Id,
        CASE
            WHEN d.Name = @SearchTerm THEN 1
            WHEN d.Name LIKE @SearchPattern THEN 2
            ELSE 3
        END AS Rank
    FROM Metadata.Diseases d WITH (NOLOCK)
    WHERE d.Name LIKE @ContainsSearchTerm
    ORDER BY Rank, d.Name;

    -- Combine and return top unique suggestions, ordered by rank and then text
    SELECT TOP (@MaxResults)
        Text,
        Category,
        Id
    FROM #Suggestions
    ORDER BY Rank, Text
    OPTION (RECOMPILE); -- Ensures optimal plan for each search term

    DROP TABLE #Suggestions;
END;
GO

-- Create Full-Text Search Indexes for better performance (if not already created)
-- Ensure Full-Text Search is enabled on your SQL Server instance

-- Hospitals Table Full-Text Index
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('Hospital.Hospitals'))
BEGIN
    -- Create Full-Text Catalog if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.fulltext_catalogs WHERE name = 'MedTravelFTSCatalog')
    BEGIN
        CREATE FULLTEXT CATALOG MedTravelFTSCatalog AS DEFAULT;
    END

    -- Create Full-Text Index on Hospitals
    CREATE FULLTEXT INDEX ON Hospital.Hospitals(Name, Description, Address)
    KEY INDEX PK_Hospitals ON MedTravelFTSCatalog
    WITH CHANGE_TRACKING AUTO;
END
GO

-- Doctors Table Full-Text Index
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('Hospital.Doctors'))
BEGIN
    CREATE FULLTEXT INDEX ON Hospital.Doctors(FirstName, LastName, Qualification, Biography)
    KEY INDEX PK_Doctors ON MedTravelFTSCatalog
    WITH CHANGE_TRACKING AUTO;
END
GO

-- Specialties Table Full-Text Index
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('Metadata.Specialties'))
BEGIN
    CREATE FULLTEXT INDEX ON Metadata.Specialties(Name, Description)
    KEY INDEX PK_Specialties ON MedTravelFTSCatalog
    WITH CHANGE_TRACKING AUTO;
END
GO

-- Diseases Table Full-Text Index
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('Metadata.Diseases'))
BEGIN
    CREATE FULLTEXT INDEX ON Metadata.Diseases(Name, Description, Symptoms)
    KEY INDEX PK_Diseases ON MedTravelFTSCatalog
    WITH CHANGE_TRACKING AUTO;
END
GO

-- Cities Table Full-Text Index
IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = OBJECT_ID('Metadata.Cities'))
BEGIN
    CREATE FULLTEXT INDEX ON Metadata.Cities(Name, State)
    KEY INDEX PK_Cities ON MedTravelFTSCatalog
    WITH CHANGE_TRACKING AUTO;
END
GO

-- Create additional performance indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Hospitals_Search' AND object_id = OBJECT_ID('Hospital.Hospitals'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Hospitals_Search]
    ON [Hospital].[Hospitals]([Name] ASC, [IsActive] ASC)
    INCLUDE([Id], [Description], [Address], [AverageRating]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Doctors_Search_Enhanced' AND object_id = OBJECT_ID('Hospital.Doctors'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Doctors_Search_Enhanced]
    ON [Hospital].[Doctors]([FirstName] ASC, [LastName] ASC, [IsActive] ASC, [IsAcceptingPatients] ASC)
    INCLUDE([Id], [Qualification], [AverageRating], [ConsultationFee]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Specialties_Search' AND object_id = OBJECT_ID('Metadata.Specialties'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Specialties_Search]
    ON [Metadata].[Specialties]([Name] ASC)
    INCLUDE([Id], [Description], [Category]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Diseases_Search' AND object_id = OBJECT_ID('Metadata.Diseases'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Diseases_Search]
    ON [Metadata].[Diseases]([Name] ASC)
    INCLUDE([Id], [Description], [Category]);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Cities_Search' AND object_id = OBJECT_ID('Metadata.Cities'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Cities_Search]
    ON [Metadata].[Cities]([Name] ASC, [IsActive] ASC)
    INCLUDE([Id], [State]);
END
GO

PRINT 'Search stored procedures and indexes created successfully!';
PRINT '';
PRINT 'Usage:';
PRINT 'EXEC Hospital.GetSearchSuggestions @SearchTerm = ''apollo'', @MaxResults = 10;';
PRINT 'EXEC Hospital.GetSearchSuggestions @SearchTerm = ''suresh'', @MaxResults = 10;';
PRINT 'EXEC Hospital.GetSearchSuggestions @SearchTerm = ''hyderabad'', @MaxResults = 10;';
PRINT 'EXEC Hospital.GetSearchSuggestions @SearchTerm = ''cardio'', @MaxResults = 10;';
GO
