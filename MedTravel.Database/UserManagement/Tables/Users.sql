CREATE TABLE [UserManagement].[Users] (
    [Id]               UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Email]            NVARCHAR (255)   NOT NULL,
    [PasswordHash]     NVARCHAR (500)   NOT NULL,
    [FirstName]        NVARCHAR (100)   NOT NULL,
    [LastName]         NVARCHAR (100)   NOT NULL,
    [Phone]            NVARCHAR (20)    NULL,
    [DateOfBirth]      DATE             NULL,
    [Gender]           NVARCHAR (20)    NULL,
    [Nationality]      NVARCHAR (100)   NULL,
    [CountryId]        UNIQUEIDENTIFIER NULL,
    [CityId]           UNIQUEIDENTIFIER NULL,
    [Address]          NVARCHAR (500)   NULL,
    [PostalCode]       NVARCHAR (20)    NULL,
    [PassportNumber]   NVARCHAR (50)    NULL,
    [EmailVerified]    BIT              DEFAULT ((0)) NOT NULL,
    [PhoneVerified]    BIT              DEFAULT ((0)) NOT NULL,
    [TwoFactorEnabled] BIT              DEFAULT ((0)) NOT NULL,
    [IsActive]         BIT              DEFAULT ((1)) NOT NULL,
    [CreatedAt]        DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]        DATETIME2 (7)    NULL,
    [LastLoginAt]      DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_Users_City] FOREIGN KEY ([CityId]) REFERENCES [Metadata].[Cities] ([Id]),
    CONSTRAINT [FK_UserMgmt_Users_Country] FOREIGN KEY ([CountryId]) REFERENCES [Metadata].[Countries] ([Id]),
    UNIQUE NONCLUSTERED ([Email] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UserMgmt_Users_Email]
    ON [UserManagement].[Users]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_Users_CountryCity]
    ON [UserManagement].[Users]([CountryId] ASC, [CityId] ASC);

