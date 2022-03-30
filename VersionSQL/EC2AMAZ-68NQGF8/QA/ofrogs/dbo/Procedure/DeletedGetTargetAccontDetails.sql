/****** Object:  Procedure [dbo].[DeletedGetTargetAccontDetails]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[GetTargetAccontDetails]
	
	@TargetPersonaId int
AS      
-- =============================================      
-- Author:  Vijaya    
-- Create date: 14 June, 2019      
-- Updated date: 14 June, 2019      
-- Description: Gets the Target Accounts for Target Accounts Details page.//      
-- =============================================      
-- [GetTargetAccounts] 2
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
  O.* ,
  c.name AS CountryName,
  i.name AS IndustryName,
  o.EmployeeCount,
  o.Revenue
FROM organization o,
     TargetPersonaOrganization T,
     country c,
     industry i
WHERE o.id = t.organizationid
AND o.countryid = c.id
AND o.industryid = i.id
AND t.targetpersonaid = @TargetPersonaId
END
