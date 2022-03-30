/****** Object:  Procedure [dbo].[OptmizedSearchWebsiteNavigationTP]    Committed by VersionSQL https://www.versionsql.com ******/

/* 
EXEC [OptmizedSearchWebsiteNavigationTP] 159,'','','','','','','Lavu'
*/
CREATE PROCEDURE [dbo].[OptmizedSearchWebsiteNavigationTP]
@UserID int,
@CountryIds varchar(8000) = '',
@IndustryIds varchar(8000) = '',
@Revenues varchar(8000) = '',
@Products varchar(8000) = '',
@Solutions varchar(8000) = '',
@Team varchar(8000) = '',
@OrgName varchar(800)= ''
AS

BEGIN
  SET NOCOUNT ON;
  
	Declare @AppRoleID INT, 
	@Limit INT

	SELECT @AppRoleID = AppRoleID
	FROM AppUser 
	WHERE ID = @UserID

	SET @Limit = IIF(@AppRoleID = 3,200,5000)
	IF @OrgName = '' 
	BEGIN
      SELECT DISTINCT
      o.id,
      o.name AS OrganizationName,
       case when len(o.WebsiteDescription) < 3 then o.glassdoordescription 
	   else o.WebsiteDescription end WebsiteDescription,
	  WNS.KeyWordCount,
	  WNS.KeywordScore, 
	  c.name as CountryName,
      i.name as IndustryName,
	  o.Revenue,
	  o.WebsiteURL,
	  SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
	  WNS.product,
	  WNS.solution,
	  WNS.segment 
    FROM WebsitenavigationSegment WNS  with (nolock) 
	inner join WebsiteOrganizationMapping WOP   with (nolock)
	on (WOP.WebsiteID = WNS.WebsiteID)
    INNER JOIN WebsiteIntentKeywordCategory WC   with (nolock)
    on (WC.ID = WNS.WebsiteIntentKeywordCategoryID)
	INNER JOIN Organization O  with (nolock) on  (O.ID = WOP.OrganizationId)
	INNER JOIN Country C on (c.id = o.CountryID)
	INNER JOIN Industry i on (i.id = o.IndustryID)
	LEFT JOIN cache.OrganizationTeams OT ON OT.OrganizationId = O.Id
    WHERE 
	 (@IndustryIds = ''
    OR O.IndustryId IN (SELECT
      [Data]
    FROM dbo.Split(@IndustryIds, ','))
    )
    AND (@CountryIds = ''
    OR O.CountryId IN (SELECT
      [Data]
    FROM dbo.Split(@CountryIds, ','))
    )
    AND (@Revenues = ''
    OR O.Revenue IN (SELECT
      [Data]
    FROM dbo.Split(@Revenues, ','))
    )
	 AND (@Products = ''
    OR WNS.Product IN (SELECT
      [Data]
    FROM dbo.Split(@Products, ','))
    )
	 AND (@Solutions = ''
    OR WNS.Solution IN (SELECT
      [Data]
    FROM dbo.Split(@Solutions, ','))
    )
	AND WNS.ISACTIVE = 1
	AND (@Team = '' OR 
	OT.TeamName IN (SELECT
      [Data]
    FROM dbo.Split(@Team, ','))
    )
	END
	ELSE
	BEGIN
	 SELECT DISTINCT
      o.id,
      o.name AS OrganizationName,
       case when len(o.WebsiteDescription) < 3 then o.glassdoordescription 
	   else o.WebsiteDescription end WebsiteDescription,
	  WNS.KeyWordCount,
	  WNS.KeywordScore, 
	  c.name as CountryName,
      i.name as IndustryName,
	  o.Revenue,
	  o.WebsiteURL,
	  SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
	  WNS.product,
	  WNS.solution,
	  WNS.segment 
    FROM WebsitenavigationSegment WNS  with (nolock) 
	inner join WebsiteOrganizationMapping WOP   with (nolock)
	on (WOP.WebsiteID = WNS.WebsiteID)
    INNER JOIN WebsiteIntentKeywordCategory WC   with (nolock)
    on (WC.ID = WNS.WebsiteIntentKeywordCategoryID)
	INNER JOIN Organization O  with (nolock) on  (O.ID = WOP.OrganizationId)
	INNER JOIN Country C on (c.id = o.CountryID)
	INNER JOIN Industry i on (i.id = o.IndustryID)
	WHERE WNS.IsActive = 1
	AND O.Name = @OrgName
	END

  -- Old Query
  --DECLARE @SeqNum int,
  --        @NoofAdvanceFilter int

	--INSERT INTO CompanySearches(UserId,IndustryIds,CountryIds,Revenues,Products,Solutions,Teams) 
	--VALUES (@UserId,  
	--					@IndustryIds,
	--					@CountryIds,
	--					@Revenues,
	--					@Products,
	--					@Solutions,
	--					@Team);

--  SET @NoofAdvanceFilter = 0

--  CREATE TABLE #TempOrganization (
--    OrganizationID int
--  )

--  CREATE TABLE #tempresult (
--	 Id int,
--    OrganizationName varchar(1000),
--    WebsiteDescription varchar(max),
--    SeqNum int,
--	KeywordCount Int,
--	KeywordScore Int,
--	CountryName varchar(1000),
--	IndustryName varchar(4000),
--	Revenue varchar(1000), ----
--	WebsiteURL varchar(2000),
--	Domain varchar(100),
--	product varchar(max),
--	solution varchar(max),
--	segment varchar(1000)
--  )
--   --
--  -- Advance Filter
--  --
--  If @Team <> ''
--  begin

--  SET @NoofAdvanceFilter = @NoofAdvanceFilter +1
  
--  INSERT INTO #TempOrganization
--  select id from organization with (nolock)


-- print '1'
--  end
  
--  SELECT
--    @SeqNum = NEXT VALUE FOR Seq_Targetpersona;

--If @NoofAdvanceFilter = 0 
--  INSERT INTO #tempresult
--    SELECT
--      o.id,
--      o.name AS OrganizationName,
--       case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end WebsiteDescription,
--      @SeqNum SeqNum,
--	  WNS.KeyWordCount,
--	  WNS.KeywordScore, 
--	  c.name as CountryName,
--      i.name as IndustryName,
--	  o.Revenue,
--	  o.WebsiteURL,
--	  SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
--			LEN(O.WebsiteUrl)) AS [Domain],
--	  WNS.product,
--	  WNS.solution,
--	  WNS.segment
--    FROM WebsitenavigationSegment WNS  with (nolock) 
--	inner join WebsiteOrganizationMapping WOP   with (nolock)
--	on (WOP.WebsiteID = WNS.WebsiteID)
--    INNER JOIN WebsiteIntentKeywordCategory WC   with (nolock)
--    on (WC.ID = WNS.WebsiteIntentKeywordCategoryID)
--	INNER JOIN Organization O  with (nolock) on  (O.ID = WOP.OrganizationId)
--	INNER JOIN Country C on (c.id = o.CountryID)
--	INNER JOIN Industry i on (i.id = o.IndustryID)
--    WHERE 
--	 (@IndustryIds = ''
--    OR O.IndustryId IN (SELECT
--      [Data]
--    FROM dbo.Split(@IndustryIds, ','))
--    )
--    AND (@CountryIds = ''
--    OR O.CountryId IN (SELECT
--      [Data]
--    FROM dbo.Split(@CountryIds, ','))
--    )
--    AND (@Revenues = ''
--    OR O.Revenue IN (SELECT
--      [Data]
--    FROM dbo.Split(@Revenues, ','))
--    )
--	 AND (@Products = ''
--    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
--      [Data]
--    FROM dbo.Split(@Products, ','))
--    )
--	 AND (@Solutions = ''
--    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
--      [Data]
--    FROM dbo.Split(@Solutions, ','))
--    )
--	AND WNS.WebsiteIntentKeywordCategoryID in
--	(select WebsiteSolutionGroupID from UserTargetWebsiteSolutionGroup 
--	UNION
--	select WebsiteProductGroupID from UserTargetWebsiteProductGroup 
--	)
--	AND WNS.ISACTIVE = 1
			  
--ELSE
-- INSERT INTO #tempresult
--    SELECT
--      o.id,
--      o.name AS OrganizationName,
--      case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end WebsiteDescription ,
--      @SeqNum SeqNum,
--	  WNS.KeyWordCount,
--	  WNS.KeywordScore, 
--	  C.name as CountryName,
--      i.name as IndustryName,
--	  o.Revenue,
--	  o.WebsiteURL,
--	  	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
--			LEN(O.WebsiteUrl)) AS [Domain],
--	  WNS.product,
--	  WNS.solution,
--	  WNS.segment
--    FROM WebsitenavigationSegment WNS  with (nolock) 
--	inner join WebsiteOrganizationMapping WOP  with (nolock) on (WOP.WebsiteID = WNS.WebsiteID)
--         INNER JOIN WebsiteIntentKeywordCategory WC  with (nolock) on (WC.ID = WNS.WebsiteIntentKeywordCategoryID)
--		 INNER JOIN Organization O  with (nolock)  on  (O.ID = WOP.OrganizationId)
--		 INNER JOIN Country C on (c.id = o.CountryID)
--	INNER JOIN Industry i on (i.id = o.IndustryID)
	
--		 INNER JOIN #TempOrganization o1 on ( O.ID = o1.OrganizationId)
--    WHERE
--	(@IndustryIds = ''
--    OR O.IndustryId IN (SELECT
--      [Data]
--    FROM dbo.Split(@IndustryIds, ','))
--    )
--    AND (@CountryIds = ''
--    OR O.CountryId IN (SELECT
--      [Data]
--    FROM dbo.Split(@CountryIds, ','))
--    )
--    AND (@Revenues = ''
--    OR O.Revenue IN (SELECT
--      [Data]
--    FROM dbo.Split(@Revenues, ','))
--    )
--	 AND (@Products = ''
--    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
--      [Data]
--    FROM dbo.Split(@Products, ','))
--    )
--	 AND (@Solutions = ''
--    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
--      [Data]
--    FROM dbo.Split(@Solutions, ','))
--    )
--	AND WNS.WebsiteIntentKeywordCategoryID in
--	(select WebsiteSolutionGroupID from UserTargetWebsiteSolutionGroup 
--	UNION
--	select WebsiteProductGroupID from UserTargetWebsiteProductGroup 
--	)
--	AND WNS.ISACTIVE = 1
			
--		print '4'	 
--select * from #tempresult where id is not null  order by KeyWordScore desc

--print '5'
--  --
--  -- graph
--  --

--  INSERT INTO StgGraphTargetPersona (SequenceNo,
--  DataType,
--  DataString,
--  DataValue)
--    SELECT
--      @SeqNum,
--      'HQ',
--      c.name,
--      COUNT(*)
--    FROM organization o WITH (NOLOCK),
--         country c
--    WHERE o.id IN (SELECT
--      id
--    FROM #TempResult)
--    AND o.countryid = c.id
--    GROUP BY c.name

--  INSERT INTO StgGraphTargetPersona (SequenceNo,
--  DataType,
--  DataString,
--  DataValue)
--    SELECT
--      @SeqNum,
--      'Industry',
--      i.name,
--      COUNT(*)
--    FROM organization o WITH (NOLOCK),
--         industry i
--    WHERE o.industryid = i.id
--    AND o.id IN (SELECT
--      id
--    FROM #TempResult)
--    GROUP BY i.name

--  INSERT INTO StgGraphTargetPersona (SequenceNo,
--  DataType,
--  DataString,
--  DataValue)
--    SELECT
--      @SeqNum,
--      'Revenue',
--      o.revenue,
--      COUNT(*)
--    FROM organization o WITH (NOLOCK)
--    WHERE o.id IN (SELECT
--      id
--    FROM #TempResult)
--    GROUP BY o.revenue
--	print '6'
END
