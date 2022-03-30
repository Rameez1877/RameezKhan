/****** Object:  Procedure [dbo].[ProcessLeadScoreNonApp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Process_LeadScore]
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
  
  DELETE LeadScore WHERE UserID = @UserID and type = 'Non App'
--
  -- Populate Need Score
  -- Industry or Industry Plus Empl Count Or Product Presence in Organziation

  DECLARE @NeedPreference varchar(25), @NeedPreferenceScore INT

  SELECT @NeedPreference = Preference,@NeedPreferenceScore = Score  
  FROM LeadScoreUserNeedPreference WHERE UserID = @UserID and type = 'Non App'
  
  IF @NeedPreference = 'Industry' or @NeedPreference IS NUll
  
  INSERT INTO LeadScore (UserID,
  OrganizationID,
  IndustryScore,
  Revenue,
  EmployeeCount, Type)
     SELECT DISTINCT
      @UserId,
      o.Id,
      L.Score IndustryScore,
      O.Revenue,
      O.EmployeeCount, 'Non App'
    FROM Organization o with (nolock), LeadScoreUserIndustry l
WHERE L.IndustryID = o.IndustryID
and L.userId= @Userid
and l.type = 'Non App'

IF @NeedPreference = 'Industry & EmployeeCount' 

INSERT INTO LeadScore (UserID,
  OrganizationID,
  IndustryScore,
  Revenue,
  EmployeeCount, Type)
  SELECT DISTINCT @UserID, 
	  o.Id,
      L.Score EmpCountIndustryScore,
      O.Revenue,
      O.EmployeeCount, 'Non App'
  FROM Organization o with (nolock) , LeadScoreUserEmpCountIndustryScore l
  WHERE 
  L.EmpCount = O.EmployeeCount
  and L.IndustryID = o.IndustryID
  and L.userId= @Userid
  and l.type = 'Non App'

  IF @NeedPreference = 'Products'
  with cte as-- Organizations having products and products user interested in for scoring
  (
  select OrganizationID from
  Organizationproduct OP, LeadScoreUserProduct LSUP
  WHERE OP.ProductID = LSUP.ProductID
  AND LSUP.UserID = @UserID
  GROUP BY OrganizationID
  )

 
  INSERT INTO LeadScore (UserID,
  OrganizationID,
  IndustryScore,
  Revenue,
  EmployeeCount, Type)
  SELECT DISTINCT @UserID, 
	  o.Id,
      case when cte.OrganizationID is not null then  @NeedPreferenceScore else 0 end  ProductScore,
      O.Revenue,
      O.EmployeeCount, 
	  'Non App'
  FROM Organization o with (NOLOCK)
  left outer join cte on cte.OrganizationID= o.id
 PRINT '2'
   INSERT INTO #TempLeadScore (OrganizationID)
    SELECT
      o.id
    FROM LinkedIndata LI WITH (NOLOCK),
	     McDecisionMakerList m WITH (NOLOCK),
         Tag t with (NOLOCK),
         Organization o with (NOLOCK)
    WHERE li.Tagid = t.id
    AND t.organizationID = o.id
	and M.Mode='Keyword Based List'
	and M.DecisionMakerID = Li.id
	and M.Name in (Select Functionality 
	from LeadScoreUserAuthorityFunction 
	where UserId= @UserId
	and type = 'Non App')
    AND li.SeniorityLevel IN (SELECT
      Seniority
    FROM LeadScoreUserAuthorityLevels
    WHERE userid = @UserId
	and type = 'Non App')
	and li.ResultantCountry in 
	  (select countryname from LeadScoreLinkedInCountry
	  where userid=@userid
	  and type = 'Non App')
     GROUP BY o.id
	 PRINT '3'
  --
  -- Update Authority Score
  --
  UPDATE LeadScore
  SET AuthorityScore = (SELECT
    Score
  FROM LeadScoreUserAuthorityScore
  WHERE userid = @UserId
  and type = 'Non App')
  WHERE OrganizationID IN (SELECT
    OrganizationID
  FROM #TempLeadScore)
  AND  exists
  (select * from linkedindata li with (NOLOCK), tag t, organization o with  (NOLOCK)
  where li.tagid=t.id
  and t.organizationid=o.id
  --and li.decisionmaker = 'DecisionMaker'
  and len(url) > 5
  and li.ResultantCountry in 
  (select countryname from LeadScoreLinkedInCountry
  where userid=@userid
  and type = 'Non App'))
  AND UserID = @UserID and type = 'Non App'
 PRINT '4'
  --
  -- Update Revenue Score
  --
  UPDATE LeadScore
  SET RevenueScore = (SELECT
    score
  FROM LeadScoreUserRevenue
  WHERE LeadScoreUserRevenue.userid = @userid
  AND leadscore.revenue = LeadScoreUserRevenue.Revenue and LeadScoreUserRevenue.type = 'Non App')
  WHERE UserID = @UserID and type = 'Non App'
PRINT '5'
  --
  -- Update Employee Count Score
  --
  UPDATE LeadScore
  SET EmployeeCountScore = (SELECT
    score
  FROM LeadScoreUserEmpCount
  WHERE userid = @userid
  AND leadscore.EmployeeCount = LeadScoreUserEmpCount.EmpCount and LeadScoreUserEmpCount.type = 'Non App')
  WHERE UserID = @UserID and type = 'Non App'
  PRINT '6'
  --
  --Timing Score
  -- 
  --DECLARE @DataFilter varchar(1000),
  --        @TimeScore int

  --SELECT
  --  @DataFilter = DataFilter,
  --  @TimeScore = Score
  --FROM LeadScoreUserTiming
  --WHERE UserID = @UserID
  --AND Type='Non App'
 

  --SET @Query = 'INSERT INTO  #TempTiming Select o.id OrganizationID from IndeedJobPost Ind, Tag T, Organization O WHERE ' + @DataFilter
  --SET @Query = @Query + ' and Ind.TagIdOrganization = T.ID
		--		and T.OrganizationID = O.id'

  --SET @Query = @Query + ' and Ind.countrycode in (SELECT c.id FROM LeadScoreLinkedInCountry ls, country c 
		--		where c.name = ls.Countryname
		--		and ls.UserId = ' + ltrim(str(@UserID)) + ' and ls.type = ''Non App''
		--		) group by o.id'

  --EXEC sp_executesql @Query

  --UPDATE LeadScore
  --SET TimingScore = @TimeScore
  --WHERE UserID = @UserID
  --AND OrganizationID IN (SELECT
  --  OrganizationID
  --FROM #TempTiming) and type = 'Non App'

  --CREATE TABLE #TempLeadScoreTiming(OrganizationID int)
  
  
	SELECT indeed.id AS JobPostId, t.OrganizationId AS OrganizationId, indeed.SeniorityLevel, 
	--excel.Keyword SummaryKeyword, 
	null SummaryKeyword,
	excel.JobTitleKeyword, 
	case when len(excel.JobTitleKeyword) > 2 then l.ScoreKeywordJobTitle
	--when len(excel.Keyword) > 2 then l.ScoreKeywordSummary
	end as score INTO #TempLeadScoreTiming 
	FROM IndeedJobPost indeed WITH (NOLOCK), 
	tag t, 
	JobPostExcellenceArea excel WITH (NOLOCK), 
	LeadScoreUserTiming l
	WHERE 
		indeed.tagidOrganization = t.id
		and indeed.id = excel.JobPostID
		AND indeed.SeniorityLevel = l.SeniorityLevel
		and l.UserID = @UserId 
		and excel.Marketinglist IN 
			(SELECT Functionality FROM LeadScoreUserAuthorityFunction
				where userid = @UserId 
				and LeadScoreUserAuthorityFunction.type = 'Non App')
		and indeed.jobdate >= getdate() - 180
		and indeed.countrycode in
		(SELECT C.id FROM leadscorelinkedincountry l, Country C
		WHERE l.CountryName = C.Name
		and UserID = @UserId 
		and TYPE = 'Non App')
PRINT '7'
SELECT OrganizationId, Score  into #TempLeadScoreTimingFINAL
	FROM (
	SELECT OrganizationId, Score, ROW_NUMBER() OVER(Partition by OrganizationId ORDER BY Score desc) AS Row_Number FROM #TempLeadScoreTiming) q1
	WHERE Row_Number = 1

  UPDATE LeadScore
	SET TimingScore = (SELECT
	Score
	FROM #TempLeadScoreTimingFINAL T1
	WHERE T1.OrganizationId = LeadScore.OrganizationID)
	WHERE UserID = @UserId 
	and TYPE = 'Non App'
	PRINT '8'
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
  WHERE UserID = @UserID and type = 'Non App'
  PRINT '999'
  DROP TABLE #TempTiming
  DROP TABLE #TempLeadScore
  DROP TABLE #TempLeadScoreTiming
END
