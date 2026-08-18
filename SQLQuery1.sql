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

ALTER TABLE RAW_UNCLEANED_DATA
ADD ReferralID INT IDENTITY(1,1);

SELECT *
FROM RAW_UNCLEANED_DATA;

DELETE FROM RAW_UNCLEANED_DATA
WHERE ReferralID = 500;

SELECT
    ReferralDate,
    ReferredBy,
    NHI,
    PatientName,
    DOB,
    Department,
    AddedToWaitlistDate,
    Surgeon,
    FSA_Date,
    HealthTargetEligible,
    COUNT(*) AS DuplicateCount
FROM RAW_UNCLEANED_DATA
GROUP BY
    ReferralDate,
    ReferredBy,
    NHI,
    PatientName,
    DOB,
    Department,
    AddedToWaitlistDate,
    Surgeon,
    FSA_Date,
    HealthTargetEligible
HAVING COUNT(*) > 1;


SELECT * FROM RAW_UNCLEANED_DATA;

--Checking department name 
SELECT DISTINCT Department
FROM RAW_UNCLEANED_DATA
ORDER BY Department;

--Checking Data Error
SELECT DISTINCT HealthTargetEligible
FROM RAW_UNCLEANED_DATA;

--Checking dates error
SELECT ReferralID, ReferralDate
FROM RAW_UNCLEANED_DATA
WHERE TRY_CONVERT(DATE, ReferralDate, 103) IS NULL
  AND ReferralDate IS NOT NULL;

--Checking dates error
SELECT ReferralID, FSA_Date
FROM RAW_UNCLEANED_DATA
WHERE TRY_CONVERT(DATE, FSA_Date, 103) IS NULL
  AND FSA_Date IS NOT NULL;

--Checking dates error
SELECT ReferralID, DOB
FROM RAW_UNCLEANED_DATA
WHERE TRY_CONVERT(DATE, DOB, 103) IS NULL
  AND DOB IS NOT NULL;

--Fixed DOB  error
SELECT *
FROM RAW_UNCLEANED_DATA
WHERE DOB = '42/06/1949';

--Fixed DOB  error
UPDATE RAW_UNCLEANED_DATA
SET DOB = '24/06/1949'
WHERE DOB = '42/06/1949';


--Finding logic errors
SELECT *
FROM RAW_UNCLEANED_DATA
WHERE TRY_CONVERT(DATE, DOB, 103)
      > TRY_CONVERT(DATE, ReferralDate, 103);

--Fixing the DOB logic error
SELECT
    NHI,
    PatientName,
    ReferralDate,
    DOB
FROM RAW_UNCLEANED_DATA
WHERE NHI IN ('BAK4481', 'QCH4565', 'JPV1836');

UPDATE RAW_UNCLEANED_DATA
SET DOB = '10/12/1972'
WHERE NHI = 'BAK4481';


SELECT 
    NHI, opatientName,
    COUNT(*) AS NumberOfRecords
FROM RAW_UNCLEANED_DATA
WHERE NHI IS NOT NULL
GROUP BY NHI
HAVING COUNT(*) > 1;