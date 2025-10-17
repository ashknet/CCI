CREATE TABLE [UserManagement].[UserDocuments] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]         UNIQUEIDENTIFIER NOT NULL,
    [DocumentTypeId] UNIQUEIDENTIFIER NOT NULL,
    [DocumentName]   NVARCHAR (255)   NOT NULL,
    [DocumentUrl]    NVARCHAR (1000)  NOT NULL,
    [FileSize]       BIGINT           NULL,
    [MimeType]       NVARCHAR (100)   NULL,
    [IsVerified]     BIT              DEFAULT ((0)) NULL,
    [VerifiedBy]     UNIQUEIDENTIFIER NULL,
    [VerifiedAt]     DATETIME2 (7)    NULL,
    [UploadedAt]     DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_UserDocuments_Type] FOREIGN KEY ([DocumentTypeId]) REFERENCES [Metadata].[DocumentTypes] ([Id]),
    CONSTRAINT [FK_UserMgmt_UserDocuments_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_UserDocuments_UserId]
    ON [UserManagement].[UserDocuments]([UserId] ASC);

