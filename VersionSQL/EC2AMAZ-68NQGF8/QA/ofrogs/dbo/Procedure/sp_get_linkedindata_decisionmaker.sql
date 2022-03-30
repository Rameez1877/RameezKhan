/****** Object:  Procedure [dbo].[sp_get_linkedindata_decisionmaker]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
Create PROCEDURE [dbo].[sp_get_linkedindata_decisionmaker]
-- Add the parameters for the stored procedure here  
(@id1 int)
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @id int
          

  DECLARE db_cursor_lidata_ml1 CURSOR FOR
 
  SELECT    id
    
  FROM LinkedInData gm
  WHERE EXISTS (SELECT   *
  FROM decisionmakerlist dm
  WHERE isactive = 1
  AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(designation, ',', ' '), '.', ' '), '/', ' ') + ' ') > 0)
  And gm.id=@id1

  OPEN db_cursor_lidata_ml1
  FETCH NEXT FROM db_cursor_lidata_ml1 INTO @id

   WHILE @@FETCH_STATUS = 0
   BEGIN
     update linkedindata set decisionmaker='Decisionmaker' where id=@id
   FETCH NEXT FROM db_cursor_lidata_ml1 INTO @id
   END
  CLOSE db_cursor_lidata_ml1
  DEALLOCATE db_cursor_lidata_ml1
END
