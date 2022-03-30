/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationsTechnologies]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE PopulateWebsiteOrganizationsTechnologies

AS
BEGIN
   

    DECLARE @OrganizationId INT;



DECLARE Organization CURSOR FOR SELECT DISTINCT OrganizationId FROM dbo.WebsiteOrganizations

OPEN Organization

FETCH NEXT FROM Organization INTO @OrganizationId

WHILE @@FETCH_STATUS = 0
BEGIN

    --CompanyTechnology

	INSERT INTO dbo.WebsiteOrgTechnologies
	(
	    OrgnizationId,
	    Technology
	)
	

    SELECT DISTINCT TOP 20 Tech.OrganizationId,
           Tech.Keyword
    FROM Technographics Tech WITH (NOLOCK),
         TechStackTechnology tst,
         TechStackSubCategory tssc
    WHERE Tech.Keyword = tst.StackTechnologyName
          AND tst.StackSubCategoryId = tssc.ID
          AND Tech.OrganizationId = @OrganizationId



FETCH NEXT FROM Organization INTO @OrganizationId
END
CLOSE Organization
DEALLOCATE Organization


UPDATE dbo.WebsiteOrgTechnologies SET Category =  tssc.StackType
         

    FROM Technographics Tech WITH (NOLOCK),
         TechStackTechnology tst,
         TechStackSubCategory tssc

    WHERE Tech.Keyword = tst.StackTechnologyName
          AND tst.StackSubCategoryId = tssc.ID
		  AND Tech.OrganizationId = dbo.WebsiteOrgTechnologies.OrgnizationId
		  AND Tech.Keyword = dbo.WebsiteOrgTechnologies.Technology
		  


END;
