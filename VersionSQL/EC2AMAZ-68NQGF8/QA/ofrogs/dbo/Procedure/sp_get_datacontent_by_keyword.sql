/****** Object:  Procedure [dbo].[sp_get_datacontent_by_keyword]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Janna
-- Create date: Sep 10, 2018
-- Description:    For a given document gets all section numbers
-- Prerequisite: TOC should start with keyword Section and ends before keyword SCHEDULES
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_keyword]
-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
delete datacontentposition where id = @id
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
	create table #datacontentposition(section varchar(20))
    DECLARE @datacontent varchar(max), @TOCEndPosition int,@TOCStartPosition int,@TocSectionData varchar(8000)
	DECLARE @SectionNumbers varchar(15), @SectionKWPosition int, @i int
    SELECT
        @datacontent = datacontent
    FROM datacontent
    WHERE id = @id;
	--
	-- Get the section end where the word start as 'SCHEDULE' and start poistiin which start with word 'Section'
	--
	select 
	@TOCStartPosition = charindex('Section',@datacontent),
	@TOCEndPosition = charindex('SCHEDULES',@datacontent)
	print @TOCStartPosition
	print @TOCEndPosition

	set @TocSectionData = SUBSTRING(@datacontent,@TOCStartPosition,@TOCEndPosition-@TOCStartPosition)
	set @i = 0
	WHILE (len(@TocSectionData)>0)
BEGIN
    set @i = @i+ 1
	SET @SectionKWPosition =  charindex('Section ',@TocSectionData)
	If @SectionKWPosition > 0 
	begin
		SET @SectionKWPosition = @SectionKWPosition + 8
		SET @TocSectionData =  substring(@TocSectionData,@SectionKWPosition,len(@TocSectionData))
		SET @SectionNumbers = 'Section ' + Substring(@TocSectionData,1,4)
		--print 'i=:' + str(@i) + ' ' +   @SectionNumbers 
		Insert into #datacontentposition
		values(@SectionNumbers)
		If charindex('Section ',@TocSectionData) = 0 
		break
	end 
	else
	SET @TocSectionData = ''
END

--delete datacontentposition where id = @id
--
DECLARE db_cursor CURSOR FOR 
Select section from #datacontentposition

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @SectionNumbers  

WHILE @@FETCH_STATUS = 0  
BEGIN  

--
INSERT into datacontentposition
SELECT @id,@SectionNumbers, pos 
FROM dbo.FindPatternLocation(@datacontent, @SectionNumbers)

---
      FETCH NEXT FROM db_cursor INTO @SectionNumbers 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 
END
