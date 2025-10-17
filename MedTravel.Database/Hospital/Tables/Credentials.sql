CREATE TABLE [Hospital].[Credentials] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DoctorId]            UNIQUEIDENTIFIER NOT NULL,
    [Type]                NVARCHAR (50)    NOT NULL,
    [Name]                NVARCHAR (200)   NOT NULL,
    [IssuingOrganization] NVARCHAR (200)   NULL,
    [IssueDate]           DATE             NULL,
    [ExpiryDate]          DATE             NULL,
    [CredentialNumber]    NVARCHAR (100)   NULL,
    [DocumentUrl]         NVARCHAR (500)   NULL,
    [IsVerified]          BIT              DEFAULT ((0)) NULL,
    [CreatedAt]           DATETIME2 (7)    DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_Credentials_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [Hospital].[Doctors] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_Credentials_DoctorId]
    ON [Hospital].[Credentials]([DoctorId] ASC);

