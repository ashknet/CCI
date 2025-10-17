
-- SP: Search Doctors
CREATE   PROCEDURE [Hospital].[sp_SearchDoctors]
    @SearchTerm NVARCHAR(255) = NULL,
    @SpecialtyId UNIQUEIDENTIFIER = NULL,
    @CityId UNIQUEIDENTIFIER = NULL,
    @MinRating DECIMAL(3,2) = NULL,
    @MaxFee DECIMAL(18,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT DISTINCT
        d.*,
        h.Name AS HospitalName,
        c.Name AS CityName,
        COUNT(*) OVER() AS TotalCount
    FROM Hospital.Doctors d
    INNER JOIN Hospital.Hospitals h ON d.HospitalId = h.Id
    INNER JOIN Metadata.Cities c ON h.CityId = c.Id
    LEFT JOIN Hospital.DoctorSpecialties ds ON d.Id = ds.DoctorId
    WHERE 
        (@SearchTerm IS NULL OR 
         d.FirstName LIKE '%' + @SearchTerm + '%' OR 
         d.LastName LIKE '%' + @SearchTerm + '%' OR
         d.Qualification LIKE '%' + @SearchTerm + '%')
        AND (@SpecialtyId IS NULL OR ds.SpecialtyId = @SpecialtyId)
        AND (@CityId IS NULL OR h.CityId = @CityId)
        AND (@MinRating IS NULL OR d.AverageRating >= @MinRating)
        AND (@MaxFee IS NULL OR d.ConsultationFee <= @MaxFee)
        AND d.IsActive = 1
        AND d.IsAcceptingPatients = 1
    ORDER BY d.AverageRating DESC, d.YearsOfExperience DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
