/****** Object:  Procedure [dbo].[QA_SearchWebsiteNavigationTP]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QA_SearchWebsiteNavigationTP]
@UserID int,
@CountryIds varchar(8000) = '',
@IndustryIds varchar(8000) = '',
@Revenues varchar(8000) = '',
@Products varchar(8000) = '', -- additional filter for tagid from Products
@Solutions varchar(8000) = '',
@Team varchar(8000) = ''
AS
/*
[dbo].[SearchWebsiteNavigationTP] 
@UserID = 159,
@CountryIds = '13',
@IndustryIds = '',
@Revenues = '',
@Products = '',
@Solutions = '',
@Team = ''

*/
BEGIN
  SET NOCOUNT ON;
  DECLARE @SeqNum int,
          @NoofAdvanceFilter int


	INSERT INTO CompanySearches(UserId,IndustryIds,CountryIds,Revenues,Products,Solutions,Teams) 
	VALUES (@UserId,  
						@IndustryIds,
						@CountryIds,
						@Revenues,
						@Products,
						@Solutions,
						@Team);
  --
  -- Unique Sequence Number So that the dront end use this number for querying graph. This  Sequence Number is out parameter
  --
--CREATE TABLE #TempMcDecisionMakerList
--(ID int)
--print '0'
--insert into #TempMcDecisionMakerList
--select decisionmakerid from McDecisionMakerList

  SET @NoofAdvanceFilter = 0

  CREATE TABLE #TempOrganization (
    OrganizationID int
  )

  CREATE TABLE #tempresult (
	 Id int,
    OrganizationName varchar(1000),
    WebsiteDescription varchar(max),
   -- NoofDecisionMakers int,
    SeqNum int,
	KeywordCount Int,
	KeywordScore Int,
	CountryName varchar(1000),
	IndustryName varchar(4000),
	Revenue varchar(1000), ----
	WebsiteURL varchar(2000),
	Domain varchar(100),
	product varchar(max),
	solution varchar(max),
	segment varchar(1000)
  )
   --
  -- Advance Filter
  --
  If @Team <> ''
  begin

  SET @NoofAdvanceFilter = @NoofAdvanceFilter +1
  
  INSERT INTO #TempOrganization
  select id from organization with (nolock)

  --Select distinct t.OrganizationID 
  --from LinkedinData Li, Mcdecisionmakerlist mc, tag t
  --where li.id = mc.decisionmakerid
  --and li.tagid= t.id
  --and mc.name IN (SELECT
  --    [Data]
  --  FROM dbo.Split(@Team, ','))
 print '1'
  end
  
  SELECT
    @SeqNum = NEXT VALUE FOR Seq_Targetpersona;

If @NoofAdvanceFilter = 0 
  INSERT INTO #tempresult
    SELECT
      o.id,
      o.name AS OrganizationName,
       case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end WebsiteDescription,
      --COUNT(*) NoofDecisionMakers,
      @SeqNum SeqNum,
	  WNS.KeyWordCount,
	  WNS.KeywordScore, -----
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
	--LEFT OUTER JOIN TAG T on (t.organizationid = WOP.OrganizationId)
   -- LEFT OUTER JOIN LinkedinData Li  with (nolock) on (li.tagid = t.id )
	--LEFT OUTER JOIN #TempMcDecisionMakerList mc  with (nolock) on (mc.id=li.id)
    WHERE 
	--(li.ResultantCountry) IN (SELECT
 --     Name
 --   FROM UserTargetCountry U,
 --        Country C
 --   WHERE UserId = @UserId
 --   AND u.countryid = c.id)
 --   AND
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
    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
      [Data]
    FROM dbo.Split(@Products, ','))
    )
	 AND (@Solutions = ''
    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
      [Data]
    FROM dbo.Split(@Solutions, ','))
    )
	AND WNS.WebsiteIntentKeywordCategoryID in
	(select WebsiteSolutionGroupID from UserTargetWebsiteSolutionGroup 
	--Where UserID=@UserID
	UNION
	select WebsiteProductGroupID from UserTargetWebsiteProductGroup 
	--Where UserID=@UserID
	)
	AND WNS.ISACTIVE = 1
   -- GROUP BY li.Organizationid,
   --          o.name,
			-- WNS.KeyWordCount,
			-- WNS.KeywordScore, ----
   --           case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end,
			--  C.name ,
   --           i.name ,
	  --        o.Revenue,
	  --        o.WebsiteURL,
	  --WNS.product,
	  --WNS.solution,
	  --WNS.segment
			  
ELSE
 INSERT INTO #tempresult
    SELECT
      o.id,
      o.name AS OrganizationName,
      case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end WebsiteDescription ,
     -- COUNT(*) NoofDecisionMakers,
      @SeqNum SeqNum,
	  WNS.KeyWordCount,
	  WNS.KeywordScore, -----
	  C.name as CountryName,
      i.name as IndustryName,
	  o.Revenue,
	  o.WebsiteURL,
	  	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
	  WNS.product,
	  WNS.solution,
	  WNS.segment
    FROM WebsitenavigationSegment WNS  with (nolock) 
	inner join WebsiteOrganizationMapping WOP  with (nolock) on (WOP.WebsiteID = WNS.WebsiteID)
         INNER JOIN WebsiteIntentKeywordCategory WC  with (nolock) on (WC.ID = WNS.WebsiteIntentKeywordCategoryID)
		 INNER JOIN Organization O  with (nolock)  on  (O.ID = WOP.OrganizationId)
		 INNER JOIN Country C on (c.id = o.CountryID)
	INNER JOIN Industry i on (i.id = o.IndustryID)
	
		 INNER JOIN #TempOrganization o1 on ( O.ID = o1.OrganizationId)
		-- LEFT OUTER JOIN TAG T on (t.organizationid = WOP.OrganizationId)
        -- LEFT OUTER JOIN LinkedinData Li  with (nolock) on (li.tagid = t.id)
		-- LEFT OUTER JOIN #TempMcDecisionMakerList mc on (mc.id=li.id)
    WHERE
	 --(li.ResultantCountry) IN (SELECT
  --    Name
  --  FROM UserTargetCountry U,
  --       Country C
  --  WHERE UserId = @UserId
  --  AND u.countryid = c.id)
  --  AND 
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
    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
      [Data]
    FROM dbo.Split(@Products, ','))
    )
	 AND (@Solutions = ''
    OR WNS.WebsiteIntentKeywordCategoryID IN (SELECT
      [Data]
    FROM dbo.Split(@Solutions, ','))
    )
	AND WNS.WebsiteIntentKeywordCategoryID in
	(select WebsiteSolutionGroupID from UserTargetWebsiteSolutionGroup 
	--Where UserID=@UserID
	UNION
	select WebsiteProductGroupID from UserTargetWebsiteProductGroup 
	--Where UserID=@UserID
	)
	AND WNS.ISACTIVE = 1
   -- GROUP BY t.Organizationid,
   --          o.name,
			-- WNS.KeyWordCount,
			-- WNS.KeywordScore, -----
   --          case when len(o.WebsiteDescription) < 3 then o.glassdoordescription else o.WebsiteDescription end,
			-- C.name ,
   --           i.name ,
	  --        o.Revenue,
	  --        o.WebsiteURL,
	  --WNS.product,
	  --WNS.solution,
	  --WNS.segment
			
		print '4'	 
select * from #tempresult where id is not null  order by KeyWordScore desc

print '5'
  --
  -- graph
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
    WHERE o.id IN (SELECT
      id
    FROM #TempResult)
    AND o.countryid = c.id
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
    WHERE o.industryid = i.id
    AND o.id IN (SELECT
      id
    FROM #TempResult)
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
    WHERE o.id IN (SELECT
      id
    FROM #TempResult)
    GROUP BY o.revenue
	print '6'
END

--select *from AppUser where Email like '%aman%'
