/****** Object:  Procedure [dbo].[GetHiringDetailSubMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	Janna
-- Create date: 30/10/2019
-- Description:	

-- =============================================
CREATE PROCEDURE [dbo].[GetHiringDetailSubMarketingList] 
@OrganizationID int,
@Location VARCHAR(8000),
@SubMarketingList VARCHAR(8000)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  --CREATE TABLE #TempLocation (
  --  CountryName varchar(100)
  --)
  --IF @Location = '' or @Location is null
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

  --IF @SubMarketingList = '' or @SubMarketingList is null
  --  INSERT INTO #TempSubMarketingList
  --    SELECT
  --      SubMarketingListNameDisplay
  --    FROM v_marketinglist
  --ELSE
  --  INSERT INTO #TempSubMarketingList
  --    SELECT
  --      [Data]
  --    FROM dbo.Split(@SubMarketingList, ',')

SELECT DISTINCT
  o.name AS CompanyName,
  JPAE.ExcellenceArea AS FocusArea,
  ind.url,
  ind.JobTitle,
  c.name AS Location,
  ind.Summary,
  ind.SeniorityLevel
FROM IndeedJobPost ind with (NOLOCK),
     Tag t with (NOLOCK),
     Organization O with (NOLOCK),
     JobPostExcellenceArea JPAE with (NOLOCK),
	 country c
WHERE JPAE.JobPostID = ind.ID
AND Ind.TagIdOrganization = T.ID
AND T.OrganizationID = O.id
AND T.OrganizationID = @OrganizationID
AND ind.jobdate >= getdate() - 180
and Ind.CountryCode = c.id
And C.Name = @Location  --(Select CountryName from #TempLocation)
and JPAE.ExcellenceArea = @SubMarketingList -- in (Select SubMarketingList from #TempSubMarketingList)

--DROP TABLE #TempLocation
--DROP TABLE #TempSubMarketingList

END
