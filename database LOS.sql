-- Database Setup for Loan Origination System (LOS)
-- Supporting Test Cases: TC_16, TC_17, TC_18

-- 1. Create Applications Table (TC_16: Persistence)
CREATE TABLE Applications (
    AppID INT PRIMARY KEY,
    ApplicantName VARCHAR(100),
    SSN_Encrypted VARBINARY(MAX), -- TC_17: Data Encryption
    DOB_Masked VARCHAR(20),       -- TC_17: Data Masking
    LoanAmount DECIMAL(18, 2),    -- TC_22: Edge Case Max Amount
    Status VARCHAR(20) CHECK (Status IN ('Draft', 'Submitted', 'Under Review', 'Approved', 'Rejected')), -- TC_11
    MonthlyIncome DECIMAL(18, 2),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2. Create Audit Logs Table (TC_18: Audit Trail Validation)
CREATE TABLE Audit_Logs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    AppID INT,
    Action VARCHAR(50),           -- e.g., 'Status Change'
    PreviousStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedBy VARCHAR(50),        -- TC_14: Role Access Tracking
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AppID) REFERENCES Applications(AppID)
);

-- 3. Create Users Table (TC_01, TC_14: Security & Roles)
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE,
    PasswordHash VARCHAR(255),
    UserRole VARCHAR(20) CHECK (UserRole IN ('Admin', 'Underwriter', 'Manager', 'Customer')) -- TC_16
);

-- 4. Seed Data for Testing

-- Insert valid user for TC_01 (Valid Login)
INSERT INTO Users (UserID, Username, PasswordHash, UserRole) 
VALUES (1, 'uw_smith', 'hash_secure_99', 'Underwriter');

-- Insert application for TC_16 (Persistence Check)
INSERT INTO Applications (AppID, ApplicantName, SSN_Encrypted, DOB_Masked, LoanAmount, Status, MonthlyIncome)
VALUES (123, 'John Doe', 0x456e6372797074656453534e, '***-**-1985', 10000.00, 'Submitted', 5000.00);

-- Insert log entry for TC_18 (Audit Trail)
INSERT INTO Audit_Logs (AppID, Action, PreviousStatus, NewStatus, ChangedBy)
VALUES (123, 'Status Change', 'Draft', 'Submitted', 'test_user_01');