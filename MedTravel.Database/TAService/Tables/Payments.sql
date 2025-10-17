CREATE TABLE [TAService].[Payments] (
    [Id]              UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UserId]          UNIQUEIDENTIFIER NOT NULL,
    [Amount]          DECIMAL (18, 2)  NOT NULL,
    [CurrencyId]      UNIQUEIDENTIFIER NOT NULL,
    [PaymentMethod]   NVARCHAR (50)    NULL,
    [PaymentGateway]  NVARCHAR (50)    NULL,
    [Status]          NVARCHAR (20)    DEFAULT ('pending') NULL,
    [TransactionId]   NVARCHAR (100)   NULL,
    [PaymentIntentId] NVARCHAR (100)   NULL,
    [Description]     NVARCHAR (500)   NULL,
    [Metadata]        NVARCHAR (MAX)   NULL,
    [ErrorMessage]    NVARCHAR (500)   NULL,
    [CreatedAt]       DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    [UpdatedAt]       DATETIME2 (7)    NULL,
    [CapturedAt]      DATETIME2 (7)    NULL,
    [RefundedAt]      DATETIME2 (7)    NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TAService_Payments_Currency] FOREIGN KEY ([CurrencyId]) REFERENCES [Metadata].[Currencies] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Payments_UserId]
    ON [TAService].[Payments]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TAService_Payments_Status]
    ON [TAService].[Payments]([Status] ASC);

