CREATE TABLE [UserManagement].[Notifications] (
    [Id]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]    UNIQUEIDENTIFIER NOT NULL,
    [Type]      NVARCHAR (50)    NOT NULL,
    [Title]     NVARCHAR (200)   NOT NULL,
    [Message]   NVARCHAR (2000)  NOT NULL,
    [Channel]   NVARCHAR (20)    NOT NULL,
    [Status]    NVARCHAR (20)    DEFAULT ('pending') NULL,
    [IsRead]    BIT              DEFAULT ((0)) NULL,
    [SentAt]    DATETIME2 (7)    NULL,
    [ReadAt]    DATETIME2 (7)    NULL,
    [CreatedAt] DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_Notifications_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_Notifications_UserId]
    ON [UserManagement].[Notifications]([UserId] ASC);

