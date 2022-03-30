/****** Object:  Procedure [dbo].[QA_GetTargetAccountDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- 24 feb 2022 Kabir
CREATE PROCEDURE [dbo].[QA_GetTargetAccountDetails] 
@UserID INT = 0,
@Page INT = 0,
@Size INT = 10,
@IndustryName varchar(500) = '',
@Name varchar(500) = '',
@CountryName varchar(500) = '',
@Revenue varchar(500) = '',
@EmployeeCount varchar(500) = '',
@TargetPersonaID INT = 0
AS

BEGIN
  SET NOCOUNT ON;



DECLARE @TargetName VARCHAR(200) = (SELECT Name FROM TargetPersona WHERE Id = @TargetPersonaID)
DECLARE @MarketingID INT = (SELECT  MAX(Id) FROM MarketingLists WHERE TargetPersonaId = @TargetPersonaID)

;WITH CTE AS (
SELECT  O.Id as OrganizationId,
				O.NAME [Name],
				CO.NAME CountryName,
				I.NAME IndustryName,
				O.EmployeeCount,
				O.Revenue,
				O.WebsiteUrl,
				SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
				LEN(O.WebsiteUrl)) AS [Domain],
				CASE WHEN
	GlassDoorDescription IS NULL THEN WebSiteDescription
	ELSE GlassDoorDescription END [Description],
	TPO.Comment ,
				SORTORDER = 
				CASE WHEN ((GlassdoorDescription IS NOT NULL AND GlassdoorDescription <> '') AND (Description IS NOT NULL AND Description <> '') AND EmployeeCount <> 'Unknown'  AND
				  Revenue <> 'Unknown') THEN 1 
				ELSE 1 END,
				count(*) over ( partition by tpo.TargetPersonaID ) as TotalRecords,
				@MarketingID as MarketingListId,
				@TargetName as TargetPersonaName
	FROM 
	 Organization O
	INNER JOIN Country CO ON CO.ID = O.CountryId
	INNER JOIN Industry I ON I.Id = O.IndustryId
	INNER JOIN TargetPersonaOrganization TPO ON 
	 TPO.OrganizationId = O.Id
	where 
	 tpo.TargetPersonaId = @TargetPersonaID  and
	 (@IndustryName = '' or i.Name = @IndustryName)
	and (@Name = '' or o.Name = @Name)
	and (@CountryName = '' or co.Name = @CountryName)
	and (@Revenue = '' or o.Revenue = @Revenue)
	and (@EmployeeCount = '' or EmployeeCount = @EmployeeCount))

	SELECT DISTINCT
	OrganizationId,Name,CountryName,IndustryName,EmployeeCount,Revenue,WebsiteUrl,Domain,Description,Comment,TotalRecords,MarketingListId,TargetPersonaName,
	SORTORDER = 
				CASE WHEN (Description IS NOT NULL AND Description <> '') AND EmployeeCount <> 'Unknown'  AND
				  Revenue <> 'Unknown' THEN 1 ELSE 0 END
	FROM CTE
	ORDER BY SORTORDER DESC
	OFFSET (@PAGE * @SIZE) ROWS
	FETCH NEXT @SIZE ROWS ONLY

	   --USE [ofrogs]
--GO
--/****** Object:  StoredProcedure [dbo].[QA_GetTargetAccountDetails]    Script Date: 23-Feb-22 10:47:25 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[QA_GetTargetAccountDetails] 
--@TargetPersonaId int,
--@RefreshScore bit = null
--AS
---- =============================================      
---- Author:  Vijaya    
---- Create date: 14 June, 2019      
---- Updated date: 14 June, 2019      
---- Description: Gets the Target Accounts for Target Accounts Details page.//      
---- =============================================      
---- [GetTargetAccountDetails] 29644, 1
--BEGIN
--  SET NOCOUNT ON;

--  If @RefreshScore = 1
--	exec dbo.ProcessLeadScore @TargetPersonaId, 0

--  DECLARE @CreatedBy int,
--          --  @DataFilter varchar(4000),
--          @Query nvarchar(4000),
--          @type varchar(10),
--		  @TargetPersonaName varchar(200),
--		  @MarketingListId int

--  SELECT
--    @CreatedBy = CreatedBy,
--    @type = type,
--	@TargetPersonaName = [Name]
--  FROM TargetPersona
--  WHERE ID = @TargetPersonaId

--  Select @MarketingListId = Id from MarketingLists
--  where TargetPersonaId = @TargetPersonaId

--  DECLARE @IsLeadScoreConfigured bit = (select top 1 1
--	from (
--		select top 1 TargetPersonaId FROM UserTargetFunctionality where TargetPersonaId = @TargetPersonaId
--		union
--		select top 1 TargetPersonaId FROM UserTargetTechnology where TargetPersonaId = @TargetPersonaId
--		union all
--		select top 1 TargetPersonaId FROM UserTargetIndustry where TargetPersonaId = @TargetPersonaId
--	) a
--	)
--	SET @IsLeadScoreConfigured = IIF(@IsLeadScoreConfigured IS NULL,0,1)
	

--  SELECT
--    o.id OrganizationId,
--    O.Name,
--    O.WebsiteUrl As WebsiteUrl,
--	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
--			LEN(O.WebsiteUrl)) AS [Domain],
--    c.name AS CountryName,
--    i.name AS IndustryName,
--    o.EmployeeCount,
--    o.Revenue,
--    T.Comment,
--	T.LeadScore,
--	SortOrder = case when i.Name <> 'Unknown' 
--				and o.EmployeeCount <> 'Unknown' 
--				and	o.Revenue <> 'Unknown' then 1 
--				else 0 end
--  INTO #Temp1
--  FROM organization o
--       inner join TargetPersonaOrganization T on (o.id = t.OrganizationId  AND t.targetpersonaid = @TargetPersonaId)
--	   inner join Country c on (o.countryid = c.id)
--       inner join Industry i on (o.IndustryId = i.id)
       

--    SELECT
--      t1.OrganizationId,
--      t1.[Name],
--      t1.CountryName,
--      t1.IndustryName,
--      t1.EmployeeCount,
--      t1.Revenue,
--      t1.WebsiteUrl,
--	  t1.Domain,
--      t1.Comment,
--	  t1.LeadScore,
--      LS.TotalScore,
--	  TargetPersonaName = @TargetPersonaName,
--	  @IsLeadScoreConfigured as IsLeadScoreConfigured,
--     CASE
--        WHEN LS.TotalScore >= 60 THEN 'ABM Account'
--        WHEN LS.TotalScore < 60 AND
--          LS.TotalScore IS NOT NULL THEN 'Nurturing Account'
--        ELSE ''
--      END AccountType,
--	  @MarketingListId as MarketingListId
--    FROM #Temp1 t1
--	LEFT OUTER JOIN 
--	LeadScore LS
--      ON (t1.OrganizationID = LS.OrganizationID
--      AND LS.UserId = @CreatedBy
--      AND type = @type)
--    ORDER By t1.LeadScore DESC,
--	SortOrder Desc
--  END



  END
