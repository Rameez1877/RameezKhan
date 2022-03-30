/****** Object:  Procedure [dbo].[sp_get_linkedindata_influ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[sp_get_linkedindata_influ]
-- Add the parameters for the stored procedure here
@id1 int
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @id int
          

  DECLARE db_cursor_lidata_ml CURSOR FOR
 
  SELECT    id
    
  FROM LinkedInData gm
  WHERE EXISTS (SELECT   *
  FROM influencerlist dm
  WHERE isactive = 1
  AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), '/', ' ') + ' ') > 0)
  And gm.id=@id1

  OPEN db_cursor_lidata_ml
  FETCH NEXT FROM db_cursor_lidata_ml INTO @id

   WHILE @@FETCH_STATUS = 0
   BEGIN
     update linkedindata set decisionmaker='Influencer' where id=@id
   FETCH NEXT FROM db_cursor_lidata_ml INTO @id
   END
  CLOSE db_cursor_lidata_ml
  DEALLOCATE db_cursor_lidata_ml
END
