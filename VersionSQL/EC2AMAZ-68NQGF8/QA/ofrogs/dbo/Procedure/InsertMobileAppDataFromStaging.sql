/****** Object:  Procedure [dbo].[InsertMobileAppDataFromStaging]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertMobileAppDataFromStaging] AS
BEGIN
	SET NOCOUNT ON;
	Declare @StartID INT, @EndId Int, @StartTime datetime, @EndTime datetime
      SET @StartTime = GETDATE()  
	-- New App Category Insertion, If Available Starts
	CREATE TABLE #TempMobileAppCategory
	(AppCategory VARCHAR(200))
	
	INSERT INTO #TempMobileAppCategory
	Select Replace(ApplicationCategory,'_',' ') ApplicationCategory
	FROM Training.DBO.MobilePlaystore
	WHERE IsProcessed = 0
	GROUP BY Replace(ApplicationCategory,'_',' ')
	DELETE FROM #TempMobileAppCategory
	WHERE AppCategory in (SELECT AppCategory FROM MobileAppCategory)
	INSERT INTO MobileAppCategory
	SELECT AppCategory FROM #TempMobileAppCategory
   -- New App Category Insertion, If Available Ends
 -- Ge the range of values to Insert
   Select @StartID = min(Id), @EndId = Max(ID)
   from Training.DBO.MobilePlaystore
   WHERE IsProcessed = 0
   --
   --
   insert into mobileapp
([ID]
      ,[AppName]
      ,[CompanyName]
      ,[Category]
      ,[Rating]
      ,[Reviews]
      ,[Installs]
      ,[Size]
      ,[Price]
      ,[ContentRating]
      ,[LastUpdated]
      ,[MinimumVersion]
      ,[LatestVersion]
      ,[OrganizationID]
      ,[AppCategoryID]
     ,[IsActive]
      ,[lastupdateddate]
      ,[Context]
      ,[AppType]
      ,[AppLogo]
      ,[AppURL]
      ,[AppDescription]
      ,[OperatingSystem]
      ,[AuthorType]
      ,[RatingType]
      ,[PriceCurrency]
      ,[OfferAvailability]
      ,[DeveloperDetail]
      ,[Source])

SELECT A.ID
      ,[AppName]
      ,company [CompanyName]
      ,ApplicationCategory [Category]
      ,RatingValue [Rating]
      ,RatingCount [Reviews]
      ,[Installs]
      ,AppSize [Size]
      ,[Price]
      ,[ContentRating]
      ,[LastUpdated]
      ,MinimumAndroidRequired MinimumVersion
      ,LastestVersion
      ,null [OrganizationID]
      ,M.ID [AppCategoryID]
      ,1 [IsActive]
      ,LAstUpdated [lastupdateddate]
      ,[Context]
      ,[AppType]
      ,[AppLogo]
      ,[AppURL]
      ,[AppDescription]
      ,[OperatingSystem]
      ,AutorType [AuthorType]
      ,[RatingType]
      ,[PriceCurrency]
      ,[OfferAvailability]
      ,[DeveloperDetail]
      ,[Source]
  FROM Training.[dbo].MobilePlaystore A, MobileAppCategory M
  WHERE A.ID Between @StartID AND @EndId
  and Replace(A.ApplicationCategory,'_',' ') = M.Appcategory
   --
   -- Finally Update Processed Flag
   --
   Update Training.DBO.MobilePlaystore
   Set IsProcessed = 1
   WHERE ID Between @StartID AND @EndId

    SET @EndTime = GETDATE()
	 INSERT INTO JobStatusLog --
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertMobileAppDataFromStaging',--
      @StartTime,--
      @EndTime,--
      'MobileApp Data Tranfer End')

	  -- 
	  -- Update organizationID
	  --

	  select id as Tagid,
OrganizationId,
Name,
REPLACE(REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE( REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE( REPLACE(
REPLACE( REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE( REPLACE(
REPLACE( REPLACE(
REPLACE(name,
' Company Ltd', ''),
' Company LLC', ''),
' Private Limited', ''),
' Private Ltd', ''),
', Incorporated', ''),
' Incorporated', ''),
' Corporation', ''),
' + Co LLP', ''),
' Co Ltd', ''),
' Pvt Ltd', ''),
' Pty Ltd', ''),
' (p) Ltd', ''),
', LLP', ''),
' LLP', ''),
', Inc.', ''),
' Inc.', ''),
' Corp.', ''),
', LLC', ''),
' Limited ', ''),
' Pvt. Ltd', ''),
' Ltd.', ''),
' Co.,ltd', ''),
' LLC', ''),
' Limited', ''),
' Co., Ltd', ''),
' Pte Ltd', ''),
'"',''),
' Co, Ltd',''),
', Ltd',''),
' Ltd',''),
' ',''),
'&','and'),
'®',''),
', Inc',''),
' plc',''),
', L.P.',''),
', a GE company',''),
',',''),
'''',''),
'/','')
AS newname into #tempTag from tag
where tagtypeid=1



SELECT Id As MobileAppID,
companyname,
REPLACE(REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(replace(
REPLACE(
REPLACE(
REPLACE( REPLACE(
REPLACE( REPLACE(
REPLACE(
REPLACE( REPLACE(REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE(
REPLACE( REPLACE(
REPLACE( REPLACE(
REPLACE(companyname,
' Company Ltd', ''),
' Company LLC', ''),
' Private Limited', ''),
' Private Ltd', ''),
', Incorporated', ''),
' Incorporated', ''),
' Corporation', ''),
' + Co LLP', ''),
' Co Ltd', ''),
' Pvt Ltd', ''),
' Pty Ltd', ''),
' (p) Ltd', ''),
', LLP', ''),
' LLP', ''),
', Inc.', ''),
' Inc.', ''),
' Corp.', ''),
', LLC', ''),
' Limited ', ''),
' Pvt. Ltd', ''),
' Ltd.', ''),
' Co.,ltd', ''),
' LLC', ''),
' Limited', ''),
' Co., Ltd', ''),
' Pte Ltd', ''),
'"',''),
' Co, Ltd',''),
', Ltd',''),
' Ltd',''),
' ',''),
'&','and'),
'®',''),
', Inc',''),
' plc',''),
', L.P.',''),
', a GE company',''),
',',''),
'''',''),
'/','')
AS neworg into #TempMobileApp
FROM MobileApp where OrganizationID is null

select MobileAppID,
OrganizationID 
into #TempLiFinalMobileApp
from #TempMobileApp li, #tempTag t
where t.newname collate SQL_Latin1_General_CP1_CI_AS = li.neworg


;WITH CTE AS(
SELECT MobileAppID,
RN = ROW_NUMBER()OVER(PARTITION BY MobileAppID ORDER BY OrganizationID)
FROM #TempLiFinalMobileApp
)
DELETE FROM CTE WHERE RN > 1

Update MobileApp 
set OrganizationID =(select OrganizationID from #TempLiFinalMobileApp
WHERE #TempLiFinalMobileApp.MobileAppID = MobileApp.ID)
WHERE OrganizationID is null
and ID in (SELECT MobileAppID FROM #TempLiFinalMobileApp)

SET @EndTime = GETDATE()
	 INSERT INTO JobStatusLog --
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertMobileAppDataFromStaging',--
      @StartTime,--
      @EndTime,--
      'OrganizationID Update End')

END
