
-- =============================================
-- STORED PROCEDURES - HOSPITAL
-- =============================================

-- SP: Search Hospitals
CREATE   PROCEDURE [Hospital].[sp_SearchHospitals]
    @SearchTerm NVARCHAR(255) = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @SpecialtyId UNIQUEIDENTIFIER = NULL,
    @MinRating DECIMAL(3,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        h.*,
        c.Name AS CityName,
        co.Name AS CountryName,
        COUNT(*) OVER() AS TotalCount
    FROM Hospital.Hospitals h
    INNER JOIN Metadata.Cities c ON h.CityId = c.Id
    INNER JOIN Metadata.Countries co ON h.CountryId = co.Id
    WHERE 
        (@SearchTerm IS NULL OR 
         h.Name LIKE '%' + @SearchTerm + '%' OR 
         h.Description LIKE '%' + @SearchTerm + '%')
        AND (@CityId IS NULL OR h.CityId = @CityId)
        AND (@MinRating IS NULL OR h.AverageRating >= @MinRating)
        AND h.IsActive = 1
    ORDER BY h.AverageRating DESC, h.TotalReviews DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
