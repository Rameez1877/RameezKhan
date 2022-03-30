/****** Object:  Procedure [dbo].[PopulateJobPostHiringDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PopulateJobPostHiringDetail]
AS
BEGIN
	
	SET NOCOUNT ON;

	TRUNCATE TABLE JobPostHiringDetail

	INSERT INTO JobPostHiringDetail (
	[OrganizationId]
	,[FocusArea]
	,[JobTitle]
	,[location]
	,[Country])
	SELECT
    DISTINCT
  ind.organizationid,JP.ExcellenceArea AS FocusArea,
  ind.JobTitle,
  CASE WHEN ind.Location like '%[^0-9][0-9]%' 
		 THEN rtrim(ltrim(left(ind.Location, patindex('%[^0-9][0-9]%',ind.Location))))
		 ELSE rtrim(ltrim(ind.Location)) END ,
 c.[Name] as Country 
  FROM IndeedJobPostLast6Months ind with (NOLOCK)
	inner join  JobPostExcellenceArea JP with (NOLOCK) on ( JP.JobPostID = ind.ID )
    INNER JOIN Country c with (NOLOCK) ON C.ID = ind.CountryCode 
    where ind.OrganizationId is not null
	and ind.Location <> ''
	and ind.Location <> ','
	and ind.Location <> ' '
	

	UPDATE JobPostHiringDetail SET location = IIF(CHARINDEX(',',Location)=len(Location),
	left(Location,len(Location)-1),Location)

END
