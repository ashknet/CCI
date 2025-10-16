-- =============================================
-- User Management - Stored Procedures
-- =============================================

USE UserManagementDb;
GO

-- =============================================
-- SP: Get User with Roles
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetUserWithRoles]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.*,
        STRING_AGG(r.Name, ',') AS Roles
    FROM Users u
    LEFT JOIN UserRoles ur ON u.Id = ur.UserId
    LEFT JOIN Roles r ON ur.RoleId = r.Id
    WHERE u.Id = @UserId
    GROUP BY u.Id, u.Email, u.FirstName, u.LastName, u.Phone, u.DateOfBirth, 
             u.Gender, u.Nationality, u.Country, u.City, u.Address, u.PostalCode,
             u.PassportNumber, u.EmailVerified, u.PhoneVerified, u.TwoFactorEnabled,
             u.IsActive, u.CreatedAt, u.UpdatedAt, u.LastLoginAt, u.PasswordHash;
END
GO

-- =============================================
-- SP: Search Users
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_SearchUsers]
    @SearchTerm NVARCHAR(255) = NULL,
    @Country NVARCHAR(100) = NULL,
    @City NVARCHAR(100) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        u.*,
        COUNT(*) OVER() AS TotalCount
    FROM Users u
    WHERE 
        (@SearchTerm IS NULL OR 
         u.FirstName LIKE '%' + @SearchTerm + '%' OR 
         u.LastName LIKE '%' + @SearchTerm + '%' OR
         u.Email LIKE '%' + @SearchTerm + '%')
        AND (@Country IS NULL OR u.Country = @Country)
        AND (@City IS NULL OR u.City = @City)
        AND u.IsActive = 1
    ORDER BY u.CreatedAt DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- =============================================
-- SP: Create User with Role
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CreateUserWithRole]
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(500),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Phone NVARCHAR(20) = NULL,
    @Country NVARCHAR(100) = NULL,
    @City NVARCHAR(100) = NULL,
    @RoleName NVARCHAR(50) = 'patient'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @UserId UNIQUEIDENTIFIER = NEWID();
        DECLARE @RoleId UNIQUEIDENTIFIER;
        
        -- Insert user
        INSERT INTO Users (Id, Email, PasswordHash, FirstName, LastName, Phone, Country, City)
        VALUES (@UserId, @Email, @PasswordHash, @FirstName, @LastName, @Phone, @Country, @City);
        
        -- Get role ID
        SELECT @RoleId = Id FROM Roles WHERE Name = @RoleName;
        
        -- Assign role
        IF @RoleId IS NOT NULL
        BEGIN
            INSERT INTO UserRoles (UserId, RoleId)
            VALUES (@UserId, @RoleId);
        END
        
        COMMIT TRANSACTION;
        
        SELECT @UserId AS UserId;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- SP: Update Last Login
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_UpdateLastLogin]
    @UserId UNIQUEIDENTIFIER,
    @IpAddress NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE Users
    SET LastLoginAt = GETUTCDATE(),
        UpdatedAt = GETUTCDATE()
    WHERE Id = @UserId;
    
    -- Log audit
    INSERT INTO AuditLogs (UserId, Action, EntityType, EntityId, IpAddress)
    VALUES (@UserId, 'Login', 'User', CAST(@UserId AS NVARCHAR(36)), @IpAddress);
END
GO

-- =============================================
-- SP: Get User Notifications
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetUserNotifications]
    @UserId UNIQUEIDENTIFIER,
    @UnreadOnly BIT = 0,
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        n.*,
        COUNT(*) OVER() AS TotalCount
    FROM Notifications n
    WHERE 
        n.UserId = @UserId
        AND (@UnreadOnly = 0 OR n.IsRead = 0)
    ORDER BY n.CreatedAt DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- =============================================
-- SP: Mark Notifications as Read
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_MarkNotificationsAsRead]
    @UserId UNIQUEIDENTIFIER,
    @NotificationIds NVARCHAR(MAX) = NULL -- Comma-separated GUIDs
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @NotificationIds IS NULL
    BEGIN
        -- Mark all as read
        UPDATE Notifications
        SET IsRead = 1,
            ReadAt = GETUTCDATE()
        WHERE UserId = @UserId AND IsRead = 0;
    END
    ELSE
    BEGIN
        -- Mark specific notifications as read
        UPDATE Notifications
        SET IsRead = 1,
            ReadAt = GETUTCDATE()
        WHERE UserId = @UserId 
          AND CAST(Id AS NVARCHAR(36)) IN (SELECT value FROM STRING_SPLIT(@NotificationIds, ','));
    END
    
    SELECT @@ROWCOUNT AS UpdatedCount;
END
GO

-- =============================================
-- SP: Get User Spend Summary
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_GetUserSpendSummary]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    -- This would aggregate from appointments, bookings, etc.
    -- For now, return structure
    SELECT 
        @UserId AS UserId,
        0.00 AS TotalSpent,
        0.00 AS MedicalExpenses,
        0.00 AS TravelExpenses,
        0.00 AS AccommodationExpenses,
        'INR' AS Currency;
END
GO

-- =============================================
-- SP: Cleanup Expired Sessions
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_CleanupExpiredSessions]
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM Sessions
    WHERE ExpiresAt < GETUTCDATE()
       OR (IsActive = 0 AND RevokedAt < DATEADD(DAY, -30, GETUTCDATE()));
    
    SELECT @@ROWCOUNT AS DeletedCount;
END
GO

PRINT 'User Management stored procedures created successfully';
GO
