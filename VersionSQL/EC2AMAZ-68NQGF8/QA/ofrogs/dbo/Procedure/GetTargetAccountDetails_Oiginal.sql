/****** Object:  Procedure [dbo].[GetTargetAccountDetails_Oiginal]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTargetAccountDetails_Oiginal] 
@TargetPersonaId int,
@RefreshScore bit = null
AS
-- =============================================      
-- Author:  Vijaya    
-- Create date: 14 June, 2019      
-- Updated date: 14 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts Details page.//      
-- =============================================      
-- [GetTargetAccountDetails] 29446, 1
BEGIN
  SET NOCOUNT ON;

  If @RefreshScore = 1
	exec dbo.ProcessLeadScore @TargetPersonaId, 0

  DECLARE @CreatedBy int,
          --  @DataFilter varchar(4000),
          @Query nvarchar(4000),
          @type varchar(10)


  SELECT
    @CreatedBy = CreatedBy,
    @type = type
  FROM TargetPersona
  WHERE ID = @TargetPersonaId

  SELECT
    o.id OrganizationID,
    tp.id AS TargetPersonaId,
    O.Name,
    O.WebsiteUrl As WebsiteUrl,

	-- Commented on 23-June-2021

	--CASE
     -- WHEN O.WebsiteUrl LIKE '%https%' THEN O.WebsiteUrl
     -- ELSE 'https://' + O.WebsiteUrl
    --END WebsiteUrl,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
    T.Comment,
    tp.Name AS TargetPersonaName,
    CONVERT(varchar, tp.CreateDate, 106) AS CreateDate,
    CONVERT(varchar, o.createdDate, 106) AS OrganizationCreateDate,
	T.LeadScore
  INTO #Temp1
  FROM organization o,
       TargetPersonaOrganization T,
       country c,
       industry i,
       TargetPersona tp
  WHERE o.id = t.organizationid
  AND o.countryid = c.id
  AND o.industryid = i.id
  AND t.targetpersonaid = @TargetPersonaId
  AND t.TargetPersonaId = tp.id

  --IF @TargetPersonaId in (18932, 20976)
  --BEGIN
    SELECT
      t1.OrganizationID,
      t1.TargetPersonaId,
      t1.[Name],
      t1.CountryName,
      t1.IndustryName,
      t1.EmployeeCount,
      t1.Revenue,
      t1.WebsiteUrl,
      t1.TargetPersonaName,
      t1.CreateDate,
      t1.OrganizationCreateDate,
      t1.Comment,
	  t1.LeadScore,
      LS.TotalScore,

	  	--commented on 23-Jun-2021

      --ofi.TotalFunding,
      --CAST(ofi.FoundingYear AS varchar) + ', ' + ofi.LastFundingRoundType AS FundingDetail,

      CASE
        WHEN LS.TotalScore >= 60 THEN 'ABM Account'
        WHEN LS.TotalScore < 60 AND
          LS.TotalScore IS NOT NULL THEN 'Nurturing Account'
        ELSE ''
      END AccountType
    FROM #Temp1 t1

	--commented on 23-Jun-2021

    --LEFT OUTER JOIN 
	--StartUpsFundingData ofi
      --ON (t1.OrganizationID = ofi.OrganizationId)
    
	LEFT OUTER JOIN 
	LeadScore LS
      ON (t1.OrganizationID = LS.OrganizationID
      AND LS.UserId = @CreatedBy
      AND type = @type)
    ORDER By t1.LeadScore DESC
  END
 -- ELSE
  --BEGIN

    SELECT
      t1.OrganizationID,
      t1.TargetPersonaId,
      t1.[Name],
      t1.CountryName,
      t1.IndustryName,
      t1.EmployeeCount,
      t1.Revenue,
      t1.WebsiteUrl,
      t1.TargetPersonaName,
      t1.CreateDate,
      t1.OrganizationCreateDate,
      t1.Comment,
	  t1.LeadScore,
      LS.TotalScore,
      CASE
        WHEN LS.TotalScore >= 60 THEN 'ABM Account'
        WHEN LS.TotalScore < 60 AND
          LS.TotalScore IS NOT NULL THEN 'Nurturing Account'
        ELSE ''
      END AccountType
    FROM #Temp1 t1
    LEFT OUTER JOIN LeadScore LS
      ON (t1.OrganizationID = LS.OrganizationID
      AND LS.UserId = @CreatedBy
      AND type = @type)
    ORDER By t1.LeadScore DESC
  
