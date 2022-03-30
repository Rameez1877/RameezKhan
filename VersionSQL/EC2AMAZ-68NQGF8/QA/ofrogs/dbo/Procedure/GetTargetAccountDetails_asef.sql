/****** Object:  Procedure [dbo].[GetTargetAccountDetails_asef]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetTargetAccountDetails_asef] 
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
-- [GetTargetAccountDetails_asef] 29446, 1
BEGIN
  SET NOCOUNT ON;

  If @RefreshScore = 1
	exec dbo.ProcessLeadScore @TargetPersonaId, 0

  DECLARE @CreatedBy int,
          --  @DataFilter varchar(4000),
          @Query nvarchar(4000),
          @type varchar(10),
		  @TargetPersonaName varchar(200)

  SELECT
    @CreatedBy = CreatedBy,
    @type = [type],
	@TargetPersonaName = [Name]
  FROM TargetPersona
  WHERE ID = @TargetPersonaId

  SELECT
    o.id OrganizationID,
    O.Name,
    O.WebsiteUrl As WebsiteUrl,
    c.name AS CountryName,
    i.name AS IndustryName,
    o.EmployeeCount,
    o.Revenue,
    T.Comment,
	T.LeadScore
  INTO #Temp1
  FROM organization o
  inner join TargetPersonaOrganization T on (o.Id = t.organizationId)
  inner join country c on (o.countryid = c.id)
  inner join industry i on (o.industryid = i.id)
  where
   t.TargetPersonaId = @TargetPersonaId
    SELECT
      t1.OrganizationID,
      t1.[Name],
      t1.CountryName,
      t1.IndustryName,
      t1.EmployeeCount,
      t1.Revenue,
      t1.WebsiteUrl,
      TargetPersonaName = @TargetPersonaName,
      t1.Comment,
	  t1.LeadScore,
      LS.TotalScore,
     CASE
        WHEN LS.TotalScore >= 70 THEN 'ABM Account'
        WHEN LS.TotalScore < 70 AND
          LS.TotalScore IS NOT NULL THEN 'Nurturing Account'
        ELSE ''
      END AccountType
    FROM #Temp1 t1
	LEFT OUTER JOIN 
	LeadScore LS
      ON (t1.OrganizationID = LS.OrganizationID
     AND LS.UserId = @CreatedBy
      AND type = @type)
    ORDER By t1.LeadScore DESC
  END
