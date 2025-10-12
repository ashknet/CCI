-- IdentityService SQL schema
CREATE SCHEMA identity AUTHORIZATION dbo;

CREATE TABLE identity.Users (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NOT NULL,
    FullName NVARCHAR(256) NOT NULL,
    Phone NVARCHAR(32) NULL,
    Country NVARCHAR(128) NULL,
    City NVARCHAR(128) NULL,
    Role NVARCHAR(32) NOT NULL DEFAULT 'Patient',
    CreatedAtUtc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAtUtc DATETIME2 NULL
);

CREATE TABLE identity.RefreshTokens (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    UserId BIGINT NOT NULL REFERENCES identity.Users(Id),
    Token NVARCHAR(512) NOT NULL,
    ExpiresAtUtc DATETIME2 NOT NULL,
    RevokedAtUtc DATETIME2 NULL,
    CreatedAtUtc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

GO

CREATE OR ALTER PROCEDURE identity.sp_CreateUser
    @Email NVARCHAR(256),
    @PasswordHash NVARCHAR(256),
    @FullName NVARCHAR(256),
    @Phone NVARCHAR(32) = NULL,
    @Country NVARCHAR(128) = NULL,
    @City NVARCHAR(128) = NULL,
    @Role NVARCHAR(32) = 'Patient'
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO identity.Users(Email, PasswordHash, FullName, Phone, Country, City, Role)
    VALUES(@Email, @PasswordHash, @FullName, @Phone, @Country, @City, @Role);
    SELECT SCOPE_IDENTITY() AS NewId;
END
GO

CREATE OR ALTER PROCEDURE identity.sp_GetUserByEmail
    @Email NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 * FROM identity.Users WHERE Email=@Email;
END
GO

-- seed
INSERT INTO identity.Users(Email, PasswordHash, FullName, Phone, Country, City, Role)
VALUES
('patient@example.com', 'HASHED', 'John Patient', '+971500000000', 'UAE', 'Dubai', 'Patient'),
('doctor@example.com', 'HASHED', 'Dr. Priya', '+919900000000', 'India', 'Hyderabad', 'Doctor'),
('admin@example.com', 'HASHED', 'Site Admin', NULL, 'India', 'Bangalore', 'Admin');
