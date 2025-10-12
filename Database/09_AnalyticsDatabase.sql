-- =============================================
-- Medical Travel Booking Platform
-- Analytics Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelAnalyticsDB')
BEGIN
    CREATE DATABASE MedicalTravelAnalyticsDB;
END
GO

USE MedicalTravelAnalyticsDB;
GO

-- User Activity Tracking
CREATE TABLE UserActivityLogs (
    ActivityId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    SessionId UNIQUEIDENTIFIER,
    ActivityType NVARCHAR(50) NOT NULL, -- PageView, Click, Search, Booking, etc.
    PageUrl NVARCHAR(500),
    PageTitle NVARCHAR(255),
    ReferrerUrl NVARCHAR(500),
    ActionName NVARCHAR(100),
    ActionDetails NVARCHAR(MAX), -- JSON
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    DeviceType NVARCHAR(20), -- Desktop, Mobile, Tablet
    Browser NVARCHAR(50),
    OperatingSystem NVARCHAR(50),
    Country NVARCHAR(100),
    City NVARCHAR(100),
    Duration INT, -- Time spent in seconds
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_UserActivityLogs_UserId (UserId),
    INDEX IX_UserActivityLogs_SessionId (SessionId),
    INDEX IX_UserActivityLogs_ActivityType (ActivityType),
    INDEX IX_UserActivityLogs_CreatedAt (CreatedAt)
);

-- Search Analytics
CREATE TABLE SearchAnalytics (
    SearchId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    SessionId UNIQUEIDENTIFIER,
    SearchQuery NVARCHAR(500) NOT NULL,
    SearchType NVARCHAR(50), -- Doctor, Hospital, Disease, Location
    Filters NVARCHAR(MAX), -- JSON of applied filters
    ResultsCount INT,
    ClickedResultId UNIQUEIDENTIFIER,
    ClickedResultType NVARCHAR(50),
    ClickedResultPosition INT,
    NoResultsFound BIT DEFAULT 0,
    SearchDuration INT, -- Milliseconds
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_SearchAnalytics_UserId (UserId),
    INDEX IX_SearchAnalytics_SearchQuery (SearchQuery),
    INDEX IX_SearchAnalytics_CreatedAt (CreatedAt)
);

-- Booking Funnel Analytics
CREATE TABLE BookingFunnelAnalytics (
    FunnelId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    SessionId UNIQUEIDENTIFIER NOT NULL,
    FunnelStage NVARCHAR(50) NOT NULL, -- Search, ViewProfile, SelectDate, EnterDetails, Payment, Confirmation
    EntityType NVARCHAR(50), -- Appointment, Transportation, Accommodation
    EntityId UNIQUEIDENTIFIER,
    CompletedAt DATETIME2,
    DroppedAt DATETIME2,
    TimeSpentInStage INT, -- Seconds
    PreviousStage NVARCHAR(50),
    NextStage NVARCHAR(50),
    IsCompleted BIT DEFAULT 0,
    IsDropped BIT DEFAULT 0,
    DropReason NVARCHAR(255),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_BookingFunnelAnalytics_SessionId (SessionId),
    INDEX IX_BookingFunnelAnalytics_FunnelStage (FunnelStage),
    INDEX IX_BookingFunnelAnalytics_UserId (UserId)
);

-- Conversion Tracking
CREATE TABLE ConversionTracking (
    ConversionId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    SessionId UNIQUEIDENTIFIER,
    ConversionType NVARCHAR(50) NOT NULL, -- AppointmentBooked, TransportBooked, AccommodationBooked, Payment
    ConversionValue DECIMAL(10,2),
    Currency NVARCHAR(10) DEFAULT 'USD',
    ConversionSource NVARCHAR(100), -- Search, Direct, Referral, Email, Social
    ReferrerUrl NVARCHAR(500),
    CampaignName NVARCHAR(100),
    CampaignSource NVARCHAR(100),
    CampaignMedium NVARCHAR(100),
    EntityType NVARCHAR(50),
    EntityId UNIQUEIDENTIFIER NOT NULL,
    TimeToConversion INT, -- Seconds from first visit
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_ConversionTracking_UserId (UserId),
    INDEX IX_ConversionTracking_ConversionType (ConversionType),
    INDEX IX_ConversionTracking_CreatedAt (CreatedAt)
);

-- Page Performance Metrics
CREATE TABLE PagePerformanceMetrics (
    MetricId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PageUrl NVARCHAR(500) NOT NULL,
    PageTitle NVARCHAR(255),
    LoadTime INT NOT NULL, -- Milliseconds
    DOMContentLoaded INT,
    FirstContentfulPaint INT,
    TimeToInteractive INT,
    TotalBlockingTime INT,
    CumulativeLayoutShift DECIMAL(5,4),
    Browser NVARCHAR(50),
    DeviceType NVARCHAR(20),
    ConnectionType NVARCHAR(20),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_PagePerformanceMetrics_PageUrl (PageUrl),
    INDEX IX_PagePerformanceMetrics_CreatedAt (CreatedAt)
);

-- Business Metrics (Aggregated Daily)
CREATE TABLE BusinessMetrics (
    MetricId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    MetricDate DATE NOT NULL,
    TotalUsers INT DEFAULT 0,
    NewUsers INT DEFAULT 0,
    ActiveUsers INT DEFAULT 0,
    TotalSessions INT DEFAULT 0,
    TotalPageViews INT DEFAULT 0,
    TotalSearches INT DEFAULT 0,
    TotalAppointments INT DEFAULT 0,
    TotalTransportBookings INT DEFAULT 0,
    TotalAccommodationBookings INT DEFAULT 0,
    TotalRevenue DECIMAL(12,2) DEFAULT 0,
    Currency NVARCHAR(10) DEFAULT 'USD',
    AverageOrderValue DECIMAL(10,2) DEFAULT 0,
    ConversionRate DECIMAL(5,2) DEFAULT 0,
    BounceRate DECIMAL(5,2) DEFAULT 0,
    AverageSessionDuration INT DEFAULT 0, -- Seconds
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_BusinessMetrics_MetricDate (MetricDate)
);

-- Provider Performance Metrics
CREATE TABLE ProviderPerformanceMetrics (
    MetricId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    MetricDate DATE NOT NULL,
    ProviderId UNIQUEIDENTIFIER NOT NULL,
    ProviderType NVARCHAR(50) NOT NULL, -- Hospital, Doctor
    ProfileViews INT DEFAULT 0,
    SearchAppearances INT DEFAULT 0,
    ClickThroughRate DECIMAL(5,2) DEFAULT 0,
    TotalAppointments INT DEFAULT 0,
    CompletedAppointments INT DEFAULT 0,
    CancelledAppointments INT DEFAULT 0,
    NoShowAppointments INT DEFAULT 0,
    AverageRating DECIMAL(3,2) DEFAULT 0,
    TotalReviews INT DEFAULT 0,
    TotalRevenue DECIMAL(10,2) DEFAULT 0,
    Currency NVARCHAR(10) DEFAULT 'USD',
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_ProviderPerformanceMetrics_ProviderId (ProviderId),
    INDEX IX_ProviderPerformanceMetrics_MetricDate (MetricDate)
);

-- User Engagement Metrics
CREATE TABLE UserEngagementMetrics (
    MetricId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    MetricMonth DATE NOT NULL, -- First day of month
    TotalSessions INT DEFAULT 0,
    TotalPageViews INT DEFAULT 0,
    AverageSessionDuration INT DEFAULT 0,
    TotalSearches INT DEFAULT 0,
    TotalBookings INT DEFAULT 0,
    TotalSpent DECIMAL(10,2) DEFAULT 0,
    Currency NVARCHAR(10) DEFAULT 'USD',
    LastActivityDate DATETIME2,
    DaysSinceLastActivity INT,
    EngagementScore INT, -- 0-100 calculated score
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_UserEngagementMetrics_UserId (UserId),
    INDEX IX_UserEngagementMetrics_MetricMonth (MetricMonth)
);

-- Error Tracking
CREATE TABLE ErrorLogs (
    ErrorId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER,
    SessionId UNIQUEIDENTIFIER,
    ErrorType NVARCHAR(50) NOT NULL, -- JavaScript, API, System
    ErrorMessage NVARCHAR(MAX) NOT NULL,
    ErrorStack NVARCHAR(MAX),
    PageUrl NVARCHAR(500),
    UserAgent NVARCHAR(500),
    Browser NVARCHAR(50),
    OperatingSystem NVARCHAR(50),
    Severity NVARCHAR(20), -- Low, Medium, High, Critical
    IsResolved BIT DEFAULT 0,
    ResolvedAt DATETIME2,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_ErrorLogs_ErrorType (ErrorType),
    INDEX IX_ErrorLogs_Severity (Severity),
    INDEX IX_ErrorLogs_CreatedAt (CreatedAt)
);

-- API Usage Analytics
CREATE TABLE APIUsageAnalytics (
    UsageId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ServiceName NVARCHAR(100) NOT NULL,
    Endpoint NVARCHAR(255) NOT NULL,
    HttpMethod NVARCHAR(10) NOT NULL,
    UserId UNIQUEIDENTIFIER,
    StatusCode INT NOT NULL,
    ResponseTime INT NOT NULL, -- Milliseconds
    RequestSize BIGINT, -- Bytes
    ResponseSize BIGINT, -- Bytes
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    IsSuccessful BIT,
    ErrorMessage NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_APIUsageAnalytics_ServiceName (ServiceName),
    INDEX IX_APIUsageAnalytics_Endpoint (Endpoint),
    INDEX IX_APIUsageAnalytics_StatusCode (StatusCode),
    INDEX IX_APIUsageAnalytics_CreatedAt (CreatedAt)
);

-- Campaign Performance
CREATE TABLE CampaignPerformance (
    CampaignId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CampaignName NVARCHAR(100) NOT NULL,
    CampaignSource NVARCHAR(100),
    CampaignMedium NVARCHAR(100),
    CampaignContent NVARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE,
    TotalClicks INT DEFAULT 0,
    TotalImpressions INT DEFAULT 0,
    TotalConversions INT DEFAULT 0,
    ConversionRate DECIMAL(5,2) DEFAULT 0,
    TotalRevenue DECIMAL(10,2) DEFAULT 0,
    Currency NVARCHAR(10) DEFAULT 'USD',
    CostPerClick DECIMAL(10,2),
    ReturnOnInvestment DECIMAL(10,2),
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_CampaignPerformance_CampaignName (CampaignName),
    INDEX IX_CampaignPerformance_StartDate (StartDate)
);

-- Insert Sample Data
INSERT INTO BusinessMetrics (MetricDate, TotalUsers, NewUsers, ActiveUsers, TotalSessions, TotalPageViews, TotalSearches, ConversionRate) VALUES
(CAST(GETUTCDATE() AS DATE), 1500, 250, 800, 3200, 15000, 2500, 3.5),
(CAST(DATEADD(DAY, -1, GETUTCDATE()) AS DATE), 1450, 230, 750, 3000, 14500, 2400, 3.2);

GO
