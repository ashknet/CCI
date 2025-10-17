CREATE TABLE [UserManagement].[RolePermissions] (
    [Id]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [RoleId]       UNIQUEIDENTIFIER NOT NULL,
    [PermissionId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt]    DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_RolePermissions_Permission] FOREIGN KEY ([PermissionId]) REFERENCES [UserManagement].[Permissions] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserMgmt_RolePermissions_Role] FOREIGN KEY ([RoleId]) REFERENCES [UserManagement].[Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_UserMgmt_RolePermission] UNIQUE NONCLUSTERED ([RoleId] ASC, [PermissionId] ASC)
);

