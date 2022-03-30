/****** Object:  Procedure [dbo].[AppUserKnowledgeGraph2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AppUserKnowledgeGraph2] 
	-- Add the parameters for the stored procedure here
	@AppUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	    -- Insert statements for procedure here
	DECLARE @TEMP_Tag TABLE
	(
		TagName VARCHAR(100)
	)

	-- Insert statements for procedure here
	INSERT INTO @TEMP_Tag
	SELECT distinct E.EntityId FROM ofuser.AppUserTopic AUT 
	join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CS_AS = T.Label 
	join Entity E on E.RssFeedItemId = T.RssFeedItemId
	join EntityFreebaseType EFT on EFT.EntityId = E.Id 
	join FreebaseType FT on FT.Id = EFT.FreebaseTypeId 
	join EntityDBPediaType EDBT on EDBT.EntityId = E.Id
	join DBPediaType DBT on DBT.Id = EDBT.DBPediaTypeId
	where T.Score > 0.6 and FT.Id in (3201,4214,4215,4223)
	and AUT.AppUserId = @AppUserId

	INSERT INTO Tag(Name,TagTypeId,OrganizationId)
	Select TagName,2,NULL from 
	@TEMP_Tag where TagName COLLATE Latin1_General_CI_AI not in
	(select Name from Tag)

	INSERT INTO ofuser.AppUserTag
	select @AppUserId,T.Id from
	@TEMP_Tag TT join Tag T on T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = TT.TagName where T.Id not in
	(select TagId from ofuser.AppUserTag where AppUserId = @AppUserId)

	DELETE FROM @TEMP_Tag

	INSERT INTO @TEMP_Tag
	SELECT distinct E.EntityId FROM ofuser.AppUserTopic AUT 
	join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CS_AS = T.Label 
	join Entity E on E.RssFeedItemId = T.RssFeedItemId
	join EntityFreebaseType EFT on EFT.EntityId = E.Id 
	join FreebaseType FT on FT.Id = EFT.FreebaseTypeId 
	join EntityDBPediaType EDBT on EDBT.EntityId = E.Id
	join DBPediaType DBT on DBT.Id = EDBT.DBPediaTypeId
	where T.Score > 0.6 and FT.Id in (4221,4222,4244)and DBT.Id in (563)
	and AUT.AppUserId = @AppUserId

	INSERT INTO Tag(Name,TagTypeId,OrganizationId)
	Select TagName,8,NULL from 
	@TEMP_Tag where TagName COLLATE Latin1_General_CI_AI not in
	(select Name from Tag)

	INSERT INTO ofuser.AppUserTag
	select @AppUserId,T.Id from
	@TEMP_Tag TT join Tag T on T.Name COLLATE SQL_Latin1_General_CP1_CI_AS = TT.TagName where T.Id not in
	(select TagId from ofuser.AppUserTag where AppUserId = @AppUserId)
	
END
