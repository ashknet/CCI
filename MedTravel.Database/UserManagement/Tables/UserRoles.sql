CREATE TABLE [UserManagement].[UserRoles] (
    [Id]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]     UNIQUEIDENTIFIER NOT NULL,
    [RoleId]     UNIQUEIDENTIFIER NOT NULL,
    [AssignedAt] DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [AssignedBy] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_UserRoles_Role] FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserMgmt_UserRoles_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_UserMgmt_UserRole] UNIQUE NONCLUSTERED ([UserId] ASC, [RoleId] ASC)
);

