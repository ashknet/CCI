
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