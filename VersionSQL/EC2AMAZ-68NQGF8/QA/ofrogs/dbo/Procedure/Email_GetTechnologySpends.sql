/****** Object:  Procedure [dbo].[Email_GetTechnologySpends]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <23rd-Oct-2020>
-- Description:	<Send last one month highest Technology Spend intent data through API>
-- =============================================
CREATE PROCEDURE [dbo].[Email_GetTechnologySpends] 
@UserId int,
@Count int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	TOP (@Count)
			CompanyName,
			Intent,
			SpendEstimate,
			DecisionMaker,
			Designation,
			Url
	FROM	WeeklyReportTechnologySpends
	WHERE	UserId = @UserId
			AND IsSent = 0

	--UPDATE
	--	WeeklyReportTechnologySpends
	--SET	
	--	IsSent = 1
	--WHERE
	--	UserId = @UserId
	--	AND IsSent = 0
					
END
