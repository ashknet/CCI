CREATE TABLE [UserManagement].[AuditLogs] (
    [Id]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]     UNIQUEIDENTIFIER NULL,
    [Action]     NVARCHAR (100)   NOT NULL,
    [EntityType] NVARCHAR (100)   NULL,
    [EntityId]   NVARCHAR (100)   NULL,
    [OldValues]  NVARCHAR (MAX)   NULL,
    [NewValues]  NVARCHAR (MAX)   NULL,
    [IpAddress]  NVARCHAR (50)    NULL,
    [UserAgent]  NVARCHAR (500)   NULL,
    [Timestamp]  DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_AuditLogs_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE SET NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_AuditLogs_Timestamp]
    ON [UserManagement].[AuditLogs]([Timestamp] DESC);

