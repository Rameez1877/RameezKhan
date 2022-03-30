/****** Object:  Procedure [dbo].[GetWebsiteData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetWebsiteData]
(@OrganizationName VARCHAR(500))
AS
BEGIN
    DECLARE @OrganizationId INT
	DECLARE @IndustryName VARCHAR(200)
	DECLARE @Revenue VARCHAR(200)

SELECT @OrganizationId = OrganizationId,@Revenue = Revenue,@IndustryName = @IndustryName FROM dbo.WebsiteOrganizations WHERE TransformedName = @OrganizationName;

SELECT OrganizationName AS Name,IndustryName AS Industry,EmployeeCount,CountryName AS Headquarter ,Description,Revenue FROM dbo.WebsiteOrganizations WHERE OrganizationId = @OrganizationId;

SELECT Technology,Category FROM dbo.WebsiteOrgTechnologies WHERE OrganizationId = @OrganizationId;

SELECT TOP 20 FirstName,LastName,Designation,Location,Url,Functionality FROM dbo.WebsiteOrganizationContacts WHERE OrganizationId = @OrganizationId
       
SELECT DISTINCT TOP 20 IntentTopic,Category, Location,InvestmentType,Duration FROM dbo.WebsiteOrganizationIntents WHERE OrganizationId = @OrganizationId;

SELECT GraphType,
       Name,
       Value FROM dbo.WebsiteGraphData WHERE OrganizationId = @OrganizationId

DECLARE @RowCount INT
SELECT DISTINCT TOP 10 'https://oceanfrogs.com/search-by-company/'+ t1.TransformedName AS WebsiteUrl INTO #temp  FROM  dbo.WebsiteOrganizations T1 tablesample(1 percent)
INNER JOIN dbo.WebsiteOrganizations T2  ON T2.Revenue = T1.Revenue
AND T2.IndustryName = T1.IndustryName AND t1.WebsiteUrl != '' AND t1.IndustryName != 'unkwnown'

SET @RowCount = @@ROWCOUNT

SELECT DISTINCT TOP 10  'https://oceanfrogs.com/search-by-company/'+ t1.TransformedName AS WebsiteUrl INTO #temp1 FROM  dbo.WebsiteOrganizations T1 tablesample(1 percent)
WHERE  t1.WebsiteUrl != '' AND t1.IndustryName != 'unkwnown'
	
IF (@IndustryName IS NULL OR @Revenue IS NULL) OR (@IndustryName = '' OR @Revenue = '')
begin
	IF (@RowCount <10)
	BEGIN
		PRINT '86 @RowCount'+' '+ CAST(@RowCount AS VARCHAR(10))
		SELECT * FROM  #temp1
	END
ELSE
	BEGIN
		PRINT '92 @RowCount'+' '+ CAST(@RowCount AS VARCHAR(10))
		SELECT * FROM  #temp
	END
END
ELSE
BEGIN
	SELECT DISTINCT TOP 10  'https://oceanfrogs.com/search-by-company/'+ t1.TransformedName AS WebsiteUrl FROM  dbo.WebsiteOrganizations T1 tablesample(1 percent)
	WHERE T1.IndustryName = @IndustryName AND T1.Revenue = @Revenue AND t1.IndustryName != 'unkwnown'
end

DROP TABLE #temp,#temp1

END;
