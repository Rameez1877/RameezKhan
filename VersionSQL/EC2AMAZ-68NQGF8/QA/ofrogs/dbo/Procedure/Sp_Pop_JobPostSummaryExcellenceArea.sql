/****** Object:  Procedure [dbo].[Sp_Pop_JobPostSummaryExcellenceArea]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Pop_JobPostSummaryExcellenceArea] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Truncate table JobPostSummaryExcellenceArea 

	
	;with jobsummary_Excellence_CTE AS
		(SELECT ind.TagIdOrganization,
			' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ind.Summary, '&', 'and'),',',' '),'/',' '),'\',' '),'-',' '),'(',' '),')',' '),'.',' '),':',' '),';',' ') + ' ' as Summary
			,ind.Id JobPostId 
			FROM IndeedJobPost ind
			WHERE EXISTS (SELECT
				*
				FROM McDecisionmaker Md
				WHERE IsActive = 1
				AND IsOFList = 1
				AND IsGoodKeyword = 1
				AND CHARINDEX(' ' + Md.keyword + ' ',' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ind.Summary, '&', 'and'),',',' '),'/',' '),'\',' '),'-',' '),'(',' '),')',' '),'.',' '),':',' '),';',' ') + ' ') > 0)
		)

	INSERT INTO JobPostSummaryExcellenceArea (JobPostId,TagIdOrganization,ExcellenceArea)
		SELECT distinct
			temp.JobPostId,
			temp.TagIdOrganization,
			t1.Name ExcellenceArea
			FROM McDecisionMaker t1, jobsummary_Excellence_CTE temp 
			WHERE 
			t1.IsOFList = 1
			AND ISactive = 1
			AND IsGoodKeyword = 1
			AND CHARINDEX(' ' + t1.keyword + ' ', ' ' + temp.Summary + ' ') > 0

END
