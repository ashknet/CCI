
-- =============================================
-- STORED PROCEDURES - USER MANAGEMENT
-- =============================================

-- SP: Get User with Roles
CREATE   PROCEDURE [UserManagement].[sp_GetUserWithRoles]
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.*,
        STRING_AGG(r.Name, ',') AS Roles
    FROM UserManagement.Users u
    LEFT JOIN UserManagement.UserRoles ur ON u.Id = ur.UserId
    LEFT JOIN UserManagement.Roles r ON ur.RoleId = r.Id
    WHERE u.Id = @UserId
    GROUP BY u.Id, u.Email, u.PasswordHash, u.FirstName, u.LastName, u.Phone, 
             u.DateOfBirth, u.Gender, u.Nationality, u.CountryId, u.CityId, 
             u.Address, u.PostalCode, u.PassportNumber, u.EmailVerified, 
             u.PhoneVerified, u.TwoFactorEnabled, u.IsActive, u.CreatedAt, 
             u.UpdatedAt, u.LastLoginAt;
END
