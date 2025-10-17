
-- SP: Search Users
CREATE   PROCEDURE [UserManagement].[sp_SearchUsers]
    @SearchTerm NVARCHAR(255) = NULL,
    @CountryId UNIQUEIDENTIFIER = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        u.*,
        c.Name AS CountryName,
        ci.Name AS CityName,
        COUNT(*) OVER() AS TotalCount
    FROM UserManagement.Users u
    LEFT JOIN Metadata.Countries c ON u.CountryId = c.Id
    LEFT JOIN Metadata.Cities ci ON u.CityId = ci.Id
    WHERE 
        (@SearchTerm IS NULL OR 
         u.FirstName LIKE '%' + @SearchTerm + '%' OR 
         u.LastName LIKE '%' + @SearchTerm + '%' OR
         u.Email LIKE '%' + @SearchTerm + '%')
        AND (@CountryId IS NULL OR u.CountryId = @CountryId)
        AND (@CityId IS NULL OR u.CityId = @CityId)
        AND u.IsActive = 1
    ORDER BY u.CreatedAt DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
