/****** Object:  Procedure [dbo].[QA_GetGlobalSettings]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetGlobalSettings] 
	@UserId int 
AS
BEGIN

DECLARE @HasCustomPersona INT
declare @PersonaIds varchar(5000), @Personas varchar(5000)
	declare @RegionIds varchar(5000), @Regions varchar(5000)
	,@CustomTechnologyPersonaID VARCHAR(200)	,@CustomIntentPersonaID VARCHAR(200),
	@CustomTeamPersonaID VARCHAR(200)

SELECT @HasCustomPersona = HasCustomPersona,
@CustomTechnologyPersonaID = CustomTechnologyPersonaID,
@CustomIntentPersonaID = CustomIntentPersonaID,
@CustomTeamPersonaID = CustomTeamPersonaID
FROM AppUser 
WHERE ID = @UserId

IF @HasCustomPersona = 0 OR @HasCustomPersona IS NULL OR @HasCustomPersona = ''
BEGIN
	

	select @PersonaIds = PersonaIds from AppUser where Id = @UserId
	select @RegionIds = RegionIds from AppUser where Id = @UserId
    
	select @Personas = STRING_AGG([Name], ', ') from Persona where Id in 
	(select [value] from string_split(@PersonaIds, ','))
	select @Regions = STRING_AGG([Name], ', ') from Region where Id in 
	(select [value] from string_split(@RegionIds, ','))

	select 
		'Focus Area: ' + @Personas + '; Region: ' + @Regions as Summary,
		@Personas as Personas,
		@Regions as Regions
	from AppUser where Id = @UserId

	END
	ELSE IF @HasCustomPersona = 1
	BEGIN

	

	
	SELECT DISTINCT 
	Category INTO #TmpSummary
	FROM AdoptionFramework
	WHERE ID IN (SELECT VALUE FROM string_split(@CustomTeamPersonaID,','))

	INSERT INTO #TmpSummary(Category)
	SELECT DISTINCT TechnologyCategory
	FROM AdoptionFrameworkTechnologyCategory
	WHERE ID IN (SELECT VALUE FROM string_split(@CustomTechnologyPersonaID,','))
	
	INSERT INTO #TmpSummary(Category)
	SELECT DISTINCT 
	Category 
	FROM AdoptionFramework
	WHERE ID IN (SELECT VALUE FROM string_split(@CustomIntentPersonaID,','))




	;WITH CTE AS(
	SELECT DISTINCT 
	Category
	FROM #TmpSummary)
	SELECT @Personas =  STRING_AGG(Category, ', ')
	FROM CTE
	


	SET @RegionIds = 
	(SELECT RegionIds from AppUser where Id = @UserId)


	SET @Regions = 	
	(SELECT STRING_AGG([Name], ', ') from Region where Id in (select [value] 
	from string_split(@RegionIds, ',')))

	select 
		'Focus Area: ' + @Personas + '; Region: ' + @Regions as Summary,
		@Personas as Personas,
		@Regions as Regions
	from AppUser where Id = @UserId


	END
	
END
