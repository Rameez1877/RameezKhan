/****** Object:  Procedure [dbo].[PopulateJobPostSummaryExcellenceArea]    Committed by VersionSQL https://www.versionsql.com ******/

-- =================================================================================================================
-- Author:      Neeraj
-- Create date: 13th July 2020
-- Description: Job Post Summary Excellence Area Population For Complete Data  
-- =================================================================================================================

CREATE Procedure [dbo].[PopulateJobPostSummaryExcellenceArea]
AS
BEGIN
SET NOCOUNT ON

SELECT Id,TagIdOrganization,' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Summary, '&', 'and'),',',' '),'/',' '),'\',' '),'-',' '),'(',' '),')',' '),'.',' '),':',' '),';',' ') + ' ' as Summary into #IndeedJobPostTemp
	From IndeedJobPost WITH (NOLOCK)
	WHERE Id NOT IN (SELECT JobPostId FROM JobPostSummaryExcellenceArea)

SELECT 
		I.Id as [JobPostId],
		I.TagIdOrganization,
		M.[Name] as ExcellenceArea
	INTO #Temp
	FROM #IndeedJobPostTemp I WITH (NOLOCK)
		inner join McDecisionMaker M 
		on (I.Summary like '% ' + M.Keyword + ' %' OR I.Summary like '% ' + M.Keyword + 's %')
	WHERE 
		M.IsOFList = 1
		AND M.IsActive = 1
		AND M.IsGoodKeyword = 1

	INSERT INTO JobPostSummaryExcellenceArea (JobPostId,
		TagIdOrganization,
		ExcellenceArea)
	SELECT Distinct
		JobPostId,
		TagIdOrganization,
		ExcellenceArea
	from #Temp t
	where  not exists
	(select * from JobPostSummaryExcellenceArea j WITH (NOLOCK)
	where t.JobPostID = j.JobPostID
	and t.ExcellenceArea = j.ExcellenceArea)

END
