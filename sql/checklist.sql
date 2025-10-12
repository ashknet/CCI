-- Checklist Service SQL schema
CREATE SCHEMA checklist AUTHORIZATION dbo;

CREATE TABLE checklist.Diseases (
  Id BIGINT IDENTITY(1,1) PRIMARY KEY,
  Name NVARCHAR(256) NOT NULL
);

CREATE TABLE checklist.Items (
  Id BIGINT IDENTITY(1,1) PRIMARY KEY,
  DiseaseId BIGINT NOT NULL REFERENCES checklist.Diseases(Id),
  Text NVARCHAR(512) NOT NULL,
  Phase NVARCHAR(32) NOT NULL -- PreOp, PostOp
);

GO

-- seed checklist
INSERT INTO checklist.Diseases(Name) VALUES ('Knee Replacement'), ('Cardiac Bypass');
DECLARE @knee BIGINT = SCOPE_IDENTITY();
INSERT INTO checklist.Items(DiseaseId, Text, Phase) VALUES
(@knee, 'Stop blood thinners 7 days prior', 'PreOp'),
(@knee, 'Arrange physiotherapy for 2 weeks', 'PostOp');

CREATE OR ALTER PROCEDURE checklist.sp_GetChecklist @DiseaseId BIGINT AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM checklist.Items WHERE DiseaseId=@DiseaseId ORDER BY Phase;
END
GO
