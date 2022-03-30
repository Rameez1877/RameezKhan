/****** Object:  Procedure [dbo].[Email_GetLastMonthIntent]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <23rd-Oct-2020>
-- Description:	<Send last one month intent data through API>
-- =============================================
CREATE PROCEDURE [dbo].[Email_GetLastMonthIntent] 
@UserId int,
@Count int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	TOP (@Count)
			CountryName,
			Organization,
			Technology,
			TechnologyCategory,
			DecisionMaker,
			Designation,
			Url
	FROM	WeeklyReportLastMonthIntent	
	WHERE	UserId = @UserId
			AND IsSent = 0

	--UPDATE
	--	WeeklyReportLastMonthIntent
	--SET
	--	IsSent = 1
	--WHERE	UserId = @UserId
	--		AND IsSent = 0

END
