/****** Object:  Procedure [dbo].[GetDecisionMakersForSubMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: 30/Oct/2019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForSubMarketingList]
-- Add the parameters for the stored procedure here
@OrganizationId int,
@Location varchar(8000),
@SubMarketingList varchar(8000)
AS
BEGIN
  SET NOCOUNT ON;

  --CREATE TABLE #TempLocation (
  --  CountryName varchar(100)
  --)
  --IF @Location = ''
  --  OR @Location IS NULL
  --  INSERT INTO #TempLocation
  --    SELECT
  --      Name
  --    FROM Country
	 -- where name in ('India', 'United States Of America', 'Singapore', 'Australia',
	 --  'Canada', 'United Kingdom', 'Malaysia', 'Saudi Arabia', 'United Arab Emirates')
  --ELSE
  --  INSERT INTO #TempLocation
  --    SELECT
  --      [Data]
  --    FROM dbo.Split(@Location, ',')

  --CREATE TABLE #TempSubMarketingList (
  --  SubMarketingList varchar(100)
  --)

  --IF @SubMarketingList = ''
  --  OR @SubMarketingList IS NULL
  --  INSERT INTO #TempSubMarketingList
  --    SELECT
  --      SubMarketingListNameDisplay
  --    FROM v_marketinglist
  --ELSE
  --  INSERT INTO #TempSubMarketingList
  --    SELECT
  --      [Data]
  --    FROM dbo.Split(@SubMarketingList, ',')

  SELECT
    li.FirstName,
    li.LastName,
    li.designation,
	Mc.name as SubMarketingList,
    li.ResultantCountry AS country,
    li.url
 FROM LinkedInData li
  INNER JOIN McDecisionMakerList Mc
    ON (Li.id = mc.DecisionmakerID)
  INNER JOIN dbo.Tag T
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)
  INNER JOIN dbo.Organization o
    ON (o.id = t.organizationid)
  WHERE o.id = @OrganizationId
  AND mc.mode = 'Keyword Based List'
  AND mc.Name = @SubMarketingList
  --IN (SELECT
  --  SubMarketingList
  --FROM #TempSubMarketingList)
  AND Li.ResultantCountry = @Location
  -- IN (SELECT
  --  CountryName
  --FROM #TempLocation)
  and Li.SeniorityLevel in ('C-Level','Director')
  --AND  li.SeniorityLevel IN (select seniority from UserTargetSeniority where userid=@UserId)
  	  
--DROP TABLE #TempLocation
--DROP TABLE #TempSubMarketingList

END
