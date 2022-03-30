/****** Object:  Procedure [dbo].[GetAccountsReport]    Committed by VersionSQL https://www.versionsql.com ******/

--[GetAccountsReport]  159,12,2021
CREATE PROCEDURE [dbo].[GetAccountsReport] 
@UserID INT,
@Month INT,
@Year INT
AS
/*
GetAccountsReport 159, 'weekly'
*/
BEGIN
	SET NOCOUNT ON;
	

;WITH CTE AS(
SELECT DISTINCT
 OrganizationId,YEAR(CreateDate) AS YEAR,MONTH(CreateDate) AS MONTH, DAY(CreateDate) AS DAY
 ,CASE  
WHEN DAY(CreateDate) > 23  THEN 'W4'
WHEN DAY(CreateDate) BETWEEN 17 AND 23  THEN 'W3'
WHEN DAY(CreateDate) BETWEEN 9 AND 16  THEN 'W2'
WHEN DAY(CreateDate) BETWEEN 1 AND 8  THEN 'W1' END AS DateFilterType
FROM TargetPersona T
INNER JOIN TargetPersonaOrganization TPO
ON T.ID = TPO.TargetPersonaId
WHERE CreatedBy = @UserID
AND Intent <> ''
AND MONTH(CreateDate) = @Month
AND YEAR(CreateDate) = @Year
)

SELECT DISTINCT 
'With Intent' as AccountAndIntentGraph
,DateFilterType,COUNT(DISTINCT OrganizationId) DataValue 
INTO #TmpAccountGraph 
FROM CTE
GROUP BY DateFilterType

;WITH CTE AS(
SELECT 
 OrganizationId,YEAR(CreateDate) AS YEAR,MONTH(CreateDate) AS MONTH, DAY(CreateDate) AS DAY,
CASE  
WHEN DAY(CreateDate) > 23  THEN 'W4'
WHEN DAY(CreateDate) BETWEEN 17 AND 23  THEN 'W3'
WHEN DAY(CreateDate) BETWEEN 9 AND 16  THEN 'W2'
WHEN DAY(CreateDate) BETWEEN 1 AND 8  THEN 'W1' END AS DateFilterType
FROM TargetPersona T
INNER JOIN TargetPersonaOrganization TPO
ON T.ID = TPO.TargetPersonaId
WHERE CreatedBy = @UserID
AND (Intent = '' OR Intent IS NULL)
AND MONTH(CreateDate) = @Month
AND YEAR(CreateDate) = @Year)
INSERT INTO #TmpAccountGraph (AccountAndIntentGraph,DateFilterType,DataValue)
SELECT DISTINCT 
'Accounts',DateFilterType,COUNT(DISTINCT OrganizationId) VALUE 
FROM CTE 
GROUP BY DateFilterType

SELECT AccountAndIntentGraph as Category,DateFilterType,DataValue
FROM #TmpAccountGraph
ORDER BY 2,1

END
