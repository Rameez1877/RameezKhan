/****** Object:  Procedure [dbo].[GetContactsReport]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [dbo].[GetContactsReport] 
@UserID INT,
@Month INT,
@Year INT
AS
/*
[GetContactsReport] 326,12,2021
*/
BEGIN
	SET NOCOUNT ON;

	;WITH CTE AS(
SELECT DISTINCT DML.DecisionMakerId,
DML.SeniorityLevel,
MONTH(CreateDate) MONTH,YEAR(CreateDate) YEAR,
CASE  
WHEN DAY(CreateDate) > 23  THEN 'W4'
WHEN DAY(CreateDate) BETWEEN 17 AND 23  THEN 'W3'
WHEN DAY(CreateDate) BETWEEN 9 AND 16  THEN 'W2'
WHEN DAY(CreateDate) BETWEEN 1 AND 8  THEN 'W1' END AS DateFilterType
FROM MarketingLists ML WITH(NOLOCK)
INNER JOIN DecisionMakersForMarketingList DML WITH(NOLOCK)
ON ML.ID = DML.MARKETINGLISTID
WHERE
ML.CREATEDBY = @UserID
AND DML.SeniorityLevel IN ('Influencer','Director','C-Level') 
AND YEAR(CreateDate) = @Year
AND MONTH(CreateDate) = @Month
)
SELECT DISTINCT 
--'Contacts' as ContactGraph,
DateFilterType,COUNT(DISTINCT DecisionMakerId) DataValue ,SeniorityLevel as Category
FROM CTE 
GROUP BY DateFilterType,SeniorityLevel
--ORDER BY 2,4



END
