/****** Object:  Procedure [dbo].[GetCustomerTargetPersonaDetail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetCustomerTargetPersonaDetail] @UserId int,
@Name varchar(150) = '',
@IndustryIds varchar(8000) = '',
@CountryIds varchar(8000) = '',
@EmployeeCounts varchar(8000) = '',
@Revenues varchar(8000) = '',
@TechnTagids varchar(8000) = '', -- additional filter for tagid from technographics
@GicCountryIds varchar(8000) = '', -- additional filter for GIC Country Organizations
@Segment varchar(8000) = '', -- Additional Filter For Segment (Sub Marketing List Name)
@Coe varchar(8000) = '',  -- Additional filter for Organization with Coe
@Page Int =1,
@PageSize Int =50
AS
-- =============================================      
-- Author:  Janna     
-- Create date: 10 Apr, 2020   
-- Description: Get Customer Target Persona Organziation Data  
-- =============================================      
BEGIN
  SET NOCOUNT ON
  DECLARE @SeqNum int,
          @NoOfAdvanceFilters int = 0,
          @AppRoleID int

  CREATE TABLE #TempResult (
    Id int,
    Name varchar(1000),
    Description varchar(max),
    WebsiteUrl varchar(200),
    DecisionMakers int,
    LeadScore int,
    SeqNum int,
    CountryName varchar(4000),
    IndustryName varchar(4000),
    Revenue varchar(4000),
    EmployeeCount varchar(4000),
	TotalRecords Int)
	 
  --
  -- Unique Sequence Number So that the dront end use this number for querying graph. This  Sequence Number is out parameter
  --
  SELECT
    @SeqNum = NEXT VALUE FOR Seq_Targetpersona;
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
      WHERE UserId = @UserId)--27jan2020
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
      AND (tech.keyword IN (SELECT
        StacktechnologyName
      FROM techStackTechnology
      WHERE Stacktechnology IN (SELECT
        technology
      FROM #TempTech))
      )
    DROP TABLE #TempTech
  END
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
      WHERE gic.OrganizationId = o.OrganizationID
      AND gic.CountryID IN (SELECT
        [Data]
      FROM dbo.Split(@GicCountryIds, ','))

  --
  -- COE Organization Filter
  --

  IF @Coe <> ''
    WITH cte1
    AS (SELECT
      o.OrganizationID,
      COUNT(DISTINCT (m.name)) AS "No of MarketingList"
    FROM LinkedInData l WITH (NOLOCK),
         McDecisionmakerlist m WITH (NOLOCK),
         tag t WITH (NOLOCK),
         OrganizationWithDM o WITH (NOLOCK)
    WHERE m.DecisionMakerId = l.id
    AND t.Id = l.TagId
    AND o.OrganizationID = t.OrganizationId
    AND (m.Name IN ('Centre Of Excellence')
    OR (@coe = ''
    OR m.name IN (SELECT
      [Data]
    FROM dbo.Split(@Coe, ','))
    ))
    AND t.TagTypeId = 1
    AND l.TagId <> 0
    GROUP BY o.OrganizationID
    HAVING COUNT(DISTINCT (m.name)) = LEN(@COE) - LEN(REPLACE(@coe, ',', '')) + 2)
    --------
    INSERT INTO #TempOrganization
      SELECT DISTINCT
        o.OrganizationId,
        o.countryid
      FROM cte1 tc,
           OrganizationWithDM o WITH (NOLOCK)
      WHERE o.organizationid = tc.OrganizationID

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


  IF @TechnTagids = ''
    AND @GicCountryIds = ''
    AND @Segment = ''
    AND @Coe = ''
  BEGIN
 
    INSERT INTO #TempOrganization
      SELECT --DISTINCT
        OrganizationId,
        countryid
      FROM OrganizationWithDM o
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

  END

  --
  -- Advance Filter Not Selected
  --
  IF @TechnTagids = ''
    AND @GicCountryIds = ''
    AND @Segment = ''
    AND @Coe = ''
   begin
      INSERT INTO #TempResult (Id,
      Name,
      Description,
      WebsiteUrl,
      DecisionMakers,
      LeadScore,
      SeqNum,
      CountryName,
      IndustryName,
      Revenue,
      EmployeeCount,
	  TotalRecords)
        SELECT
          O.Id,
          O.[Name],
          CASE
            WHEN LEN(o.Description) < 3 THEN o.glassdoordescription
            ELSE o.Description
          END AS [Description],
          CASE
            WHEN O.WebsiteUrl LIKE '%https%' THEN O.WebsiteUrl
            ELSE 'https://' + O.WebsiteUrl
          END WebsiteUrl,
          0 AS DecisionMakers,
          0 AS LeadScore,
          @SeqNum SeqNum,
          c.name,
          i.name,
          o.Revenue,
          o.EmployeeCount,
		  count(*) over()
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
		 ORDER BY O.[Name]
		OFFSET @Page-1 ROWS FETCH NEXT @PageSize ROWS ONLY
      
end
  --
  -- Advance Filter Selected
  --
  IF @TechnTagids <> ''
    OR @GicCountryIds <> ''
    OR @Segment <> ''
    OR @Coe <> ''

    WITH cte
    AS (SELECT DISTINCT
      OrganizationID
    FROM #TempOrganization)
    INSERT INTO #TempResult (Id,
    Name,
    Description,
    WebsiteUrl,
    DecisionMakers,
    LeadScore,
    SeqNum,
    CountryName,
    IndustryName,
    Revenue,
    EmployeeCount,
	TotalRecords)
      SELECT
        O.organizationid,
        O.[Name],
        CASE
          WHEN LEN(o.Description) < 3 THEN o.glassdoordescription
          ELSE o.Description
        END AS [Description],
        CASE
          WHEN O.WebsiteUrl LIKE '%https%' THEN O.WebsiteUrl
          ELSE 'https://' + O.WebsiteUrl
        END WebsiteUrl,
        0 AS DecisionMakers,
        0 AS LeadScore,
        @SeqNum SeqNum,
        c.name,
        i.name,
        o.Revenue,
        o.EmployeeCount,
		count(*) over()
      FROM OrganizationWithDM O WITH (NOLOCK)
      INNER JOIN Country C
        ON (c.id = o.countryid)
      INNER JOIN Industry i
        ON (i.id = o.Industryid)
      INNER JOIN cte
        ON o.OrganizationId = cte.OrganizationId
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
       ORDER BY O.[Name]
		OFFSET @Page-1 ROWS FETCH NEXT @PageSize ROWS ONLY

  SELECT
    *
  FROM #TempResult
  --
  -- Graph Data starts
  --
  INSERT INTO StgGraphTargetPersona (SequenceNo,
  DataType,
  DataString,
  DataValue)
    SELECT
      @SeqNum,
      'HQ',
      c.name,
      COUNT(*)
    FROM OrganizationWithDM o WITH (NOLOCK),
         country c
    WHERE o.Name LIKE @Name + '%'
    AND o.organizationid IN (SELECT
      ID
    FROM #TempResult)
    AND o.countryid = c.id
    AND o.organizationid IN (SELECT
      OrganizationID
    FROM #TempOrganization)
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
    GROUP BY c.name

  INSERT INTO StgGraphTargetPersona (SequenceNo,
  DataType,
  DataString,
  DataValue)
    SELECT
      @SeqNum,
      'Industry',
      i.name,
      COUNT(*)
    FROM OrganizationWithDM o WITH (NOLOCK),
         industry i
    WHERE o.Name LIKE @Name + '%'
    AND o.industryid = i.id
    AND o.organizationid IN (SELECT
      ID
    FROM #TempResult)
    AND o.organizationid IN (SELECT
      OrganizationID
    FROM #TempOrganization)
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
    GROUP BY i.name

  INSERT INTO StgGraphTargetPersona (SequenceNo,
  DataType,
  DataString,
  DataValue)
    SELECT
      @SeqNum,
      'Revenue',
      o.revenue,
      COUNT(*)
    FROM OrganizationWithDM o WITH (NOLOCK)
    WHERE o.Name LIKE @Name + '%'
    AND o.organizationid IN (SELECT
      ID
    FROM #TempResult)
    AND o.organizationid IN (SELECT
      OrganizationID
    FROM #TempOrganization)
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
    GROUP BY o.revenue

  INSERT INTO StgGraphTargetPersona (SequenceNo,
  DataType,
  DataString,
  DataValue)
    SELECT
      @SeqNum,
      'Emp Count',
      o.employeecount,
      COUNT(*)
    FROM OrganizationWithDM o WITH (NOLOCK)
    WHERE o.Name LIKE @Name + '%'
    AND o.organizationid IN (SELECT
      ID
    FROM #TempResult)
    AND o.organizationid IN (SELECT
      OrganizationID
    FROM #TempOrganization)
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
    GROUP BY o.employeecount

  DROP TABLE #TempOrganization
  DROP TABLE #TempChkOrganization

END
