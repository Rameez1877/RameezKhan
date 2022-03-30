/****** Object:  Procedure [dbo].[InsertCustomerTargetPersonaOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[InsertCustomerTargetPersonaOrganization] @UserId int = 0,
@Name varchar(150) = NULL,
@IndustryIds varchar(8000) = '',
@CountryIds varchar(8000) = '',
@EmployeeCounts varchar(8000) = '',
@Revenues varchar(8000) = '',
@TechnTagids varchar(8000) = '', -- additional filter for tagid from technographics
@GicCountryIds varchar(8000) = '', -- additional filter for GIC Country Organizations
@Segment varchar(8000) = '', -- Additiona Filter For Segment (Sub Marketing List Name)
@Coe varchar(8000) = '',  -- Additional filter for Organization with Coe
@TargetPersonaID int
AS
-- =============================================      
-- Author:  Anurag Gandhi      
-- Create date: 31 May, 2019      
-- Updated date: 31 May, 2019      
-- Description: Gets the Decision makers for Decision makers page.//      
-- =============================================      
BEGIN
  SET NOCOUNT ON
  DECLARE @SeqNum int,
          @NoOfAdvanceFilters int = 0,
          @AppRoleID int
  --PRINT '1:' + (CONVERT(varchar(24), GETDATE(), 121))
  CREATE TABLE #TempResult (
    Id int
  )
  

  --PRINT '2:' + (CONVERT(varchar(24), GETDATE(), 121))
  --
  -- Count the Number Of Advance Filters Selected Start
  --
  IF @TechnTagids <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
  IF @GicCountryIds <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
  IF @Segment <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
  IF @Coe <> ''
    SET @NoOfAdvanceFilters = @NoOfAdvanceFilters + 1
  --
  -- Count the Number Of Advance Filters Selected End
  --

  CREATE TABLE #TempOrganization (
    OrganizationId int,
    CountryID int
  )
  --
  -- Decide whether the user is demo account or normal account, needed to restrict number of rows passed to front end
  --
  SELECT
    @AppRoleID = AppRoleID
  FROM AppUser
  WHERE Id = @UserId
  --
  -- Segment Filter (Sub Marketing List Name)
  --
  --PRINT '2.1:' + (CONVERT(varchar(24), GETDATE(), 121))
  IF @Segment <> ''

    INSERT INTO #TempOrganization (OrganizationId,
    CountryID)
      SELECT DISTINCT
        o.OrganizationId,
        o.countryid
      FROM linkedindata li WITH (NOLOCK),
           tag t WITH (NOLOCK),
           OrganizationWithDM o WITH (NOLOCK),
           McDecisionmakerlist mc WITH (NOLOCK)
      WHERE li.tagid = t.id
      AND t.organizationid = o.organizationid
      AND Li.id = mc.decisionmakerid
      AND mc.mode = 'keyword based list'
      AND mc.name IN (SELECT
        Functionality
      FROM UserTargetFunctionality
      WHERE UserId = @UserId)
      AND (li.ResultantCountry) IN (SELECT
        Name
      FROM UserTargetCountry U,
           Country C
      WHERE UserId = @UserId
      AND u.countryid = c.id)
      AND O.[Name] LIKE '%' + @Name + '%'
      AND (@Segment = ''
      OR mc.name IN (SELECT
        [Data]
      FROM dbo.Split(@Segment, ','))
      )

  --PRINT '2.2:' + (CONVERT(varchar(24), GETDATE(), 121))
  --
  -- Technology Filter
  --
  IF @TechnTagids <> ''
  BEGIN

    SELECT
      [Data] Technology INTO #TempTech
    FROM dbo.Split(@TechnTagids, ',')

    INSERT INTO #TempOrganization
      SELECT DISTINCT
        tagorg.OrganizationId,
        o.countryid
      FROM Technographics tech WITH (NOLOCK),
           tag tagorg WITH (NOLOCK),
           OrganizationWithDM o WITH (NOLOCK)
      WHERE tech.TagIdOrganization = tagorg.Id
      AND tagorg.OrganizationID = o.OrganizationID
      AND tech.keyword IN (SELECT
        technology
      FROM #TempTech)

    DROP TABLE #TempTech
  END
  --PRINT '2.3:' + (CONVERT(varchar(24), GETDATE(), 121))
  --
  -- GIC Organization Filter
  --
  IF @GicCountryIds <> ''
    INSERT INTO #TempOrganization
      SELECT DISTINCT
        o.OrganizationId,
        o.countryid
      FROM GicOrganization gic,
           OrganizationWithDM o WITH (NOLOCK)
      WHERE gic.OrganizationId = o.OrganizationId
      AND gic.CountryID IN (SELECT
        [Data]
      FROM dbo.Split(@GicCountryIds, ','))

  --
  -- COE Organization Filter
  --
  --PRINT '2.4:' + (CONVERT(varchar(24), GETDATE(), 121))
  IF @Coe <> ''
    WITH cte1
    AS (SELECT
      o.id,
      COUNT(DISTINCT (m.name)) AS "No of MarketingList"
    FROM LinkedInData l WITH (NOLOCK),
         McDecisionmakerlist m WITH (NOLOCK),
         tag t WITH (NOLOCK),
         Organization o WITH (NOLOCK)
    WHERE m.DecisionMakerId = l.id
    AND t.Id = l.TagId
    AND o.Id = t.OrganizationId
    AND (m.Name IN ('Centre Of Excellence')
    OR (@coe = ''
    OR m.name IN (SELECT
      [Data]
    FROM dbo.Split(@Coe, ','))
    ))
    AND t.TagTypeId = 1
    AND l.TagId <> 0
    GROUP BY o.id
    HAVING COUNT(DISTINCT (m.name)) = LEN(@COE) - LEN(REPLACE(@coe, ',', '')) + 2)

    --------
    INSERT INTO #TempOrganization
      SELECT DISTINCT
        o.id AS OrganizationId,
        o.countryid
      FROM cte1 tc,
           organization o WITH (NOLOCK)
      WHERE o.id = tc.id
      AND o.Id IN (SELECT
        OrganizationID
      FROM OrganizationWithDM)

  --PRINT '3:' + (CONVERT(varchar(24), GETDATE(), 121))
  --
  -- If Advance Filters are more than one, then we have to select common organizations amongst all 
  -- And ignore other organizations and pass these organizations to the main filter of organization table
  -- viz.. Country, Industry, Revenue and Employee Count
  --
  CREATE TABLE #TempChkOrganization (
    OrganizationID int,
    NoofRecords int
  )

  IF @NoOfAdvanceFilters > 1
  BEGIN
    INSERT INTO #TempChkOrganization
      SELECT
        OrganizationId,
        COUNT(*)
      FROM #TempOrganization
      GROUP BY OrganizationId
      HAVING COUNT(*) >= @NoOfAdvanceFilters

    DELETE FROM #TempOrganization
    WHERE OrganizationId NOT IN (SELECT
        OrganizationId
      FROM #TempChkOrganization)
  END
  --PRINT '4:' + (CONVERT(varchar(24), GETDATE(), 121))
  IF @TechnTagids = ''
    AND @GicCountryIds = ''
    AND @Segment = ''
    AND @Coe = ''
  BEGIN
    INSERT INTO #TempOrganization
      SELECT --DISTINCT
        id OrganizationId,
        countryid
      FROM dbo.Organization O WITH (NOLOCK)

      WHERE [Name] LIKE @Name + '%'
      AND (@IndustryIds = ''
      OR O.IndustryId IN (SELECT
        [Data]
      FROM dbo.Split(@IndustryIds, ','))
      )
      AND (@CountryIds = ''
      OR O.CountryId IN (SELECT
        [Data]
      FROM dbo.Split(@CountryIds, ','))
      )
      AND (@EmployeeCounts = ''
      OR O.EmployeeCount IN (SELECT
        [Data]
      FROM dbo.Split(@EmployeeCounts, ','))
      )
      AND (@Revenues = ''
      OR O.Revenue IN (SELECT
        [Data]
      FROM dbo.Split(@Revenues, ','))
      )

    --PRINT 'No Of Rows In #TempOrganization ' + STR(@@Rowcount)


  END
  --PRINT '5:' + (CONVERT(varchar(24), GETDATE(), 121))
  --
  -- Advance Filter Not Selected
  --
  IF @TechnTagids = ''
    AND @GicCountryIds = ''
    AND @Segment = ''
    AND @Coe = ''
    IF @AppRoleID <> 3 -- Non demo account
      INSERT INTO #TempResult (Id)
        SELECT
          O.Id
        FROM dbo.Organization O WITH (NOLOCK)
        INNER JOIN Country C
          ON (c.id = o.countryid)
        INNER JOIN Industry i
          ON (i.id = o.Industryid)
        WHERE o.Name LIKE @Name + '%'
        AND (@IndustryIds = ''
        OR O.IndustryId IN (SELECT
          [Data]
        FROM dbo.Split(@IndustryIds, ','))
        )
        AND (@CountryIds = ''
        OR O.CountryId IN (SELECT
          [Data]
        FROM dbo.Split(@CountryIds, ','))
        )
        AND (@EmployeeCounts = ''
        OR O.EmployeeCount IN (SELECT
          [Data]
        FROM dbo.Split(@EmployeeCounts, ','))
        )
        AND (@Revenues = ''
        OR O.Revenue IN (SELECT
          [Data]
        FROM dbo.Split(@Revenues, ','))
        )

    ELSE  -- Demo account restricted to 50 records
      INSERT INTO #TempResult (Id)
        SELECT TOP 50
          O.Id
        FROM dbo.Organization O WITH (NOLOCK)
        INNER JOIN Country C
          ON (c.id = o.countryid)
        INNER JOIN Industry i
          ON (i.id = o.Industryid)

        WHERE o.Name LIKE @Name + '%'
        AND (@IndustryIds = ''
        OR O.IndustryId IN (SELECT
          [Data]
        FROM dbo.Split(@IndustryIds, ','))
        )
        AND (@CountryIds = ''
        OR O.CountryId IN (SELECT
          [Data]
        FROM dbo.Split(@CountryIds, ','))
        )
        AND (@EmployeeCounts = ''
        OR O.EmployeeCount IN (SELECT
          [Data]
        FROM dbo.Split(@EmployeeCounts, ','))
        )
        AND (@Revenues = ''
        OR O.Revenue IN (SELECT
          [Data]
        FROM dbo.Split(@Revenues, ','))
        )
  --For demo account order by Decision Maker Count as No Lead Score is available/18/10/19 Janna
  -- ORDER BY D.DecisionMakersCount DESC
  --
  -- Advance Filter Selected
  --
  --PRINT '6:' + (CONVERT(varchar(24), GETDATE(), 121))
  IF @TechnTagids <> ''
    OR @GicCountryIds <> ''
    OR @Segment <> ''
    OR @Coe <> ''
    IF @AppRoleID <> 3 --Non Demo Account
      WITH cte
      AS (SELECT DISTINCT
        OrganizationID
      FROM #TempOrganization)
      INSERT INTO #TempResult (Id)
        SELECT
          O.Id
        FROM dbo.Organization O WITH (NOLOCK)
        INNER JOIN Country C
          ON (c.id = o.countryid)
        INNER JOIN Industry i
          ON (i.id = o.Industryid)
        INNER JOIN cte
          ON o.id = cte.OrganizationId
        WHERE o.Name LIKE @Name + '%'
        AND (@IndustryIds = ''
        OR O.IndustryId IN (SELECT
          [Data]
        FROM dbo.Split(@IndustryIds, ','))
        )
        AND (@CountryIds = ''
        OR O.CountryId IN (SELECT
          [Data]
        FROM dbo.Split(@CountryIds, ','))
        )
        AND (@EmployeeCounts = ''
        OR O.EmployeeCount IN (SELECT
          [Data]
        FROM dbo.Split(@EmployeeCounts, ','))
        )
        AND (@Revenues = ''
        OR O.Revenue IN (SELECT
          [Data]
        FROM dbo.Split(@Revenues, ','))
        )

    ELSE--Demo Account

      WITH cte
      AS (SELECT DISTINCT
        OrganizationID
      FROM #TempOrganization)
      INSERT INTO #TempResult (Id)
        SELECT TOP 50
          O.Id
        FROM dbo.Organization O WITH (NOLOCK)
        INNER JOIN Country C
          ON (c.id = o.countryid)
        INNER JOIN Industry i
          ON (i.id = o.Industryid)
        INNER JOIN cte
          ON o.id = cte.OrganizationId
        WHERE o.Name LIKE @Name + '%'
        AND (@IndustryIds = ''
        OR O.IndustryId IN (SELECT
          [Data]
        FROM dbo.Split(@IndustryIds, ','))
        )
        AND (@CountryIds = ''
        OR O.CountryId IN (SELECT
          [Data]
        FROM dbo.Split(@CountryIds, ','))
        )
        AND (@EmployeeCounts = ''
        OR O.EmployeeCount IN (SELECT
          [Data]
        FROM dbo.Split(@EmployeeCounts, ','))
        )
        AND (@Revenues = ''
        OR O.Revenue IN (SELECT
          [Data]
        FROM dbo.Split(@Revenues, ','))
        )
  --PRINT '7:' + (CONVERT(varchar(24), GETDATE(), 121))
  --SELECT DISTINCT
  --  id
  --FROM #TempResult
  INSERT INTO TargetPersonaOrganization (TargetPersonaID,
  OrganizationID)
    SELECT DISTINCT
      @TargetPersonaID,
      id
    FROM #TempResult

  --PRINT '8:' + (CONVERT(varchar(24), GETDATE(), 121))
  DROP TABLE #TempOrganization

  DROP TABLE #TempChkOrganization
END
