CREATE TABLE [UserManagement].[InsurancePolicies] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]         UNIQUEIDENTIFIER NOT NULL,
    [ProviderName]   NVARCHAR (200)   NOT NULL,
    [PolicyNumber]   NVARCHAR (100)   NOT NULL,
    [CoverageType]   NVARCHAR (100)   NULL,
    [CoverageAmount] DECIMAL (18, 2)  NULL,
    [ValidFrom]      DATE             NOT NULL,
    [ValidTo]        DATE             NOT NULL,
    [DocumentUrl]    NVARCHAR (1000)  NULL,
    [IsActive]       BIT              DEFAULT ((1)) NULL,
    [CreatedAt]      DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]      DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_InsurancePolicies_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_InsurancePolicies_UserId]
    ON [UserManagement].[InsurancePolicies]([UserId] ASC);

