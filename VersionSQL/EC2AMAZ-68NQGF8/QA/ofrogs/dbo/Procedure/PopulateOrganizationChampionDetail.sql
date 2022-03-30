/****** Object:  Procedure [dbo].[PopulateOrganizationChampionDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateOrganizationChampionDetail]
@userId Int,
@organizationId int,
@OrganizationChampionID INT,
@CountryId INT
AS
BEGIN
  DECLARE @Id INT,
		  @URL VARCHAR(500),
		  @Location VARCHAR(200),
		  @NoOfChampion INT
	
	SET NOCOUNT ON;
	
	select @Location = name from country where id = @CountryId
    
	-- Insert statements for procedure here
	
	DELETE FROM OrganizationChampionDetail
    WHERE UserID = @userId
    AND TrackedOrganizationId = @organizationId

	CREATE TABLE #TempChampion
	(URL VARCHAR(500),
    liId INT)
	
	CREATE TABLE #TempChampion1
	(URL VARCHAR(500),
    CountOfOrganization INT)

	INSERT INTO #TempChampion
 SELECT
    li1.url,
    MIN(li1.id) AS liId 
  FROM LinkedinDataArchive Li1,
       Tag T,
       Organization o
  WHERE Li1.Tagid = T.id
  AND T.OrganizationID = @OrganizationId
  AND T.OrganizationID = o.id
  AND li1.resultantCountry =@Location
  GROUP BY li1.url

  INSERT INTO OrganizationChampionDetail (LinkedinId,
  OrganizationId,
  TrackedOrganizationId,
  ProfileName,
  Designation,
  OrganizationName,
  UserID,
  InsertedDate,
  url,
  Gender,
  OrganizationChampionID,
  Country)
    SELECT
      li.id,
      o.id,
      @OrganizationId,
      li.name,
      li.designation,
      o.name AS OrganizationName,
      @userId,
      GETDATE(),
      li.url,
      li.gender,
	  @OrganizationChampionID,
	  @Location
    FROM linkedindataarchive li,
         tag t,
         organization o
    WHERE li.tagid = t.id
    AND t.organizationid = o.id
	AND EXISTS
	(Select * from #TempChampion t2
	WHERE li.url=t2.url
	and li.id >= t2.liId)

	INSERT INTO #TempChampion1
 SELECT
    li1.url,
   count (distinct Li1.OrganizationId) AS CountOfOrganization 
  FROM OrganizationChampionDetail Li1
  GROUP BY li1.url
  
  	Update OrganizationChampionDetail
	SET IsChampion = 1
	where OrganizationChampionID =@OrganizationChampionID
	And UserID = @UserID
	AND EXISTS
	(SELECT * from #TempChampion1 T1
	WHERE t1.CountOfOrganization >1
	and t1.URL = OrganizationChampionDetail.URL)
	

	SELECT @NoOfChampion = Count(Distinct URL) FROM OrganizationChampionDetail
	WHERE IsChampion = 1
	And OrganizationChampionID =@OrganizationChampionID
	And UserID = @UserID

	UPDATE OrganizationChampionDetail
	Set NoOfChampion=  @NoOfChampion
	WHERE OrganizationChampionID =@OrganizationChampionID
	And UserID = @UserID

END
