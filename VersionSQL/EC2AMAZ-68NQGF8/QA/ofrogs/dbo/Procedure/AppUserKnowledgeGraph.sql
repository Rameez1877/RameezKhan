/****** Object:  Procedure [dbo].[AppUserKnowledgeGraph]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AppUserKnowledgeGraph] 
	-- Add the parameters for the stored procedure here
	@AppUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	DECLARE @TEMP_ORG TABLE
	(
		OrganizationName VARCHAR(100),
		Score float
	)

    -- Insert statements for procedure here
	INSERT INTO @TEMP_ORG
	SELECT distinct E.EntityId, 0 FROM ofuser.AppUserTopic AUT 
	join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CS_AS = T.Label 
	join Entity E on E.RssFeedItemId = T.RssFeedItemId
	join EntityFreebaseType EFT on EFT.EntityId = E.Id 
	join FreebaseType FT on FT.Id = EFT.FreebaseTypeId 
	join EntityDBPediaType EDBT on EDBT.EntityId = E.Id
	join DBPediaType DBT on DBT.Id = EDBT.DBPediaTypeId
	where T.Score > 0.3 and FT.Id in (3168,3369,4216,4217, 4218) and DBT.Id in (438,555,560)
	and AUT.AppUserId = @AppUserId

	INSERT INTO Organization(Name,FullName,name2, CreatedById,CreatedDate,IsActive)
	Select distinct OrganizationName ,OrganizationName,OrganizationName, 43,getdate(),1 from 
	@TEMP_ORG where OrganizationName COLLATE Latin1_General_CI_AI not in
	(select Name from Organization where isactive = 1) 
	--and Score > 0.3

	INSERT INTO Tag
	Select distinct TR.OrganizationName,1,O.Id 
	from Organization O join @TEMP_ORG TR on O.Name COLLATE SQL_Latin1_General_CP1_CI_AS = TR.OrganizationName
	where OrganizationName COLLATE Latin1_General_CI_AI not in (select Name from Tag)

	--INSERT INTO ofuser.CustomerTargetList (appuserid, OrganizationId, NewsTagStatus)
	--Select distinct @AppUserId,O.Id, null from Organization O join @TEMP_ORG TR on O.Name
	--COLLATE SQL_Latin1_General_CP1_CI_AS = TR.OrganizationName
	--Where O.Id not in (Select OrganizationId from ofuser.CustomerTargetList 
	--where AppuserId = @AppUserId) and Score > 0.6
	
	

END
