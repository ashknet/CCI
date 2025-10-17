CREATE TABLE [Hospital].[HospitalAccreditations] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [HospitalId]          UNIQUEIDENTIFIER NOT NULL,
    [AccreditationBodyId] UNIQUEIDENTIFIER NOT NULL,
    [AccreditationType]   NVARCHAR (100)   NOT NULL,
    [CertificateNumber]   NVARCHAR (100)   NULL,
    [IssuedDate]          DATE             NULL,
    [ExpiryDate]          DATE             NULL,
    [Status]              NVARCHAR (20)    DEFAULT ('active') NULL,
    [DocumentUrl]         NVARCHAR (500)   NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Hospital_HospitalAccreditations_Body] FOREIGN KEY ([AccreditationBodyId]) REFERENCES [Metadata].[AccreditationBodies] ([Id]),
    CONSTRAINT [FK_Hospital_HospitalAccreditations_Hospital] FOREIGN KEY ([HospitalId]) REFERENCES [Hospital].[Hospitals] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_Hospital_HospitalAccreditations_HospitalId]
    ON [Hospital].[HospitalAccreditations]([HospitalId] ASC);

