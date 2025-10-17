-- =============================================
-- Insert 500 Messages in existing Threads
-- =============================================

PRINT 'Inserting 500 Messages...';

-- Get sample data
DECLARE @ThreadIds TABLE (Id UNIQUEIDENTIFIER, ParticipantIds NVARCHAR(MAX), CreatedAt DATETIME2(7));
INSERT INTO @ThreadIds 
SELECT TOP 100 Id, ParticipantIds, CreatedAt FROM Messaging.Threads ORDER BY CreatedAt;

DECLARE @Counter INT = 1;
DECLARE @MessageId UNIQUEIDENTIFIER;
DECLARE @ThreadId UNIQUEIDENTIFIER;
DECLARE @SenderId UNIQUEIDENTIFIER;
DECLARE @SenderRole NVARCHAR(20);
DECLARE @Content NVARCHAR(2000);
DECLARE @IsRead BIT;
DECLARE @CreatedAt DATETIME2(7);

-- Message content templates
DECLARE @PatientMessages TABLE (Content NVARCHAR(2000));
INSERT INTO @PatientMessages VALUES 
('Hello Doctor, I have some questions about the medication you prescribed.'),
('I am experiencing some side effects from the treatment. Can you please advise?'),
('Thank you for the consultation. When should I schedule my next appointment?'),
('I have been following the treatment plan. Should I continue with the same dosage?'),
('I am feeling better after the treatment. Is there anything I should be careful about?'),
('I need to reschedule my appointment. What are the available time slots?'),
('I have some concerns about my test results. Can you please explain them?'),
('I am planning to travel. Are there any precautions I should take?'),
('I have been taking the medication as prescribed. When can I expect to see improvement?'),
('I have a family history of this condition. Should I be concerned?'),
('I am experiencing some discomfort. Should I be worried?'),
('I have been following the diet plan you suggested. Is it working correctly?'),
('I need a prescription refill. How can I get it?'),
('I have some questions about the treatment options. Can we discuss them?'),
('I am feeling anxious about the procedure. Can you please reassure me?'),
('I have been doing the exercises you recommended. Am I doing them correctly?'),
('I need to know more about the side effects of the medication.'),
('I am planning to start a new job. Will it affect my treatment?'),
('I have been experiencing some symptoms. Should I come in for a check-up?'),
('I want to get a second opinion. Can you recommend someone?');

DECLARE @DoctorMessages TABLE (Content NVARCHAR(2000));
INSERT INTO @DoctorMessages VALUES 
('Hello! I am here to help with your medical concerns. Please feel free to ask any questions.'),
('Based on your symptoms, I recommend continuing with the current treatment plan.'),
('The side effects you are experiencing are normal. They should subside in a few days.'),
('I have reviewed your test results. Everything looks good. Keep following the treatment.'),
('I recommend scheduling a follow-up appointment in 2 weeks to monitor your progress.'),
('Please continue taking the medication as prescribed. Do not skip any doses.'),
('The improvement you are seeing is expected. Continue with the current treatment.'),
('For your travel, please carry your medications and avoid any dietary restrictions.'),
('Your progress is good. I am pleased with how you are responding to treatment.'),
('Based on your family history, we should monitor you more closely. Regular check-ups are important.'),
('The discomfort you are experiencing is temporary. It should improve with continued treatment.'),
('The diet plan is working well. Keep following it and you will see better results.'),
('I will send you a prescription refill. You should receive it within 24 hours.'),
('Let us discuss the treatment options in detail during your next appointment.'),
('The procedure is routine and safe. There is nothing to worry about.'),
('You are doing the exercises correctly. Keep up the good work!'),
('The side effects are minimal and temporary. They will not affect your daily activities.'),
('Your new job should not affect your treatment. Just maintain your medication schedule.'),
('Yes, please come in for a check-up. I want to examine you personally.'),
('I can recommend a specialist for a second opinion. Let me know if you need the contact details.');

-- Insert messages dynamically
WHILE @Counter <= 500
BEGIN
    -- Select random thread
    SELECT TOP 1 @ThreadId = Id, @CreatedAt = CreatedAt FROM @ThreadIds ORDER BY NEWID();
    
    -- Parse participant IDs to get user and doctor IDs
    DECLARE @ParticipantIds NVARCHAR(MAX);
    SELECT @ParticipantIds = ParticipantIds FROM @ThreadIds WHERE Id = @ThreadId;
    
    -- Extract user and doctor IDs from JSON (simplified approach)
    DECLARE @UserId UNIQUEIDENTIFIER, @DoctorId UNIQUEIDENTIFIER;
    DECLARE @JsonStart INT, @JsonEnd INT;
    
    -- Find first GUID
    SET @JsonStart = CHARINDEX('"', @ParticipantIds) + 1;
    SET @JsonEnd = CHARINDEX('"', @ParticipantIds, @JsonStart);
    SET @UserId = CAST(SUBSTRING(@ParticipantIds, @JsonStart, @JsonEnd - @JsonStart) AS UNIQUEIDENTIFIER);
    
    -- Find second GUID
    SET @JsonStart = CHARINDEX('"', @ParticipantIds, @JsonEnd + 1) + 1;
    SET @JsonEnd = CHARINDEX('"', @ParticipantIds, @JsonStart);
    SET @DoctorId = CAST(SUBSTRING(@ParticipantIds, @JsonStart, @JsonEnd - @JsonStart) AS UNIQUEIDENTIFIER);
    
    -- Alternate between patient and doctor messages (60% patient, 40% doctor)
    DECLARE @MessageType INT = ABS(CHECKSUM(NEWID())) % 100;
    
    IF @MessageType < 60 -- Patient message
    BEGIN
        SET @SenderId = @UserId;
        SET @SenderRole = 'patient';
        SELECT TOP 1 @Content = Content FROM @PatientMessages ORDER BY NEWID();
    END
    ELSE -- Doctor message
    BEGIN
        SET @SenderId = @DoctorId;
        SET @SenderRole = 'doctor';
        SELECT TOP 1 @Content = Content FROM @DoctorMessages ORDER BY NEWID();
    END
    
    -- Set read status (80% read)
    SET @IsRead = CASE WHEN ABS(CHECKSUM(NEWID())) % 10 < 8 THEN 1 ELSE 0 END;
    
    -- Set creation date (after thread creation, within last 3 months)
    SET @CreatedAt = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 90, @CreatedAt);
    
    SET @MessageId = NEWID();
    
    INSERT INTO Messaging.Messages 
    (Id, ThreadId, SenderId, SenderRole, Content, IsRead, CreatedAt)
    VALUES 
    (@MessageId, @ThreadId, @SenderId, @SenderRole, @Content, @IsRead, @CreatedAt);
    
    SET @Counter = @Counter + 1;
END

PRINT 'Successfully inserted 500 messages!';
GO
