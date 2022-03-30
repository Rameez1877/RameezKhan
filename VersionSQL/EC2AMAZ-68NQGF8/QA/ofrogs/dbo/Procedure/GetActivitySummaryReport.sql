/****** Object:  Procedure [dbo].[GetActivitySummaryReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetActivitySummaryReport] @UserID INT
AS
BEGIN
	SET NOCOUNT ON;

	--SELECT 'Company Search' AS ThisWeek, COUNT(ID) AS DataValue
	--FROM CompanySearches
	--WHERE USERID = @UserID
	--UNION
	SELECT 'Company List' AS ThisWeek, COUNT(ID) AS DataValue
	FROM TargetPersona
	WHERE CreatedBy = @UserID
	AND DateDiff(wk,getdate(),CreateDate) =  0
	UNION
	SELECT 'Contact List' AS ThisWeek, COUNT(ID) AS DataValue
	FROM MarketingLists
	WHERE CreatedBy = @UserID
	AND DateDiff(wk,getdate(),CreateDate) =  0
	UNION
	SELECT 'Contacts Exported' AS ThisWeek, COUNT(ID) AS DataValue
	FROM HubSpotSharedProfiles
	WHERE USERID = @UserID
	AND Source = 'Contact'
	AND DateDiff(wk,getdate(),SharedDate) =  0
	UNION
	SELECT 'Touch Points Exported' AS ThisWeek, COUNT(ID) AS DataValue
	FROM HubSpotSharedProfiles
	WHERE USERID = @UserID
	AND Source = 'TouchPoint'
	AND DateDiff(wk,getdate(),SharedDate) =  0

	--UNION
	--SELECT 'Credits Earned' AS ThisWeek, 0 AS DataValue
END
