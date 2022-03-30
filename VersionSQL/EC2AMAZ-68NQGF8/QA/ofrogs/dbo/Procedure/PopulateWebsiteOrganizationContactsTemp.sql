/****** Object:  Procedure [dbo].[PopulateWebsiteOrganizationContactsTemp]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateWebsiteOrganizationContactsTemp]

AS
BEGIN

DECLARE @OrganizationId INT

DECLARE CONTACTS CURSOR FOR SELECT OrganizationId FROM dbo.WebsiteOrganizations WITH(NOLOCK)

OPEN CONTACTS

FETCH NEXT FROM CONTACTS INTO @OrganizationId

WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO dbo.WebsiteOrganizationContactstemp
(
    DecisionMakerId,
    OrganizationId,
    FirstName,
    LastName,
    Designation,
    Location,
    Url,
	Flag
)


SELECT DISTINCT TOP 20 DecisionMakerId,OrganizationId,FirstName,LastName,Designation,Location,Url,1
FROM dbo.WebsiteOrganizationContacts
WHERE OrganizationId = @OrganizationId

FETCH NEXT FROM CONTACTS INTO @OrganizationId
END
CLOSE CONTACTS
DEALLOCATE CONTACTS

END;
