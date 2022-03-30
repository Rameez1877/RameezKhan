/****** Object:  Procedure [dbo].[sp_get_linkedindata_marketinglist]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_get_linkedindata_marketinglist]
-- Add the parameters for the stored procedure here  
@id int
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;
  DECLARE @Title varchar(100),
          @Summary varchar(max),
          @organization varchar(max),
          @Count int,
          @Name varchar(200)

  DELETE FROM McDecisionmakerlist
  WHERE mode = 'Keyword Based List'
  and id = @id
 
  DECLARE db_cursor_lidata_ml CURSOR LOCAL FOR
  SELECT
    id,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  title,
    REPLACE(REPLACE(REPLACE(summary, ',', ' '), '.', ' '), '/', ' ') summary,
    organization,
    name
  FROM LinkedInData gm
  WHERE 
  --EXISTS (SELECT
  --  *
  --FROM decisionmakerlist dm
  --WHERE isactive = 1
  --AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  + ' ') > 0)
  --AND
   id = @id

  OPEN db_cursor_lidata_ml
  FETCH NEXT FROM db_cursor_lidata_ml INTO @id, @Title, @summary, @organization, @Name

  WHILE @@FETCH_STATUS = 0
  BEGIN
  

    INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT distinct
        1 AppUserId,
        @id DecisionMakerId,
        @Name DecisionMakerlistName,
        1 IsActive,
        t1.Name MarketingListName,
        'Keyword Based List'
      FROM McDecisionMaker t1
      WHERE t1.IsOFList = 1
	  and ISactive=1
      AND CHARINDEX(' ' + t1.keyword + ' ', ' ' + @Title + ' ') > 0
      AND t1.Name <> 'Others'
    SET @Count = @@ROWCOUNT
    --
    -- If the decision maker is not part of any Marketing List, Push him to Marketing Group as 'Others'
    --
    IF @Count = 0
    BEGIN

      INSERT INTO McDecisionmakerlist (AppUserId,
      DecisionMakerId,
      DecisionMakerlistName,
      IsActive,
      Name,
      Mode)
        VALUES (1, @id, @Name, 1, 'Others', 'Keyword Based List')
	  END

	  --update LinkedInData set decisionmaker ='DecisionMaker' where id = @id
    --  
    FETCH NEXT FROM db_cursor_lidata_ml INTO @id, @Title, @summary, @organization, @Name
  END
  CLOSE db_cursor_lidata_ml
  DEALLOCATE db_cursor_lidata_ml

update LinkedInData set decisionmaker ='DecisionMaker'
where  id = @id


END
