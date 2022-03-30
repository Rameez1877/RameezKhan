/****** Object:  Procedure [dbo].[sp_get_datacontent_by_means_main]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_means_main]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
	SET NOCOUNT ON;
	DECLARE @Section varchar(20)
  DECLARE db_cursor_main CURSOR FOR 

  select section from datacontentsectionposition where id =Id

OPEN db_cursor_main  
FETCH NEXT FROM db_cursor_main INTO @Section  

WHILE @@FETCH_STATUS = 0  
BEGIN  
     
	 exec sp_get_datacontent_by_means @id,@Section
      FETCH NEXT FROM db_cursor_main INTO @Section 
END 

CLOSE db_cursor_main  
DEALLOCATE db_cursor_main 
END
