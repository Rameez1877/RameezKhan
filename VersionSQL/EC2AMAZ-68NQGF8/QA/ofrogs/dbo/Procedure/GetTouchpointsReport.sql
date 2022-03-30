/****** Object:  Procedure [dbo].[GetTouchpointsReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTouchpointsReport]
@UserID INT,
@Month INT,
@Year INT
AS
/*
[GetTouchpointsReport] 326, 5,2021
*/
BEGIN
	SET NOCOUNT ON;

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
AND T.IsTouched = 1 
AND YEAR(TouchDate) = @Year
AND MONTH(TOUCHDATE) = @Month
)
SELECT DISTINCT 
--'TouchPoint' as TouchPointGraph,
DateFilterType,COUNT(DISTINCT NewHireProfileId) DataValue ,SeniorityLevel as Category
FROM CTE 
GROUP BY DateFilterType,SeniorityLevel
ORDER BY 1,3

END
