/****** Object:  Procedure [dbo].[sp_get_linkedindata_ml]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_get_linkedindata_ml]
-- Add the parameters for the stored procedure here  

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;
  DECLARE @id int,
          @Title varchar(100),
          @Summary varchar(max),
          @organization varchar(max),
       --   @Count1 int,
          @Count2 int,
          @Name varchar(200)

  DELETE FROM McDecisionmakerlist
  WHERE mode = 'Keyword Based List'

  DECLARE db_cursor_lidata_ml CURSOR FOR
  SELECT
    id,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), '/', ' '), '(', ' '), ')', ' ') title,
    REPLACE(REPLACE(REPLACE(summary, ',', ' '), '.', ' '), '/', ' ') summary,
    organization,
    name
  FROM LinkedInData gm
  WHERE EXISTS (SELECT
    *
  FROM decisionmakerlist dm
  WHERE isactive = 1
  AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), '/', ' '), '(', ' '), ')', ' '), ':', ' ') + ' ') > 0)
 
  OPEN db_cursor_lidata_ml
  FETCH NEXT FROM db_cursor_lidata_ml INTO @id, @Title, @summary, @organization, @Name

  WHILE @@FETCH_STATUS = 0
  BEGIN
    --INSERT INTO McDecisionmakerlist (AppUserId,
    --DecisionMakerId,
    --DecisionMakerlistName,
    --IsActive,
    --Name,
    --Mode)
    --  SELECT
    --   DISTINCT 1 AppUserId,
    --    @id DecisionMakerId,
    --    @Name DecisionMakerlistName,
    --    1 IsActive,
    --    Name MarketingListName,
    --    'Keyword Based List'
    --  FROM McDecisionMaker where IsOFList = 1
    --  AND CHARINDEX(' ' + keyword + ' ', ' ' + @Title + ' ') > 0
    --  AND (CHARINDEX('airport', @summary) > 0
    --  OR CHARINDEX('airport', @organization) > 0
    --  OR CHARINDEX('Aéroport', @summary) > 0
    --  OR CHARINDEX('Aéroport', @organization) > 0
    --  OR CHARINDEX('Flughafen', @summary) > 0
    --  OR CHARINDEX('Flughafen', @organization) > 0
    --  )
    --  AND MainMarketingListName = 'Airport'
	   --AND Name <> 'Others'
    --SET @Count1 = @@ROWCOUNT
  INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT DISTINCT
        1 AppUserId,
        @id DecisionMakerId,
        @Name DecisionMakerlistName,
        1 IsActive,
        Name MarketingListName,
        'Keyword Based List'
      FROM McDecisionMaker where IsOFList = 1
      AND CHARINDEX(' ' + keyword + ' ', ' ' + @Title + ' ') > 0
	  AND Isactive =1
    --  AND MainMarketingListName <> 'Airport'
	  AND Name <> 'Others'
    SET @Count2 = @@ROWCOUNT
	--
	-- If the decision maker is not part of any Marketing List, Push him to Marketing Group as 'Others'
	--
  IF @Count2 = 0
	   begin
	 
      INSERT INTO McDecisionmakerlist (AppUserId,
      DecisionMakerId,
      DecisionMakerlistName,
      IsActive,
      Name,
      Mode)
        VALUES (1, @id, @Name, 1, 'Others', 'Keyword Based List')
		end 
    --  
    FETCH NEXT FROM db_cursor_lidata_ml INTO @id, @Title, @summary, @organization, @Name
  END
  CLOSE db_cursor_lidata_ml
  DEALLOCATE db_cursor_lidata_ml
END
