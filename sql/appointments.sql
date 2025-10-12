-- Appointment Service SQL schema
CREATE SCHEMA appt AUTHORIZATION dbo;

CREATE TABLE appt.DoctorCalendars (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    DoctorId BIGINT NOT NULL,
    TimeZone NVARCHAR(64) NOT NULL DEFAULT 'Asia/Kolkata'
);

CREATE TABLE appt.AvailabilitySlots (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    DoctorId BIGINT NOT NULL,
    StartAtUtc DATETIME2 NOT NULL,
    EndAtUtc DATETIME2 NOT NULL,
    IsBooked BIT NOT NULL DEFAULT 0
);

CREATE TABLE appt.Appointments (
    Id BIGINT IDENTITY(1,1) PRIMARY KEY,
    DoctorId BIGINT NOT NULL,
    UserId BIGINT NOT NULL,
    StartAtUtc DATETIME2 NOT NULL,
    EndAtUtc DATETIME2 NOT NULL,
    Status NVARCHAR(32) NOT NULL DEFAULT 'Pending',
    Notes NVARCHAR(1024) NULL,
    CreatedAtUtc DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

GO

CREATE OR ALTER PROCEDURE appt.sp_GetAvailability
    @DoctorId BIGINT,
    @From DATETIME2,
    @To DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM appt.AvailabilitySlots
    WHERE DoctorId=@DoctorId AND StartAtUtc >= @From AND EndAtUtc <= @To AND IsBooked=0
    ORDER BY StartAtUtc;
END
GO

CREATE OR ALTER PROCEDURE appt.sp_BookAppointment
    @DoctorId BIGINT,
    @UserId BIGINT,
    @StartAtUtc DATETIME2,
    @EndAtUtc DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRAN;
      IF NOT EXISTS(SELECT 1 FROM appt.AvailabilitySlots WHERE DoctorId=@DoctorId AND StartAtUtc=@StartAtUtc AND EndAtUtc=@EndAtUtc AND IsBooked=0)
      BEGIN
        RAISERROR('Slot not available', 16, 1);
        ROLLBACK TRAN;
        RETURN;
      END
      UPDATE appt.AvailabilitySlots SET IsBooked=1 WHERE DoctorId=@DoctorId AND StartAtUtc=@StartAtUtc AND EndAtUtc=@EndAtUtc;
      INSERT INTO appt.Appointments(DoctorId, UserId, StartAtUtc, EndAtUtc, Status) VALUES(@DoctorId, @UserId, @StartAtUtc, @EndAtUtc, 'Confirmed');
    COMMIT TRAN;
END
GO

-- seed availability (UTC for example)
DECLARE @now DATETIME2 = DATEADD(DAY, 1, SYSUTCDATETIME());
INSERT INTO appt.AvailabilitySlots(DoctorId, StartAtUtc, EndAtUtc)
VALUES
(1, DATEADD(HOUR, 9, CAST(CAST(@now AS DATE) AS DATETIME2)), DATEADD(HOUR, 10, CAST(CAST(@now AS DATE) AS DATETIME2))),
(1, DATEADD(HOUR, 10, CAST(CAST(@now AS DATE) AS DATETIME2)), DATEADD(HOUR, 11, CAST(CAST(@now AS DATE) AS DATETIME2))),
(2, DATEADD(HOUR, 9, CAST(CAST(@now AS DATE) AS DATETIME2)), DATEADD(HOUR, 10, CAST(CAST(@now AS DATE) AS DATETIME2)));
