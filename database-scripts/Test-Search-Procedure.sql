-- =============================================
-- Test the Search Stored Procedure
-- =============================================

USE MedTravelDb;
GO

PRINT 'Testing Hospital.GetSearchSuggestions stored procedure...';
PRINT '';

-- Test 1: Search for hospitals
PRINT 'Test 1: Searching for "apollo"...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'apollo', @MaxResults = 10;
PRINT '';

-- Test 2: Search for doctors
PRINT 'Test 2: Searching for "suresh"...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'suresh', @MaxResults = 10;
PRINT '';

-- Test 3: Search for cities
PRINT 'Test 3: Searching for "hyd"...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'hyd', @MaxResults = 10;
PRINT '';

-- Test 4: Search for specialties
PRINT 'Test 4: Searching for "cardio"...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'cardio', @MaxResults = 10;
PRINT '';

-- Test 5: Search for diseases
PRINT 'Test 5: Searching for "diabetes"...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'diabetes', @MaxResults = 10;
PRINT '';

-- Test 6: Search with short term (should return empty)
PRINT 'Test 6: Searching for "a" (should return empty)...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = 'a', @MaxResults = 10;
PRINT '';

-- Test 7: Search with empty term (should return empty)
PRINT 'Test 7: Searching for empty string (should return empty)...';
EXEC Hospital.GetSearchSuggestions @SearchTerm = '', @MaxResults = 10;
PRINT '';

PRINT 'Search procedure testing complete!';
PRINT '';
PRINT 'Note: If you see empty results, make sure to run the test data scripts first:';
PRINT ':r "MedTravel.Database/TestData/00-Execute-All-TestData.sql"';
GO
