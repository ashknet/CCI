CREATE TABLE [UserManagement].[Permissions] (
    [Id]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]        NVARCHAR (100)   NOT NULL,
    [Resource]    NVARCHAR (50)    NOT NULL,
    [Action]      NVARCHAR (50)    NOT NULL,
    [Description] NVARCHAR (500)   NULL,
    [CreatedAt]   DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_UserMgmt_Permission_Resource_Action] UNIQUE NONCLUSTERED ([Resource] ASC, [Action] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_UserMgmt_Permissions_Resource]
    ON [UserManagement].[Permissions]([Resource] ASC);

