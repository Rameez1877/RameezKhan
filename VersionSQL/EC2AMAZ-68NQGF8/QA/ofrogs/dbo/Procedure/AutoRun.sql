/****** Object:  Procedure [dbo].[AutoRun]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoRun] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @appuserid INT

	--declare @count int = 0
	
	DECLARE cur CURSOR FOR SELECT distinct Id from dbo.AppUser order by Id

	OPEN cur

	FETCH NEXT FROM cur INTO @appuserid

	WHILE @@FETCH_STATUS = 0
	BEGIN

		--set @count = @count + @appuserid
		
		exec dbo.AppUserKnowledgeGraph @appuserid

		exec dbo.AppUserKnowledgeGraph2 @appuserid

		exec RssCustomerTargetTagging @appuserid

		FETCH NEXT FROM cur INTO @appuserid
	END

	CLOSE cur
	DEALLOCATE cur

	--select @count as Count

begin
	DECLARE @RowsToProcessnew  int 
    DECLARE @CurrentRownew     int 
	DECLARE @SelectCol1new     varchar(100)  
   
	DECLARE @table1new TABLE (RowIDnew int not null primary key identity(1,1), col1new varchar(100))  
	 
			 INSERT into @table1new (col1new) select Name  from Organization where DATEDIFF(d, CreatedDate, GETDATE()) =1 and IsActive=1 
			 --INSERT into @table1new (col1new) select Name  from Organization where Name='nestle' and IsActive=1
		
			  SET @RowsToProcessnew=@@ROWCOUNT  
			  SET @CurrentRownew=0        
			  WHILE @CurrentRownew<@RowsToProcessnew
			      BEGIN           
					    SET @CurrentRownew=@CurrentRownew+1
					    SELECT @SelectCol1new=col1new FROM @table1new WHERE RowIDnew=@CurrentRownew  
						--'DECLARE cur1 CURSOR FOR  SELECT @SelectCol1new=col1new FROM @table1new WHERE RowIDnew=@CurrentRownew  
		                Begin
						
		                exec ProcessRssFeedItem2 @SelectCol1new ,2017
		                 end	
				   END
		
    end

END
