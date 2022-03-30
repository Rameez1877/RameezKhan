/****** Object:  Procedure [dbo].[GetFunctionalities]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Asef>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFunctionalities] @UserId int

AS
BEGIN
	SET NOCOUNT ON;


		DECLARE @PersonaIds varchar(100) = ''
	  SELECT
		@PersonaIds = PersonaIds
	  FROM AppUser WHERE Id = @UserId

	  if @PersonaIds <> ''
	  begin
	    SELECT distinct
		Category,
		Functionality as [Name]
	  FROM AdoptionFramework
	  WHERE PersonaTypeId IN (SELECT
		value
	  FROM string_split(@PersonaIds, ','))
	  order by Category
	  --group by Category
	  end
	  else
	  begin
	  		WITH cte
		AS (SELECT
		  name,
		  Mainmarketinglistname,
		  min(CAST(IsInternalList AS tinyint)) IsInternalList
		FROM McDecisionmaker
		WHERE isoflist = 1
		AND isactive = 1
		-- AND IsTeams = 1 
		GROUP BY Mainmarketinglistname, name)
		SELECT DISTINCT
	   MainMarketinglistname as Category,
	   Name
		FROM cte
		WHERE IsInternalList = 0
		group by MainMarketinglistname, name
		order by mainmarketinglistname
		end
END
