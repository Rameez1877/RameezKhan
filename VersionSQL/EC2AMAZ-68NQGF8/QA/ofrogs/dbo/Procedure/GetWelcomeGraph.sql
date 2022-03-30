/****** Object:  Procedure [dbo].[GetWelcomeGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- 24-DEC-2021 - KABIR
CREATE PROCEDURE [dbo].[GetWelcomeGraph]
@UserID INT,
@Month INT,
@Year INT
AS
BEGIN
  SET NOCOUNT ON;

SELECT 'CompanySearch' AS ThisWeek, COUNT(ID) AS DataValue
FROM CompanySearches
WHERE USERID = @UserID
UNION
SELECT 'CompanyList' AS ThisWeek, COUNT(ID) AS DataValue
FROM TargetPersona
WHERE CreatedBy = @UserID
UNION
SELECT 'ContactList' AS ThisWeek, COUNT(ID) AS DataValue
FROM MarketingLists
WHERE CreatedBy = @UserID
UNION
SELECT 'ContactsExported' AS ThisWeek, COUNT(ID) AS DataValue
FROM HubSpotSharedProfiles
WHERE USERID = @UserID
AND Source = 'Contact'
UNION
SELECT 'TouchpointsExported' AS ThisWeek, COUNT(ID) AS DataValue
FROM HubSpotSharedProfiles
WHERE USERID = @UserID
AND Source = 'TouchPoint'
UNION
SELECT 'Credits Earned' AS ThisWeek, 0 AS DataValue


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
'IntentAccounts' as IntentGraph,DateFilterType,COUNT(OrganizationId) DataValue 
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
INSERT INTO #TmpAccountGraph (IntentGraph,DateFilterType,DataValue)
SELECT DISTINCT 
'Accounts' as Type,DateFilterType,COUNT(OrganizationId) VALUE 
FROM CTE 
GROUP BY DateFilterType

SELECT *
FROM #TmpAccountGraph
ORDER BY 2,1

;WITH CTE AS(
SELECT DISTINCT DML.Id,
DML.SeniorityLevel,
MONTH(CreateDate) MONTH,YEAR(CreateDate) YEAR,
CASE  
WHEN DAY(CreateDate) > 23  THEN 'W4'
WHEN DAY(CreateDate) BETWEEN 17 AND 23  THEN 'W3'
WHEN DAY(CreateDate) BETWEEN 9 AND 16  THEN 'W2'
WHEN DAY(CreateDate) BETWEEN 1 AND 8  THEN 'W1' END AS DateFilterType
FROM MarketingLists ML
INNER JOIN DecisionMakersForMarketingList DML
ON ML.ID = DML.MARKETINGLISTID
WHERE
ML.CREATEDBY = @UserID
AND DML.SeniorityLevel IN ('Influencer','Director','C-Level') 
AND YEAR(CreateDate) = @Year
AND MONTH(CreateDate) = @Month
)
SELECT DISTINCT 
'Contacts' as ContactGraph,DateFilterType,COUNT(ID) DataValue ,SeniorityLevel 
FROM CTE 
GROUP BY DateFilterType,SeniorityLevel
ORDER BY 2,4

;WITH CTE AS(
SELECT DISTINCT NewHireProfileId,L.SeniorityLevel,T.TouchDate,CASE  
WHEN DAY(TouchDate) > 23  THEN 'W4'
WHEN DAY(TouchDate) BETWEEN 17 AND 23  THEN 'W3'
WHEN DAY(TouchDate) BETWEEN 9 AND 16  THEN 'W2'
WHEN DAY(TouchDate) BETWEEN 1 AND 8  THEN 'W1' END AS DateFilterType
FROM TouchProfilesAppUsers T
INNER JOIN LinkedinDataNewHire L
ON T.NEWHIREPROFILEID = L.ID
WHERE
T.AppuserID = @UserID
AND l.SeniorityLevel IN ('Influencer','Director','C-Level') 
AND T.IsTouched = 1 )
SELECT DISTINCT 
'TouchPoint' as TouchPointGraph,DateFilterType,COUNT(NewHireProfileId) DataValue ,SeniorityLevel 
FROM CTE 
GROUP BY DateFilterType,SeniorityLevel
ORDER BY 2,4

END
