/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationIntentsTemp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateWebsiteOrganizationIntentsTemp]

AS
BEGIN
DECLARE @OrganizationId INT
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   


DECLARE INTENTS CURSOR FOR SELECT OrganizationId FROM dbo.WebsiteOrganizations WITH(NOLOCK)

OPEN INTENTS

FETCH NEXT FROM INTENTS INTO @OrganizationId
WHILE @@FETCH_STATUS = 0
BEGIN

DELETE FROM dbo.WebsiteOrganizationIntentsTemp WHERE ID NOT IN (SELECT TOP 20 ID FROM  dbo.WebsiteOrganizationIntents WHERE OrganizationId= @OrganizationId)
AND ORGANIZATIONID= @OrganizationId

FETCH NEXT FROM INTENTS INTO @OrganizationId
END
CLOSE INTENTS
DEALLOCATE INTENTS

END;
