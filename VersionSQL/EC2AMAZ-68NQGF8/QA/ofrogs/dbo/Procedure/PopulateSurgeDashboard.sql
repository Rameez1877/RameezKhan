/****** Object:  Procedure [dbo].[PopulateSurgeDashboard]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Janna
-- Create date: 7th Jan 2020
-- Description:	Generate Surge Dashboard For All Active Users
-- =============================================
CREATE PROCEDURE PopulateSurgeDashboard

AS
BEGIN
Declare @Query Nvarchar(1000)
	DECLARE db_surge_cursor CURSOR FOR 
SELECT  'PopulateSurgeDashboardPerUserID ' + ltrim(str(id)) as Query 
from AppUser Where IsActive =1


OPEN db_surge_cursor  
FETCH NEXT FROM db_surge_cursor INTO @Query  

WHILE @@FETCH_STATUS = 0  
BEGIN  
     
	  exec  sp_executesql @Query
      FETCH NEXT FROM db_surge_cursor INTO @Query 
END 

CLOSE db_surge_cursor  
DEALLOCATE db_surge_cursor 
END
