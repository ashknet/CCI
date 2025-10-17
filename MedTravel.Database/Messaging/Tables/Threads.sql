CREATE TABLE [Messaging].[Threads] (
    [Id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Subject]        NVARCHAR (500)   NULL,
    [ParticipantIds] NVARCHAR (MAX)   NOT NULL,
    [ThreadType]     NVARCHAR (50)    DEFAULT ('patient_doctor') NULL,
    [IsActive]       BIT              DEFAULT ((1)) NULL,
    [IsArchived]     BIT              DEFAULT ((0)) NULL,
    [LastMessageAt]  DATETIME2 (7)    NULL,
    [CreatedAt]      DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy]      UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_Threads_CreatedAt]
    ON [Messaging].[Threads]([CreatedAt] DESC);


GO
CREATE NONCLUSTERED INDEX [IX_Messaging_Threads_LastMessageAt]
    ON [Messaging].[Threads]([LastMessageAt] DESC);

