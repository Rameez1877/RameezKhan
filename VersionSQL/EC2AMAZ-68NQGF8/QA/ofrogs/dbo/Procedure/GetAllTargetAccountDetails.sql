/****** Object:  Procedure [dbo].[GetAllTargetAccountDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetAllTargetAccountDetails] 
@TargetPersonaId int
AS
-- =============================================      
-- Author:  Vijaya    
-- Create date: 14 June, 2019      
-- Updated date: 14 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts Details page.//      
-- =============================================      
-- [GetTargetAccountDetails] 29644, 1
BEGIN
  SET NOCOUNT ON;
  declare @RefreshScore bit = 0

  If @RefreshScore = 1
	exec dbo.ProcessLeadScore @TargetPersonaId, 0

  DECLARE @CreatedBy int,
          --  @DataFilter varchar(4000),
          @Query nvarchar(4000),
          @type varchar(10),
		  @TargetPersonaName varchar(200),
		  @MarketingListId int

  SELECT
    @CreatedBy = CreatedBy,
    @type = type,
	@TargetPersonaName = [Name]
  FROM TargetPersona
  WHERE ID = @TargetPersonaId

  Select @MarketingListId = Id from MarketingLists
  where TargetPersonaId = @TargetPersonaId

  DECLARE @IsLeadScoreConfigured bit = (select top 1 1
	from (
		select top 1 TargetPersonaId FROM UserTargetFunctionality where TargetPersonaId = @TargetPersonaId
		union
		select top 1 TargetPersonaId FROM UserTargetTechnology where TargetPersonaId = @TargetPersonaId
		union all
		select top 1 TargetPersonaId FROM UserTargetIndustry where TargetPersonaId = @TargetPersonaId
	) a
	)
	SET @IsLeadScoreConfigured = IIF(@IsLeadScoreConfigured IS NULL,0,1)
	

  SELECT
    o.id OrganizationId,
    O.Name,
    O.WebsiteUrl As WebsiteUrl,
	SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
    T.Comment,
	T.LeadScore,
	SortOrder = case when i.Name <> 'Unknown' 
				and o.EmployeeCount <> 'Unknown' 
				and	o.Revenue <> 'Unknown' then 1 
				else 0 end
  INTO #Temp1
  FROM organization o
       inner join TargetPersonaOrganization T on (o.id = t.OrganizationId  AND t.targetpersonaid = @TargetPersonaId)
	   inner join Country c on (o.countryid = c.id)
       inner join Industry i on (o.IndustryId = i.id)
       

    SELECT
      t1.OrganizationId,
      t1.[Name],
      t1.CountryName,
      t1.IndustryName,
      t1.EmployeeCount,
      t1.Revenue,
      t1.WebsiteUrl,
	  t1.Domain,
      t1.Comment,
	  t1.LeadScore,
      LS.TotalScore,
	  TargetPersonaName = @TargetPersonaName,
	  @IsLeadScoreConfigured as IsLeadScoreConfigured,
     CASE
        WHEN LS.TotalScore >= 60 THEN 'ABM Account'
        WHEN LS.TotalScore < 60 AND
          LS.TotalScore IS NOT NULL THEN 'Nurturing Account'
        ELSE ''
      END AccountType,
	  @MarketingListId as MarketingListId
    FROM #Temp1 t1
	LEFT OUTER JOIN 
	LeadScore LS
      ON (t1.OrganizationID = LS.OrganizationID
      AND LS.UserId = @CreatedBy
      AND type = @type)
    ORDER By t1.LeadScore DESC,
	SortOrder Desc
  END
