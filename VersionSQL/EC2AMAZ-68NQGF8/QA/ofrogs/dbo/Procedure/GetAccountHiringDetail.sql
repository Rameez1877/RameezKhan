/****** Object:  Procedure [dbo].[GetAccountHiringDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	Janna
-- Create date: 27/06/2019
-- Description:	TargetPersona Screen Popup For Hiring Details For A Organization
-- Filter records based on what is configured for Lead Score
-- =============================================
CREATE PROCEDURE [dbo].[GetAccountHiringDetail] @OrganizationID int,
@UserID int
AS
/*
[dbo].[GetAccountHiringDetail] 783823, 326

783823,2708,3103,177951
*/
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
 
	SELECT DISTINCT
	 FocusArea,
	 JobTitle,
	 Location,
	 --Summary,
	 Country
	FROM JobPostHiringDetail 
	WHERE OrganizationId = @OrganizationID







 -- OLD LOGIC
  --DECLARE @CustomerType VARCHAR(100)

 --SELECT @CustomerType = CustomerType FROM AppUser WHERE ID = @UserID

-- IF @CustomerType <> ''
-- BEGIN

----SELECT DISTINCT FUNCTIONALITY INTO #TEMP FROM DashboardUserSurge WHERE USERID = @UserID AND
----ORGANIZATIONID = @OrganizationID

----DECLARE @FUNC VARCHAR(500) = (SELECT STRING_AGG(FUNCTIONALITY,', ') FROM #TEMP)


--SELECT 
--   distinct top 2000
--  JPAE.ExcellenceArea AS FocusArea,
--  ind.JobTitle,
--  ind.location AS [Location],
--  --ind.Summary,
--  C.NAME Country
----@FUNC AS Functionality
--  FROM IndeedJobPostLast6Months ind with (NOLOCK)
--	INNER JOIN  JobPostExcellenceArea JPAE with (NOLOCK)
--		on ( JPAE.JobPostID = ind.ID AND ind.OrganizationID = @OrganizationID
--		AND JPAE.ExcellenceArea IN (SELECT  Functionality FROM UserTargetFunctionality WHERE UserID = @UserID))

--		INNER JOIN Organization O ON O.Id = @OrganizationID		
--		INNER JOIN Country c  ON C.ID = O.CountryId 
--		END

--ELSE 
--BEGIN
--SELECT
--    TOP 1000
--  JPAE.ExcellenceArea AS FocusArea,
--  ind.JobTitle,
--  ind.location AS Location,
-- -- ind.Summary
-- c.[Name] as Country
--  FROM IndeedJobPostLast6Months ind with (NOLOCK)
--	inner join  JobPostExcellenceArea JPAE with (NOLOCK)
--		on ( JPAE.JobPostID = ind.ID AND ind.OrganizationID = @OrganizationID)

--		--INNER JOIN Organization O WITH (NOLOCK) ON O.Id = @OrganizationID		
--		INNER JOIN Country c with (NOLOCK) ON C.ID = ind.CountryCode 
--       -- where ind.jobdate > getdate()-180
		
--		--END


--AND JPAE.ExcellenceArea IN (select Functionality from UserTargetFunctionality where UserID = @UserID)
--and Ind.countrycode IN
--(select c.id from country c, UserTargetCountry UC
--where uc.CountryID = c.id
--and uc.UserID =@UserID) 
END
