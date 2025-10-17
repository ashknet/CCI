CREATE TABLE [Messaging].[MessageAttachments] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [MessageId]   UNIQUEIDENTIFIER NOT NULL,
    [FileName]    NVARCHAR (255)   NOT NULL,
    [FileUrl]     NVARCHAR (1000)  NOT NULL,
    [FileSize]    BIGINT           NULL,
    [MimeType]    NVARCHAR (100)   NULL,
    [IsEncrypted] BIT              DEFAULT ((1)) NULL,
    [UploadedAt]  DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Messaging_MessageAttachments_Message] FOREIGN KEY ([MessageId]) REFERENCES [Messaging].[Messages] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_MessageAttachments_MessageId]
    ON [Messaging].[MessageAttachments]([MessageId] ASC);

