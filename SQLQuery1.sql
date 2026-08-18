CREATE DATABASE SysmexDB;
GO

USE SysmexDB;
GO

CREATE TABLE RAW_UNCLEANED_DATA
(
    ReferralDate VARCHAR(50),
    ReferredBy VARCHAR(100),
    NHI VARCHAR(20),
    PatientName VARCHAR(150),
    DOB VARCHAR(50),
    Department VARCHAR(100),
    AddedToWaitlistDate VARCHAR(50),
    Surgeon VARCHAR(100),
    FSA_Date VARCHAR(50),
    HealthTargetEligible VARCHAR(10)
);
GO

BULK INSERT RAW_UNCLEANED_DATA
FROM 'C:\Users\bir0061\OneDrive - Ara Institute of Canterbury\BCDE214 Database Administration\Assessment1\ARA July Data Wait Lists 2025.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT *
FROM RAW_UNCLEANED_DATA;