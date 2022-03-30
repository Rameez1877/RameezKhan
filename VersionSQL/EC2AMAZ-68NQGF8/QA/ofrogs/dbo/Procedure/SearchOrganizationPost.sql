/****** Object:  Procedure [dbo].[SearchOrganizationPost]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SearchOrganizationPost] 
@UserId int = 0,
@Name varchar(150) = NULL,
@IndustryIds varchar(8000) = '',
@CountryIds varchar(8000) = '',
@EmployeeCounts varchar(8000) = '',
@Revenues varchar(8000) = '',
@TechnTagids varchar(8000) = '', -- additional filter for tagid from technographics
@GicCountryIds varchar(8000) = '', -- additional filter for GIC Country Organizations
@Segment varchar(8000) = '' -- Additiona Filter For Segment (Sub Marketing List Name)
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

		 CREATE TABLE #TempResult(
		  Id INT,
        Name VARCHAR(1000),
        Description VARCHAR(MAX),
		WebsiteUrl VARCHAR(200),
        DecisionMakers int,
        LeadScore int,
        SeqNum int,
		CountryName VARCHAR(4000),
IndustryName VARCHAR(4000),
Revenue VARCHAR(4000),
EmployeeCount VARCHAR(4000))

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
        o.Id OrganizationId,
        o.countryid
      FROM linkedindata li WITH (NOLOCK),
           tag t WITH (NOLOCK),
           organization o WITH (NOLOCK),
           McDecisionmakerlist mc WITH (NOLOCK)
      WHERE li.tagid = t.id
      AND t.organizationid = o.id
      AND Li.id = mc.decisionmakerid
      AND mc.mode = 'keyword based list'
 	--  AND li.SeniorityLevel IN ('C-Level', 'Director')
	  AND mc.name  IN (Select Functionality from UserTargetFunctionality WHERE UserId = @UserId )--27jan2020
      AND (li.ResultantCountry)IN (Select Name from UserTargetCountry U, Country C 
	  WHERE UserId = @UserId and u.countryid=c.id )
      AND O.[Name] LIKE '%' + @Name + '%'
     AND (@Segment = '' or mc.name IN (SELECT
        [Data]
      FROM dbo.Split(@Segment, ','))
      )
  --
  -- Technology Filter
  --
  IF @TechnTagids <> ''
  begin
  
  SELECT
        [Data] Technology INTO #TempTech
      FROM dbo.Split(@TechnTagids, ',')

    INSERT INTO #TempOrganization
      SELECT DISTINCT
        tagorg.OrganizationId,
        o.countryid
      FROM Technographics tech WITH (NOLOCK),
           tag tagorg WITH (NOLOCK),
           organization o WITH (NOLOCK)
      WHERE 
	  tech.TagIdOrganization = tagorg.Id
      AND tagorg.OrganizationID = o.id
      AND (tech.keyword IN (SELECT
        StacktechnologyName from techStackTechnology
		 where Stacktechnology in(select technology from #TempTech))
     )
	 drop table #TempTech
	 end 
  --
  -- GIC Organization Filter
  --
  IF @GicCountryIds <> ''
    INSERT INTO #TempOrganization
      SELECT DISTINCT
        OrganizationId,
        o.countryid
      FROM GicOrganization gic,
           organization o WITH (NOLOCK)
      WHERE gic.OrganizationId = o.id
      AND gic.CountryID IN (SELECT
        [Data]
      FROM dbo.Split(@GicCountryIds, ','))

  --
  -- If Advance Filters are more than one, then we have to select common organizations amongst all 
  -- And ignore other organizations and pass these organizations to the main filter of organization table
  -- viz.. Country, Industry, Revenue and Employee Count
  --
  CREATE TABLE #TempChkOrganization (
    OrganizationID int,
    NoofRecords int
  )
  print 'Advance Filter Count :-' + str(@NoOfAdvanceFilters)
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
	begin
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
	
	Print 'No Of Rows In #TempOrganization ' + str(@@Rowcount)


	end 
	
  --
  -- Advance Filter Not Selected
  --
  IF @TechnTagids = ''
    AND @GicCountryIds = ''
   AND @Segment = ''
    IF @AppRoleID <> 3 -- Non demo account
	INSERT INTO #TempResult
	(Id,
Name,
Description,
WebsiteUrl,
DecisionMakers,
LeadScore,
SeqNum,
CountryName, 
IndustryName,
Revenue,
EmployeeCount )
      SELECT
        O.Id,
        O.[Name],
         case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
	     case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
        0 AS DecisionMakers,
        0 AS LeadScore,
        @SeqNum SeqNum,
		c.name,
		i.name,
		o.Revenue,
		o.EmployeeCount
      FROM dbo.Organization O WITH (NOLOCK)
     	INNER JOIN Country C on
		(c.id = o.countryid)
			INNER JOIN Industry i on
		(i.id = o.Industryid)
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
      INSERT INTO #TempResult
	  (Id,
Name,
Description,
WebsiteUrl,
DecisionMakers,
LeadScore,
SeqNum,
CountryName, 
IndustryName,
Revenue,
EmployeeCount )
	  SELECT TOP 50
        O.Id,
        O.[Name],
         case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
		 case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
        0 AS DecisionMakers,
        0 AS LeadScore,
        @SeqNum SeqNum,
		c.name,
		i.name,
		o.Revenue,
		o.EmployeeCount
      FROM dbo.Organization O WITH (NOLOCK)
      		INNER JOIN Country C on
		(c.id = o.countryid)
			INNER JOIN Industry i on
		(i.id = o.Industryid)
    
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
  IF @TechnTagids <> ''
    OR @GicCountryIds <> ''
    OR @Segment <> ''
    IF @AppRoleID <> 3 --Non Demo Account
     
	  WITH cte
      AS (SELECT DISTINCT
        OrganizationID
      FROM #TempOrganization)
	  INSERT INTO #TempResult
	  (Id,
Name,
Description,
WebsiteUrl,
DecisionMakers,
LeadScore,
SeqNum,
CountryName, 
IndustryName,
Revenue,
EmployeeCount )
      SELECT
        O.Id,
        O.[Name],
         case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
	     case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
        0 AS DecisionMakers,
        0 AS LeadScore,
        @SeqNum SeqNum,
		c.name,
		i.name,
		o.Revenue,
		o.EmployeeCount
      FROM dbo.Organization O WITH (NOLOCK)
	  INNER JOIN Country C on
		(c.id = o.countryid)
			INNER JOIN Industry i on
		(i.id = o.Industryid)
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
	  INSERT INTO #TempResult
	  (Id,
Name,
Description,
WebsiteUrl,
DecisionMakers,
LeadScore,
SeqNum,
CountryName, 
IndustryName,
Revenue,
EmployeeCount )
      SELECT TOP 50
        O.Id,
        O.[Name],
         case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end AS [Description],
		 case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
        0 AS DecisionMakers,
        0 AS LeadScore,
        @SeqNum SeqNum ,
		c.name,
		i.name,
		o.Revenue,
		o.EmployeeCount
      FROM dbo.Organization O WITH (NOLOCK)
	  INNER JOIN Country C on
		(c.id = o.countryid)
			INNER JOIN Industry i on
		(i.id = o.Industryid)
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
  -- 10th nov start

 SELECT * FROM #TempResult
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
    FROM organization o WITH (NOLOCK),
         country c
    WHERE o.Name LIKE @Name + '%'
	and o.id in (SELECT ID from #TempResult)
    AND o.countryid = c.id
    AND o.id IN (SELECT
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
    FROM organization o WITH (NOLOCK),
         industry i
    WHERE o.Name LIKE @Name + '%'
    AND o.industryid = i.id
	and o.id in (SELECT ID from #TempResult)
    AND o.id IN (SELECT
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
    FROM organization o WITH (NOLOCK)
    WHERE o.Name LIKE @Name + '%'
	and o.id in (SELECT ID from #TempResult)
    AND o.id IN (SELECT
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
    FROM organization o WITH (NOLOCK)
    WHERE o.Name LIKE @Name + '%'
	and o.id in (SELECT ID from #TempResult)
    AND o.id IN (SELECT
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
  -- 10th nov end 


  DROP TABLE #TempOrganization

  DROP TABLE #TempChkOrganization
  
END
