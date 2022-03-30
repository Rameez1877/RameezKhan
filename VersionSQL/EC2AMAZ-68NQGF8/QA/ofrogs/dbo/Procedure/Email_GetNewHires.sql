/****** Object:  Procedure [dbo].[Email_GetNewHires]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <23rd-Oct-2020>
-- Description:	<Send last 6 months new hire data through API>
-- =============================================
CREATE PROCEDURE [dbo].[Email_GetNewHires]
@UserId int,
@Count int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	TOP (@Count)
			Name,
			Organization,
			Designation,
			DateOfJoining,
			Url,
			Template
	FROM	WeeklyReportNewHires
	WHERE	UserId = @UserId
			AND IsSent = 0


	--UPDATE
	--	WeeklyReportNewHires
	--SET	IsSent = 1
	--WHERE 
	--	UserId = @UserId
	--	AND IsSent = 0
END
