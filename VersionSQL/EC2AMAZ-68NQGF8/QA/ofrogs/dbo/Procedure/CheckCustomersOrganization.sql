/****** Object:  Procedure [dbo].[CheckCustomersOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <04th Feb 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[CheckCustomersOrganization]
@CustomersAccountListId int
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #temp_org
	(
		CustomersDataOrganization varchar(100),
		CustomersDataWebsiteUrl varchar(500),
		OceanfrogsOrganizationId int,
		OceanfrogsOrganizationName varchar(100),
		OceanfrogsWebsiteUrl varchar(500),
		ExistOrNotExist varchar(100)
	)

	;with cte_temporg as(
	SELECT	DISTINCT
			Organization,
			WebsiteUrl
	FROM	CustomersUploadedData
	WHERE	CustomersAccountListId = @CustomersAccountListId
			AND IsProcessed = 0
	)

	INSERT INTO #temp_org(CustomersDataOrganization,CustomersDataWebsiteUrl,OceanfrogsOrganizationId,OceanfrogsOrganizationName,
						OceanfrogsWebsiteUrl,ExistOrNotExist)
	SELECT	DISTINCT
			c.Organization,
			c.WebsiteUrl,
			o.Id as OceanfrogsOrganizationId,
			o.Name as OceanfrogsOrganizationName,
			o.WebsiteUrl as OceanfrogsWebsiteUrl,
			'Exists' as ExistOrNotExist
	FROM	Organization o
			INNER JOIN cte_temporg c ON (o.Name like '%' + c.Organization + '%')

	UPDATE
		c
	SET
		c.IsExist = 1
	FROM
		CustomersUploadedData c
		INNER JOIN #temp_org t ON (c.Organization = t.CustomersDataOrganization)
	WHERE
		t.ExistOrNotExist = 'Exists'
		AND c.CustomersAccountListId = @CustomersAccountListId
		AND c.IsExist = 0

	INSERT INTO #temp_org(CustomersDataOrganization,CustomersDataWebsiteUrl,ExistOrNotExist)
	SELECT	c.Organization,
			c.WebsiteUrl,
			'Does Not Exist' as ExistOrNotExist
	FROM	CustomersUploadedData c
	WHERE	c.IsExist = 0
			AND CustomersAccountListId = @CustomersAccountListId

	SELECT * FROM #temp_org ORDER BY ExistOrNotExist,CustomersDataOrganization,OceanfrogsOrganizationName

	DROP TABLE #temp_org

END
