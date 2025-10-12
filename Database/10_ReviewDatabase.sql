-- =============================================
-- Medical Travel Booking Platform
-- Review Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelReviewDB')
BEGIN
    CREATE DATABASE MedicalTravelReviewDB;
END
GO

USE MedicalTravelReviewDB;
GO

-- Reviews
CREATE TABLE Reviews (
    ReviewId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    ReviewType NVARCHAR(50) NOT NULL, -- Doctor, Hospital, Accommodation, Transportation
    EntityId UNIQUEIDENTIFIER NOT NULL, -- ID of the entity being reviewed
    AppointmentId UNIQUEIDENTIFIER, -- Optional link to appointment
    BookingId UNIQUEIDENTIFIER, -- Optional link to booking
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Title NVARCHAR(255),
    ReviewText NVARCHAR(MAX),
    Pros NVARCHAR(MAX),
    Cons NVARCHAR(MAX),
    WouldRecommend BIT DEFAULT 1,
    TreatmentReceived NVARCHAR(255), -- For doctor/hospital reviews
    VisitDate DATE,
    IsVerified BIT DEFAULT 0, -- Verified purchase/appointment
    IsAnonymous BIT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Approved, Rejected
    RejectionReason NVARCHAR(500),
    HelpfulCount INT DEFAULT 0,
    NotHelpfulCount INT DEFAULT 0,
    ResponseFromProvider NVARCHAR(MAX), -- Provider can respond
    ResponseDate DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    ApprovedAt DATETIME2,
    INDEX IX_Reviews_UserId (UserId),
    INDEX IX_Reviews_ReviewType (ReviewType),
    INDEX IX_Reviews_EntityId (EntityId),
    INDEX IX_Reviews_Rating (Rating),
    INDEX IX_Reviews_Status (Status),
    INDEX IX_Reviews_CreatedAt (CreatedAt)
);

-- Review Categories/Aspects
CREATE TABLE ReviewCategories (
    CategoryId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CategoryName NVARCHAR(100) NOT NULL,
    ReviewType NVARCHAR(50) NOT NULL, -- Doctor, Hospital, Accommodation, Transportation
    Description NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Detailed Category Ratings
CREATE TABLE ReviewCategoryRatings (
    CategoryRatingId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    CategoryId UNIQUEIDENTIFIER NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ReviewId) REFERENCES Reviews(ReviewId) ON DELETE CASCADE,
    FOREIGN KEY (CategoryId) REFERENCES ReviewCategories(CategoryId),
    INDEX IX_ReviewCategoryRatings_ReviewId (ReviewId),
    INDEX IX_ReviewCategoryRatings_CategoryId (CategoryId)
);

-- Review Images
CREATE TABLE ReviewImages (
    ImageId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    ImageUrl NVARCHAR(500) NOT NULL,
    Caption NVARCHAR(255),
    DisplayOrder INT DEFAULT 0,
    IsApproved BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ReviewId) REFERENCES Reviews(ReviewId) ON DELETE CASCADE,
    INDEX IX_ReviewImages_ReviewId (ReviewId)
);

-- Review Helpfulness Votes
CREATE TABLE ReviewHelpfulness (
    VoteId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    UserId UNIQUEIDENTIFIER NOT NULL,
    IsHelpful BIT NOT NULL, -- 1 = Helpful, 0 = Not Helpful
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (ReviewId) REFERENCES Reviews(ReviewId) ON DELETE CASCADE,
    UNIQUE (ReviewId, UserId),
    INDEX IX_ReviewHelpfulness_ReviewId (ReviewId),
    INDEX IX_ReviewHelpfulness_UserId (UserId)
);

-- Review Reports (for inappropriate content)
CREATE TABLE ReviewReports (
    ReportId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    ReportedBy UNIQUEIDENTIFIER NOT NULL,
    ReportReason NVARCHAR(100) NOT NULL, -- Spam, Offensive, Fake, Inappropriate
    ReportDetails NVARCHAR(MAX),
    Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, UnderReview, Resolved, Dismissed
    ReviewedBy UNIQUEIDENTIFIER,
    Resolution NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    ResolvedAt DATETIME2,
    FOREIGN KEY (ReviewId) REFERENCES Reviews(ReviewId),
    INDEX IX_ReviewReports_ReviewId (ReviewId),
    INDEX IX_ReviewReports_Status (Status)
);

-- Review Statistics (Aggregated per Entity)
CREATE TABLE ReviewStatistics (
    StatisticId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewType NVARCHAR(50) NOT NULL,
    EntityId UNIQUEIDENTIFIER NOT NULL,
    TotalReviews INT DEFAULT 0,
    AverageRating DECIMAL(3,2) DEFAULT 0.0,
    FiveStarCount INT DEFAULT 0,
    FourStarCount INT DEFAULT 0,
    ThreeStarCount INT DEFAULT 0,
    TwoStarCount INT DEFAULT 0,
    OneStarCount INT DEFAULT 0,
    VerifiedReviewCount INT DEFAULT 0,
    RecommendationPercentage DECIMAL(5,2) DEFAULT 0.0,
    LastReviewDate DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UNIQUE (ReviewType, EntityId),
    INDEX IX_ReviewStatistics_EntityId (EntityId),
    INDEX IX_ReviewStatistics_AverageRating (AverageRating)
);

-- Review Moderation Queue
CREATE TABLE ReviewModerationQueue (
    QueueId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ReviewId UNIQUEIDENTIFIER NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'Normal', -- Low, Normal, High
    AssignedTo UNIQUEIDENTIFIER,
    ModerationStatus NVARCHAR(20) DEFAULT 'Pending', -- Pending, InReview, Completed
    ModerationNotes NVARCHAR(MAX),
    AutoFlaggedReason NVARCHAR(255), -- If auto-flagged by system
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    CompletedAt DATETIME2,
    FOREIGN KEY (ReviewId) REFERENCES Reviews(ReviewId),
    INDEX IX_ReviewModerationQueue_ReviewId (ReviewId),
    INDEX IX_ReviewModerationQueue_ModerationStatus (ModerationStatus)
);

-- Insert Review Categories
INSERT INTO ReviewCategories (CategoryName, ReviewType, DisplayOrder) VALUES
-- Doctor Review Categories
('Medical Expertise', 'Doctor', 1),
('Communication', 'Doctor', 2),
('Bedside Manner', 'Doctor', 3),
('Wait Time', 'Doctor', 4),
('Staff Friendliness', 'Doctor', 5),

-- Hospital Review Categories
('Facility Cleanliness', 'Hospital', 1),
('Medical Equipment', 'Hospital', 2),
('Staff Quality', 'Hospital', 3),
('Food Quality', 'Hospital', 4),
('Overall Experience', 'Hospital', 5),

-- Accommodation Review Categories
('Cleanliness', 'Accommodation', 1),
('Location', 'Accommodation', 2),
('Comfort', 'Accommodation', 3),
('Value for Money', 'Accommodation', 4),
('Staff Service', 'Accommodation', 5),

-- Transportation Review Categories
('Punctuality', 'Transportation', 1),
('Comfort', 'Transportation', 2),
('Safety', 'Transportation', 3),
('Value for Money', 'Transportation', 4),
('Customer Service', 'Transportation', 5);

-- Insert Sample Reviews
INSERT INTO Reviews (UserId, ReviewType, EntityId, Rating, Title, ReviewText, WouldRecommend, IsVerified, Status, ApprovedAt) VALUES
('11111111-1111-1111-1111-000000000001', 'Doctor', '22222222-2222-2222-2222-000000000001', 5, 
 'Excellent Doctor', 'Dr. Johnson was very professional and caring. Explained everything clearly and took time to answer all my questions.', 
 1, 1, 'Approved', GETUTCDATE()),
 
('11111111-1111-1111-1111-000000000001', 'Hospital', '33333333-3333-3333-3333-000000000001', 4, 
 'Good Experience Overall', 'The hospital was clean and well-equipped. Staff was helpful. Only minor wait times.', 
 1, 1, 'Approved', GETUTCDATE());

-- Update Review Statistics
DECLARE @DoctorId UNIQUEIDENTIFIER = '22222222-2222-2222-2222-000000000001';
INSERT INTO ReviewStatistics (ReviewType, EntityId, TotalReviews, AverageRating, FiveStarCount, VerifiedReviewCount, RecommendationPercentage) 
VALUES ('Doctor', @DoctorId, 1, 5.0, 1, 1, 100.0);

GO
