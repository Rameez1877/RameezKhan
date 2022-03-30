/****** Object:  Procedure [dbo].[GetLeadScoreSubMarketingListInsights]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetLeadScoreSubMarketingListInsights]
-- Add the parameters for the stored procedure here
@OrganizationID int,
@Location varchar(8000),
@SubMarketingList varchar(8000)

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  DECLARE @GICCountryList varchar(1000)
  SELECT
    @GICCountryList = STUFF((SELECT
      ',' + ' ' + (c.name)
    FROM GICOrganization GIC,
         Country C
    WHERE GIC.OrganizationID = @OrganizationID
    AND GIC.CountryID = C.id
    FOR xml PATH (''), TYPE)
    .value('.', 'NVARCHAR(MAX)')
    , 1, 1, '')

  DECLARE @DecisionMakersCount int,
          @NoofHiring int,
		  @TeamSize Int

  CREATE TABLE #TempLocation (
    CountryName varchar(100)
  )
  IF @Location = '' or @Location is null
    INSERT INTO #TempLocation
      SELECT
        Name
      FROM Country
  ELSE
    INSERT INTO #TempLocation
      SELECT
        [Data]
      FROM dbo.Split(@Location, ',')

  CREATE TABLE #TempSubMarketingList (
    SubMarketingList varchar(100)
  )

  IF @SubMarketingList = '' or @SubMarketingList is null
    INSERT INTO #TempSubMarketingList
      SELECT
        SubMarketingListNameDisplay
      FROM v_marketinglist
  ELSE
    INSERT INTO #TempSubMarketingList
      SELECT
        [Data]
      FROM dbo.Split(@SubMarketingList, ',')

  SELECT
    @DecisionMakersCount = sum(case when  Li.SeniorityLevel in ('C-Level','Director') then 1 else 0 end ),

	@TeamSize =  COUNT(DISTINCT LI.id)
  FROM LinkedInData li
  INNER JOIN dbo.Tag T
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)
  INNER JOIN dbo.Organization o
    ON (o.id = t.organizationid)
  WHERE o.id = @OrganizationId
  AND EXISTS (SELECT
    *
  FROM McDecisionmakerlist mc
  WHERE mc.DecisionMakerId = li.id
  AND mc.Mode = 'Keyword Based List'
  AND mc.Name IN (SELECT
    SubMarketingList
  FROM #TempSubMarketingList))
  AND Li.ResultantCountry IN (SELECT
    CountryName
  FROM #TempLocation)



  SELECT
    @NoofHiring = COUNT(distinct Ind.id)
  FROM IndeedJobPost ind WITH (NOLOCK),
       Tag t WITH (NOLOCK),
       Organization O WITH (NOLOCK),
       JobPostExcellenceArea JPAE WITH (NOLOCK),
       Country C
  WHERE JPAE.JobPostID = ind.ID
  AND Ind.TagIdOrganization = T.ID
  AND T.OrganizationID = O.id
  AND T.OrganizationID = @OrganizationID
  AND ind.jobdate >= GETDATE() - 180
  AND Ind.CountryCode = C.id
  AND JPAE.ExcellenceArea IN (SELECT
    SubMarketingList
  FROM #TempSubMarketingList)
  AND c.name IN (SELECT
    CountryName
  FROM #TempLocation)


  SELECT
    Ls.SubMarketingListname,
    Ls.CountryName AS [Location],
    LS.revenue,
	o.EmployeeCount,
    i.name AS IndustryName,
    Ls.BudgetScore AS BudgetScore,
    Ls.AuthorityScore,
    Ls.NeedScore AS NeedScore,
    Ls.TimeScore TimingScore,
    LS.TotalScore,
    @DecisionMakersCount NoofDecisionMakers,
    @NoofHiring NoOfHirings,
    @GICCountryList GICCountryList,
	@TeamSize TeamSize
  FROM LeadScoreSubMarketingList LS
  INNER JOIN Organization o
    ON LS.OrganizationID = O.id
  INNER JOIN Industry i
    ON i.Id = o.IndustryId
    AND LS.OrganizationID = @OrganizationID
  WHERE ls.TYPE = 'Non App'
  AND Ls.SubMarketingListNAme IN (SELECT
    SubMarketingList
  FROM #TempSubMarketingList)
  AND ls.CountryName IN (SELECT
    CountryName
  FROM #TempLocation)

DROP TABLE #TempLocation
DROP TABLE #TempSubMarketingList

END
