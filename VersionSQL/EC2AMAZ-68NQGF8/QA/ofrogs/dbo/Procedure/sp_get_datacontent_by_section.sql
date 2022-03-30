/****** Object:  Procedure [dbo].[sp_get_datacontent_by_section]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_get_datacontent_by_section] 
	-- Add the parameters for the stored procedure here
	@id int
AS
---
---
BEGIN
declare @datacontent varchar(max), @ContentOfSection varchar(max)
delete datacontentsections where id = @id
SELECT
        @datacontent = datacontent
    FROM datacontent
    WHERE id = @id 

declare @Section varchar(20), @StartPos int, @EndPos Int
DECLARE db_cursor CURSOR FOR 
select section, sectionstartpos StartNo, LEAD(sectionstartpos) OVER (ORDER BY substring(section,8,5)
) -1 EndNo
from datacontentsectionposition where id = @id order by 2

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @Section, @StartPos, @EndPos

WHILE @@FETCH_STATUS = 0  
BEGIN  
      if @EndPos is null
	  set @EndPos = len(@datacontent)

	  SET @ContentOfSection = substring(@datacontent,@StartPos,@EndPos-@StartPos)
	  Insert into datacontentsections values (@id,@Section,@ContentOfSection)
      FETCH NEXT FROM db_cursor INTO @Section, @StartPos, @EndPos
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


END
