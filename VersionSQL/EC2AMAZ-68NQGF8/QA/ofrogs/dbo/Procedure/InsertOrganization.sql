/****** Object:  Procedure [dbo].[InsertOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertOrganization] 
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
	SELECT distinct E.EntityId, 0 FROM Entity E ,
	EntityDBPediaType EDBT , EntityFreebaseType EFT,  FreebaseType FT,
	DBPediaType DBT
	where EFT.EntityId = E.Id 
	and FT.Id = EFT.FreebaseTypeId 
	and EDBT.EntityId = E.Id
	and DBT.Id = EDBT.DBPediaTypeId
	and FT.Id in (4218) and DBT.Id in (438,555,560)
	and e.entityid collate Latin1_General_CI_AI not in 
	(select name from tag where tagtypeid = 1)

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
