/****** Object:  Procedure [dbo].[GetTechnologyCategory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef Daqi>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTechnologyCategory] @UserId int, @IsGicSelected bit = 0
/*
 [dbo].[GetTechnologyCategory] 5712,1
*/
AS
BEGIN

  SET NOCOUNT ON

  DECLARE @PersonaIds varchar(100) = '',
          @hasPersonaId bit
  SELECT
    @PersonaIds = PersonaIds
  FROM AppUser
  WHERE Id = @UserId
  SET @hasPersonaId = IIF(@PersonaIds IS NULL OR @PersonaIds = '', 0, 1)

  IF @hasPersonaId = 1 and @IsGicSelected = 0
  BEGIN
    SELECT DISTINCT
      tc.ID,
      tc.StackType AS name
    --into  #TempTechnology 
    FROM persona p
    INNER JOIN adoptionframeworktechnologycategory att
      ON (p.name = att.category)
    INNER JOIN TechStackTechnology tss
      ON (tss.StackSubCategoryId = att.TechnologyCategoryid)
    INNER JOIN techstacksubcategory tc
      ON (tc.id = tss.stacksubcategoryid)
    --inner join Technographics t on (t.keyword=tss.StackTechnologyName)
    WHERE p.Id IN (SELECT
      value
    FROM string_split(@PersonaIds, ','))

  END
  ELSE
  BEGIN
    SELECT DISTINCT
      ID,
      StackType AS name
    FROM techstacksubcategory
    WHERE ISACTIVE = 1
  END
END
