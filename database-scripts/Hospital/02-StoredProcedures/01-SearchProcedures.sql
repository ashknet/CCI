-- =============================================
-- Hospital Service - Search Stored Procedures
-- =============================================

USE HospitalDb;
GO

-- =============================================
-- SP: Search Hospitals
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_SearchHospitals]
    @SearchTerm NVARCHAR(255) = NULL,
    @City NVARCHAR(100) = NULL,
    @Specialty NVARCHAR(100) = NULL,
    @MinRating DECIMAL(3,2) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        h.*,
        COUNT(*) OVER() AS TotalCount
    FROM Hospitals h
    WHERE 
        (@SearchTerm IS NULL OR 
         h.Name LIKE '%' + @SearchTerm + '%' OR 
         h.Description LIKE '%' + @SearchTerm + '%')
        AND (@City IS NULL OR h.City = @City)
        AND (@MinRating IS NULL OR h.AverageRating >= @MinRating)
        AND h.IsActive = 1
    ORDER BY h.AverageRating DESC, h.TotalReviews DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- =============================================
-- SP: Search Doctors
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_SearchDoctors]
    @SearchTerm NVARCHAR(255) = NULL,
    @SpecialtyName NVARCHAR(100) = NULL,
    @City NVARCHAR(100) = NULL,
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
        h.City AS HospitalCity,
        COUNT(*) OVER() AS TotalCount
    FROM Doctors d
    INNER JOIN Hospitals h ON d.HospitalId = h.Id
    LEFT JOIN DoctorSpecialties ds ON d.Id = ds.DoctorId
    LEFT JOIN Specialties s ON ds.SpecialtyId = s.Id
    WHERE 
        (@SearchTerm IS NULL OR 
         d.FirstName LIKE '%' + @SearchTerm + '%' OR 
         d.LastName LIKE '%' + @SearchTerm + '%' OR
         d.Qualification LIKE '%' + @SearchTerm + '%')
        AND (@SpecialtyName IS NULL OR s.Name = @SpecialtyName)
        AND (@City IS NULL OR h.City = @City)
        AND (@MinRating IS NULL OR d.AverageRating >= @MinRating)
        AND (@MaxFee IS NULL OR d.ConsultationFee <= @MaxFee)
        AND d.IsActive = 1
        AND d.IsAcceptingPatients = 1
    ORDER BY d.AverageRating DESC, d.YearsOfExperience DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- =============================================
-- SP: Get Search Suggestions
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetSearchSuggestions]
    @Term NVARCHAR(100),
    @Limit INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Hospitals
    SELECT TOP (@Limit)
        Id,
        Name AS DisplayText,
        'hospital' AS Category,
        City AS Metadata
    FROM Hospitals
    WHERE Name LIKE @Term + '%' AND IsActive = 1
    
    UNION ALL
    
    -- Doctors
    SELECT TOP (@Limit)
        Id,
        CONCAT(FirstName, ' ', LastName) AS DisplayText,
        'doctor' AS Category,
        Qualification AS Metadata
    FROM Doctors
    WHERE (FirstName LIKE @Term + '%' OR LastName LIKE @Term + '%') 
      AND IsActive = 1
    
    UNION ALL
    
    -- Specialties
    SELECT TOP (@Limit)
        Id,
        Name AS DisplayText,
        'specialty' AS Category,
        Description AS Metadata
    FROM Specialties
    WHERE Name LIKE @Term + '%'
    
    ORDER BY Category, DisplayText;
END
GO

-- =============================================
-- SP: Get Doctor Availability
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetDoctorAvailability]
    @DoctorId UNIQUEIDENTIFIER,
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get doctor's weekly schedule
    SELECT 
        da.DayOfWeek,
        da.StartTime,
        da.EndTime,
        da.SlotDurationMinutes
    FROM DoctorAvailability da
    WHERE da.DoctorId = @DoctorId
      AND da.IsActive = 1;
    
    -- Get booked appointments in date range
    SELECT 
        ScheduledDate,
        ScheduledTime,
        DurationMinutes
    FROM Appointments
    WHERE DoctorId = @DoctorId
      AND ScheduledDate BETWEEN @FromDate AND @ToDate
      AND Status IN ('scheduled', 'confirmed')
    ORDER BY ScheduledDate, ScheduledTime;
    
    -- Get doctor leaves
    SELECT 
        LeaveDate
    FROM DoctorLeaves
    WHERE DoctorId = @DoctorId
      AND LeaveDate BETWEEN @FromDate AND @ToDate;
END
GO

-- =============================================
-- SP: Book Appointment
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_BookAppointment]
    @DoctorId UNIQUEIDENTIFIER,
    @PatientId UNIQUEIDENTIFIER,
    @ScheduledDate DATE,
    @ScheduledTime TIME,
    @ReasonForVisit NVARCHAR(500),
    @AppointmentId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Check if slot is available
        IF EXISTS (
            SELECT 1 FROM Appointments
            WHERE DoctorId = @DoctorId
              AND ScheduledDate = @ScheduledDate
              AND ScheduledTime = @ScheduledTime
              AND Status IN ('scheduled', 'confirmed')
        )
        BEGIN
            RAISERROR('Time slot not available', 16, 1);
            RETURN;
        END
        
        -- Get consultation fee
        DECLARE @Fee DECIMAL(18,2);
        SELECT @Fee = ConsultationFee FROM Doctors WHERE Id = @DoctorId;
        
        -- Create appointment
        SET @AppointmentId = NEWID();
        INSERT INTO Appointments (Id, DoctorId, PatientId, ScheduledDate, ScheduledTime, ReasonForVisit, Fee, Status)
        VALUES (@AppointmentId, @DoctorId, @PatientId, @ScheduledDate, @ScheduledTime, @ReasonForVisit, @Fee, 'scheduled');
        
        -- Create reminder (24 hours before)
        INSERT INTO AppointmentReminders (AppointmentId, ReminderType, ScheduledFor, Status)
        VALUES 
            (@AppointmentId, 'email', DATEADD(HOUR, -24, CAST(CONCAT(@ScheduledDate, ' ', @ScheduledTime) AS DATETIME2)), 'pending'),
            (@AppointmentId, 'sms', DATEADD(HOUR, -2, CAST(CONCAT(@ScheduledDate, ' ', @ScheduledTime) AS DATETIME2)), 'pending');
        
        COMMIT TRANSACTION;
        
        SELECT @AppointmentId AS AppointmentId, @Fee AS Fee;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- SP: Cancel Appointment
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CancelAppointment]
    @AppointmentId UNIQUEIDENTIFIER,
    @CancellationReason NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Appointments
    SET Status = 'cancelled',
        CancellationReason = @CancellationReason,
        CancelledAt = GETUTCDATE(),
        UpdatedAt = GETUTCDATE()
    WHERE Id = @AppointmentId;
    
    -- Cancel reminders
    DELETE FROM AppointmentReminders
    WHERE AppointmentId = @AppointmentId AND Status = 'pending';
    
    SELECT @@ROWCOUNT AS UpdatedCount;
END
GO

-- =============================================
-- SP: Update Hospital Rating
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_UpdateHospitalRating]
    @HospitalId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Hospitals
    SET AverageRating = (
            SELECT AVG(CAST(Rating AS DECIMAL(3,2)))
            FROM Reviews
            WHERE HospitalId = @HospitalId AND IsApproved = 1
        ),
        TotalReviews = (
            SELECT COUNT(*)
            FROM Reviews
            WHERE HospitalId = @HospitalId AND IsApproved = 1
        ),
        UpdatedAt = GETUTCDATE()
    WHERE Id = @HospitalId;
END
GO

-- =============================================
-- SP: Update Doctor Rating
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_UpdateDoctorRating]
    @DoctorId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Doctors
    SET AverageRating = (
            SELECT AVG(CAST(Rating AS DECIMAL(3,2)))
            FROM Reviews
            WHERE DoctorId = @DoctorId AND IsApproved = 1
        ),
        TotalReviews = (
            SELECT COUNT(*)
            FROM Reviews
            WHERE DoctorId = @DoctorId AND IsApproved = 1
        ),
        UpdatedAt = GETUTCDATE()
    WHERE Id = @DoctorId;
END
GO

-- =============================================
-- SP: Get Nearby Hospitals
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetNearbyHospitals]
    @Latitude DECIMAL(10,7),
    @Longitude DECIMAL(10,7),
    @RadiusKm INT = 10,
    @Limit INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Haversine formula for distance calculation
    SELECT TOP (@Limit)
        *,
        (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(Latitude)) *
            COS(RADIANS(Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(Latitude))
        )) AS DistanceKm
    FROM Hospitals
    WHERE IsActive = 1
        AND Latitude IS NOT NULL
        AND Longitude IS NOT NULL
    HAVING (6371 * ACOS(
            COS(RADIANS(@Latitude)) * COS(RADIANS(Latitude)) *
            COS(RADIANS(Longitude) - RADIANS(@Longitude)) +
            SIN(RADIANS(@Latitude)) * SIN(RADIANS(Latitude))
        )) <= @RadiusKm
    ORDER BY DistanceKm;
END
GO

PRINT 'Hospital Service stored procedures created successfully';
GO
