-- =============================================
-- Medical Travel Booking Platform
-- Payment Service Database Schema
-- =============================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MedicalTravelPaymentDB')
BEGIN
    CREATE DATABASE MedicalTravelPaymentDB;
END
GO

USE MedicalTravelPaymentDB;
GO

-- Payment Methods
CREATE TABLE PaymentMethods (
    PaymentMethodId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    MethodType NVARCHAR(50) NOT NULL, -- CreditCard, DebitCard, PayPal, BankTransfer, etc.
    CardHolderName NVARCHAR(255),
    CardNumberLast4 NVARCHAR(4),
    CardBrand NVARCHAR(50), -- Visa, MasterCard, Amex
    ExpiryMonth INT,
    ExpiryYear INT,
    BillingAddressLine1 NVARCHAR(255),
    BillingAddressLine2 NVARCHAR(255),
    BillingCity NVARCHAR(100),
    BillingState NVARCHAR(100),
    BillingCountry NVARCHAR(100),
    BillingPostalCode NVARCHAR(20),
    IsDefault BIT DEFAULT 0,
    IsVerified BIT DEFAULT 0,
    PaymentGatewayToken NVARCHAR(500), -- Encrypted token from payment gateway
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_PaymentMethods_UserId (UserId)
);

-- Payments
CREATE TABLE Payments (
    PaymentId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    PaymentMethodId UNIQUEIDENTIFIER,
    TransactionId NVARCHAR(255) UNIQUE NOT NULL,
    PaymentType NVARCHAR(50) NOT NULL, -- Appointment, Transportation, Accommodation, Package
    ReferenceId UNIQUEIDENTIFIER NOT NULL, -- ID of the booking/appointment
    Amount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Processing, Completed, Failed, Refunded
    PaymentGateway NVARCHAR(50), -- Stripe, PayPal, Square
    GatewayTransactionId NVARCHAR(255),
    GatewayResponse NVARCHAR(MAX), -- JSON response from gateway
    PaymentDate DATETIME2,
    FailureReason NVARCHAR(500),
    IPAddress NVARCHAR(50),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(PaymentMethodId),
    INDEX IX_Payments_UserId (UserId),
    INDEX IX_Payments_TransactionId (TransactionId),
    INDEX IX_Payments_PaymentStatus (PaymentStatus),
    INDEX IX_Payments_ReferenceId (ReferenceId)
);

-- Refunds
CREATE TABLE Refunds (
    RefundId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PaymentId UNIQUEIDENTIFIER NOT NULL,
    RefundAmount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    RefundReason NVARCHAR(500),
    RefundStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Processing, Completed, Failed
    RefundTransactionId NVARCHAR(255) UNIQUE,
    GatewayRefundId NVARCHAR(255),
    RequestedBy UNIQUEIDENTIFIER NOT NULL,
    ApprovedBy UNIQUEIDENTIFIER,
    RequestedAt DATETIME2 DEFAULT GETUTCDATE(),
    ProcessedAt DATETIME2,
    CompletedAt DATETIME2,
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId),
    INDEX IX_Refunds_PaymentId (PaymentId),
    INDEX IX_Refunds_RefundStatus (RefundStatus)
);

-- Payment Invoices
CREATE TABLE Invoices (
    InvoiceId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PaymentId UNIQUEIDENTIFIER NOT NULL,
    InvoiceNumber NVARCHAR(50) UNIQUE NOT NULL,
    InvoiceDate DATE NOT NULL,
    DueDate DATE,
    BillToName NVARCHAR(255) NOT NULL,
    BillToEmail NVARCHAR(255) NOT NULL,
    BillToAddress NVARCHAR(MAX),
    SubTotal DECIMAL(10,2) NOT NULL,
    TaxAmount DECIMAL(10,2) DEFAULT 0,
    DiscountAmount DECIMAL(10,2) DEFAULT 0,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    InvoiceStatus NVARCHAR(50) DEFAULT 'Generated', -- Generated, Sent, Paid, Overdue
    Notes NVARCHAR(MAX),
    PdfUrl NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId),
    INDEX IX_Invoices_PaymentId (PaymentId),
    INDEX IX_Invoices_InvoiceNumber (InvoiceNumber)
);

-- Invoice Line Items
CREATE TABLE InvoiceLineItems (
    LineItemId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    InvoiceId UNIQUEIDENTIFIER NOT NULL,
    ItemDescription NVARCHAR(500) NOT NULL,
    ItemType NVARCHAR(50), -- Consultation, Surgery, Accommodation, Transport
    Quantity INT DEFAULT 1,
    UnitPrice DECIMAL(10,2) NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (InvoiceId) REFERENCES Invoices(InvoiceId) ON DELETE CASCADE,
    INDEX IX_InvoiceLineItems_InvoiceId (InvoiceId)
);

-- Cost Estimates
CREATE TABLE CostEstimates (
    EstimateId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    HospitalId UNIQUEIDENTIFIER,
    DoctorId UNIQUEIDENTIFIER,
    ProcedureType NVARCHAR(255),
    DiseaseId UNIQUEIDENTIFIER,
    MedicalCost DECIMAL(10,2) DEFAULT 0,
    TransportationCost DECIMAL(10,2) DEFAULT 0,
    AccommodationCost DECIMAL(10,2) DEFAULT 0,
    MiscellaneousCost DECIMAL(10,2) DEFAULT 0,
    TotalEstimatedCost DECIMAL(10,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    EstimateValidity DATE,
    Notes NVARCHAR(MAX),
    CreatedBy UNIQUEIDENTIFIER,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE(),
    INDEX IX_CostEstimates_UserId (UserId)
);

-- Payment Audit Trail
CREATE TABLE PaymentAuditLogs (
    AuditId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    PaymentId UNIQUEIDENTIFIER NOT NULL,
    ActionType NVARCHAR(50) NOT NULL, -- Created, Updated, Refunded, Cancelled
    ActionBy UNIQUEIDENTIFIER,
    OldStatus NVARCHAR(50),
    NewStatus NVARCHAR(50),
    ChangedFields NVARCHAR(MAX), -- JSON with changed fields
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId),
    INDEX IX_PaymentAuditLogs_PaymentId (PaymentId),
    INDEX IX_PaymentAuditLogs_CreatedAt (CreatedAt)
);

-- Insert Sample Payment Methods
INSERT INTO PaymentMethods (UserId, MethodType, CardHolderName, CardNumberLast4, CardBrand, ExpiryMonth, ExpiryYear, IsDefault, IsVerified) VALUES
('11111111-1111-1111-1111-000000000001', 'CreditCard', 'John Doe', '4242', 'Visa', 12, 2025, 1, 1),
('11111111-1111-1111-1111-000000000001', 'PayPal', 'John Doe', NULL, NULL, NULL, NULL, 0, 1);

-- Insert Sample Payments
INSERT INTO Payments (UserId, TransactionId, PaymentType, ReferenceId, Amount, Currency, PaymentStatus, PaymentGateway, PaymentDate) VALUES
('11111111-1111-1111-1111-000000000001', 'TXN-' + CAST(NEWID() AS NVARCHAR(36)), 'Appointment', '22222222-2222-2222-2222-000000000001', 250.00, 'USD', 'Completed', 'Stripe', GETUTCDATE()),
('11111111-1111-1111-1111-000000000001', 'TXN-' + CAST(NEWID() AS NVARCHAR(36)), 'Transportation', '33333333-3333-3333-3333-000000000001', 1250.00, 'USD', 'Completed', 'Stripe', GETUTCDATE());

GO
