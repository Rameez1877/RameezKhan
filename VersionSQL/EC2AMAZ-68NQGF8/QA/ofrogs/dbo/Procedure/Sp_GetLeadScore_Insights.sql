/****** Object:  Procedure [dbo].[Sp_GetLeadScore_Insights]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetLeadScore_Insights]
-- Add the parameters for the stored procedure here
@UserId int,
@OrganizationID int

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  DECLARE @GICCountryList varchar(1000)
  SELECT
    @GICCountryList = STUFF((SELECT
    ',' +' ' + (c.name)
    FROM GICOrganization GIC,
         Country C
    WHERE GIC.OrganizationID = @OrganizationID
    AND GIC.CountryID = C.id
    FOR xml PATH (''), TYPE)
    .value('.', 'NVARCHAR(MAX)')
    , 1, 1, '')

  DECLARE @DecisionMakersCount int,
          @NoofHiring int
--CREATE TABLE #TempLiData
--(ID INT,
--senioritylevel VARCHAR(100),
--ResultantCountry VARCHAR(100),
--Functionality VARCHAR(500))
--CREATE TABLE #TempJobData
--(ID INT,
--senioritylevel VARCHAR(100),
--ResultantCountry VARCHAR(100),
--Functionality VARCHAR(500))
--INSERT INTO #TempLiData
--  SELECT
--    li.ID,
--	li.senioritylevel,
--	li.ResultantCountry,
--	mc.name as Functionality
--  FROM LinkedInData li with (nolock)
--  INNER JOIN dbo.Tag T with (nolock)
--    ON (T.Id = li.TagId
--    AND t.organizationid= @OrganizationId)
--	inner join McdecisionMakerlist mc with (nolock)
--	on (mc.decisionmakerid = li.id)
--print @@Rowcount

--delete #TempLiData
--where senioritylevel IN (SELECT
--  Seniority from UserTargetSeniority
--  where Userid = @UserID)

-- delete #TempLiData
--where ResultantCountry IN (SELECT
--    c.name
--  FROM UserTargetCountry UC, Country C
--  WHERE userid = @UserID
--  and c.id = uc.Countryid)

--  delete #TempLiData
--where Functionality not in (Select Functionality from UserTargetFunctionality
--where Userid= @UserID)

--select  @DecisionMakersCount = COUNT(distinct id) from #TempLiData

--drop table #TempLiData

--  SELECT
--    @NoofHiring = COUNT(*)
--  FROM IndeedJobPost ind WITH (NOLOCK),
--       Tag t WITH (NOLOCK),
--       Organization O WITH (NOLOCK),
--       JobPostExcellenceArea JPAE WITH (NOLOCK)
--  WHERE JPAE.JobPostID = ind.ID
--  AND Ind.TagIdOrganization = T.ID
--  AND T.OrganizationID = O.id
--  AND T.OrganizationID = @OrganizationID
--  AND JPAE.ExcellenceArea IN ('Digital Transformation', 'Learning And Development', 'Intelligent Automation')
--  AND Ind.countrycode IN (SELECT
--    c.id
--  FROM LeadScoreLinkedInCountry ls,
--       country c
--  WHERE c.name = ls.Countryname
--  AND ls.UserId = @UserID
--  AND ls.type = 'Non App')
--  AND ind.jobdate >= GETDATE() - 180

--  -- Insert statements for procedure here
  SELECT
    o.revenue, --LS.revenue,
    i.name AS IndustryName,
    o.EmployeeCount, --LS.EmployeeCount,
 --   null  BudgetScore, 
	--null BudgetScore, --Ls.RevenueScore AS BudgetScore,
 --   null AuthorityScore , -- Ls.AuthorityScore,
 --   null NeedScore, --Ls.IndustryScore AS NeedScore,
 --  null TimingScore, -- Ls.TimingScore,
 --  null TotalScore,-- LS.TotalScore,
 --  null EmployeeCountScore,-- ls.EmployeeCountScore,
    --@DecisionMakersCount NoofDecisionMakers,
    --@NoofHiring NoOfHirings,
    @GICCountryList GICCountryList,
	case when len(o.WebsiteDescription) < 3 then o.GlassdoorDescription else o.websitedescription end Description,
	case when O.WebsiteUrl like'http%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteURL,
	O.WebsiteKeywords 
  FROM Organization o 
  --LEFT OUTER JOIN Leadscore LS ON 
  --(LS.OrganizationID = O.id 
  --AND LS.UserID = @UserId 
  --and ls.TYPE = 'Non App')
  INNER JOIN Industry i  ON (i.Id = o.IndustryId)
  AND O.ID = @OrganizationID

END

--exec Sp_GetLeadScore_Insights 300,212083 
