CREATE TABLE [UserManagement].[Sessions] (
    [Id]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]       UNIQUEIDENTIFIER NOT NULL,
    [RefreshToken] NVARCHAR (500)   NOT NULL,
    [DeviceInfo]   NVARCHAR (500)   NULL,
    [IpAddress]    NVARCHAR (50)    NULL,
    [IsActive]     BIT              DEFAULT ((1)) NOT NULL,
    [ExpiresAt]    DATETIME2 (7)    NOT NULL,
    [CreatedAt]    DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [RevokedAt]    DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_Sessions_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE,
    UNIQUE NONCLUSTERED ([RefreshToken] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_Sessions_UserId]
    ON [UserManagement].[Sessions]([UserId] ASC);

