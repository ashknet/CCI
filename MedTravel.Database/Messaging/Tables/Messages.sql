CREATE TABLE [Messaging].[Messages] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ThreadId]    UNIQUEIDENTIFIER NOT NULL,
    [SenderId]    UNIQUEIDENTIFIER NOT NULL,
    [Content]     NVARCHAR (MAX)   NOT NULL,
    [MessageType] NVARCHAR (20)    DEFAULT ('text') NULL,
    [IsEncrypted] BIT              DEFAULT ((1)) NULL,
    [IsDelivered] BIT              DEFAULT ((0)) NULL,
    [IsRead]      BIT              DEFAULT ((0)) NULL,
    [DeliveredAt] DATETIME2 (7)    NULL,
    [ReadAt]      DATETIME2 (7)    NULL,
    [ReadBy]      NVARCHAR (MAX)   NULL,
    [CreatedAt]   DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Messaging_Messages_Thread] FOREIGN KEY ([ThreadId]) REFERENCES [Messaging].[Threads] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_ThreadId]
    ON [Messaging].[Messages]([ThreadId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_SenderId]
    ON [Messaging].[Messages]([SenderId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_Messages_CreatedAt]
    ON [Messaging].[Messages]([CreatedAt] DESC);

