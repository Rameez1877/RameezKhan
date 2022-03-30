/****** Object:  Procedure [dbo].[GetTeams]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTeams] @UserId int,  @IsGicSelected bit = 0
/*
[dbo].[GetTeams] 159, 1
*/
AS
BEGIN
	SET NOCOUNT ON;
		--	WITH cte
		--AS (SELECT
		--  name,
		--  Mainmarketinglistname,
		--  IsTeams,
		--  min(CAST(IsInternalList AS tinyint)) IsInternalList
		--FROM McDecisionmaker
		--WHERE isoflist = 1
		--AND isactive = 1
		--ANd IsTeams = 1
		--GROUP BY Mainmarketinglistname, name, IsTeams)
		--SELECT DISTINCT
	 --  MainMarketinglistname as Category,
	 --  Name, isteams
		--FROM cte
		--WHERE IsInternalList = 0
		--group by MainMarketinglistname, name, isteams
		--order by mainmarketinglistname

-- added a new comment
		DECLARE @PersonaIds varchar(100) = ''
	  SELECT
		@PersonaIds = PersonaIds
	  FROM AppUser WHERE Id = @UserId

	  if @PersonaIds <> ''  and @IsGicSelected = 0
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
		AND IsTeams = 1 
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
