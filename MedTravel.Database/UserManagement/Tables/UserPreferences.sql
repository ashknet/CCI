CREATE TABLE [UserManagement].[UserPreferences] (
    [Id]                 UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]             UNIQUEIDENTIFIER NOT NULL,
    [LanguageId]         UNIQUEIDENTIFIER NULL,
    [CurrencyId]         UNIQUEIDENTIFIER NULL,
    [EmailNotifications] BIT              DEFAULT ((1)) NULL,
    [SmsNotifications]   BIT              DEFAULT ((1)) NULL,
    [PushNotifications]  BIT              DEFAULT ((1)) NULL,
    [Theme]              NVARCHAR (20)    DEFAULT ('light') NULL,
    [CreatedAt]          DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]          DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_UserMgmt_UserPreferences_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id]),
    CONSTRAINT [FK_UserMgmt_UserPreferences_Language] FOREIGN KEY ([LanguageId]) REFERENCES [Metadata].[Languages] ([Id]),
    CONSTRAINT [FK_UserMgmt_UserPreferences_User] FOREIGN KEY ([UserId]) REFERENCES [UserManagement].[Users] ([Id]) ON DELETE CASCADE,
    UNIQUE NONCLUSTERED ([UserId] ASC)
);

