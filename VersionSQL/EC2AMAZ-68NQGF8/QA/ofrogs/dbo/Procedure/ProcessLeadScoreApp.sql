/****** Object:  Procedure [dbo].[ProcessLeadScoreApp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Process_LeadScore_App]
-- Add the parameters for the stored procedure here
@UserId int
AS
BEGIN


  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
    DECLARE @Query nvarchar(4000)
  
  CREATE TABLE #TempLeadScore (
    OrganizationID int
  )
  CREATE TABLE #TempTiming (
    OrganizationID int
  )



  DELETE LeadScore 
  WHERE UserID = @UserID and type = 'App'

  -- change below replace LeadScoreUserIndustry with LeadScoreUserAppCategory
  INSERT INTO LeadScore (UserID,
  OrganizationID,
  IndustryScore,-- this column is used for AppCategoryScore
  Revenue,
  EmployeeCount, 
  type,
  NoOfDownloads,
  AppName,
  AppCAtegoryID)
     SELECT DISTINCT
      @UserId,
      m.organizationid,
      L.Score,
      O.Revenue,
      O.EmployeeCount, 
	  'App',
	  m.Installs,
	  m.AppName,
	  m.AppCategoryID
    FROM MobileApp m , LeadScoreUserAppCategory l, organization o 
WHERE m.AppCategoryID = l.AppCategoryId 
and m.OrganizationID = o.id
and m.isactive = 1
and type = 'App'
and L.userId= @Userid


   INSERT INTO #TempLeadScore (OrganizationID)
    SELECT
      o.id
    FROM LinkedIndata LI,
	     McDecisionMakerList m,
         Tag t,
         Organization o
    WHERE li.Tagid = t.id
    AND t.organizationID = o.id
	and M.Mode='Keyword Based List'
	and M.DecisionMakerID = Li.id
	and M.Name in (Select Functionality 
	from LeadScoreUserAuthorityFunction 
	where UserId= @UserId and type = 'App')
    AND li.SeniorityLevel IN (SELECT
      Seniority
    FROM LeadScoreUserAuthorityLevels
    WHERE userid = @UserId and type = 'App')
	and li.ResultantCountry in 
	  (select countryname from LeadScoreLinkedInCountry
	  where userid=@userid and type = 'App')
     GROUP BY o.id
	 
  --
  -- Update Authority Score
  --
  UPDATE LeadScore
  SET AuthorityScore = (SELECT
    Score
  FROM LeadScoreUserAuthorityScore
  WHERE userid = @UserId and type = 'App')
  WHERE OrganizationID IN (SELECT
    OrganizationID
  FROM #TempLeadScore)
  AND  exists
  (select * from linkedindata li, tag t, organization o
  where li.tagid=t.id
  and t.organizationid=o.id
  and li.decisionmaker = 'DecisionMaker'
  and len(url) > 5
  and li.ResultantCountry in 
  (select countryname from LeadScoreLinkedInCountry
  where userid=@userid and type = 'App'))
  AND UserID = @UserID and type = 'App'
  --
  -- Update Revenue Score
  --
  UPDATE LeadScore
  SET RevenueScore = (SELECT
    score
  FROM LeadScoreUserRevenue
  WHERE userid = @userid
  AND leadscore.revenue = LeadScoreUserRevenue.Revenue and LeadScoreUserRevenue.type = 'App')
  WHERE UserID = @UserID and type = 'App'
 
  --
  -- Update Employee Count Score
  --
  UPDATE LeadScore
  SET EmployeeCountScore = (SELECT
    score
  FROM LeadScoreUserEmpCount
  WHERE userid = @userid 
  AND leadscore.EmployeeCount = LeadScoreUserEmpCount.EmpCount and LeadScoreUserEmpCount.type = 'App')
  WHERE UserID = @UserID and type = 'App'
  --
  --Timing Score
  -- 

 UPDATE LeadScore
  SET TimingScore = (SELECT
    score
  FROM LeadScoreUserAppDowload
  WHERE userid = @userid
  AND leadscore.NoOfDownloads = LeadScoreUserAppDowload.NoOfDownloads and LeadScoreUserAppDowload.type = 'App')
  WHERE UserID = @UserID and type = 'App'


  --
  -- Update Total Score (Employee Count Score Should Be considered when Budget score is absent)
  --
  UPDATE LeadScore
  SET TotalScore = (CASE
    WHEN IndustryScore IS NULL THEN 0
    ELSE IndustryScore
  END)
  + (CASE
    WHEN TimingScore IS NULL THEN 0
    ELSE TimingScore
  END)
  + (CASE
    WHEN AuthorityScore IS NULL THEN 0
    ELSE AuthorityScore
  END)
  + (CASE
    WHEN RevenueScore IS NULL THEN (CASE
        WHEN EmployeeCountScore IS NULL THEN 0
        ELSE EmployeeCountScore
      END)
    ELSE RevenueScore
  END)
  WHERE UserID = @UserID and type = 'App'
 
  DROP TABLE #TempTiming
  DROP TABLE #TempLeadScore
END
