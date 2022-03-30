/****** Object:  Procedure [dbo].[sp_get_datacontent_by_multiple_sections]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_multiple_sections]
@id Int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    declare @sectioncontent varchar(max), @StartPos Int, @EndPos Int, @DataOfInterest varchar(500),@Section varchar(15)
    delete datacontentsectionoutput where id = @id

	DECLARE db_cursor CURSOR FOR 
	select section, sectioncontent  from datacontentsections
	where id = @id
	order by 1
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @Section,@sectioncontent  
WHILE @@FETCH_STATUS = 0  
BEGIN  
print @Section
     If charindex('(b)',@sectioncontent) > 0 -- has something with (a),(b),(c)
	 begin
	 -- (a)
	 SET @StartPos = charindex('(a)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 SET @EndPos = charindex('(b)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 If @StartPos > 0 and @EndPos >0 and @EndPos > @StartPos
	 begin
	 SET @DataOfInterest = substring(substring(@sectioncontent,@StartPos,(@EndPos-@StartPos)-1),1,500)
	insert into datacontentsectionoutput values(@id,@Section,@DataOfInterest,1)
	 end
	  -- (b)
	 SET @StartPos = charindex('(b)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 SET @EndPos = charindex('(c)',@sectioncontent COLLATE Latin1_General_CS_AS)
	
	 If @StartPos > 0 and @EndPos >0 and @EndPos > @StartPos
	 begin
	 SET @DataOfInterest = substring(substring(@sectioncontent,@StartPos,(@EndPos-@StartPos)-1),1,500)
	 insert into datacontentsectionoutput values(@id,@Section,@DataOfInterest,2)
	 end
	  -- (c)
	 SET @StartPos = charindex('(c)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 SET @EndPos = charindex('(d)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 If @StartPos > 0 and @EndPos >0 and @EndPos > @StartPos
	 begin
	 SET @DataOfInterest = substring(substring(@sectioncontent,@StartPos,(@EndPos-@StartPos)-1),1,500)
	 insert into datacontentsectionoutput values(@id,@Section,@DataOfInterest,3)
	 end
	   -- (d)
	 SET @StartPos = charindex('(d)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 SET @EndPos = charindex('(d)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 If @StartPos > 0 and @EndPos >0 and @EndPos > @StartPos
	 begin
	 SET @DataOfInterest = substring(substring(@sectioncontent,@StartPos,(@EndPos-@StartPos)-1),1,500)
	 insert into datacontentsectionoutput values(@id,@Section,@DataOfInterest,4)
	 end
	    -- (e)
	 SET @StartPos = charindex('(e)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 SET @EndPos = charindex('(f)',@sectioncontent COLLATE Latin1_General_CS_AS)
	 If @StartPos > 0 and @EndPos >0 and @EndPos > @StartPos
	 begin
	 SET @DataOfInterest = substring(substring(@sectioncontent,@StartPos,(@EndPos-@StartPos)-1),1,500)
	 insert into datacontentsectionoutput values(@id,@Section,@DataOfInterest,5)
	 end
	 end	  
      FETCH NEXT FROM db_cursor INTO @Section,@sectioncontent 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 
END
