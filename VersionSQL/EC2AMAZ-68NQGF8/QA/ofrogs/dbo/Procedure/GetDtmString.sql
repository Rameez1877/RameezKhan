/****** Object:  Procedure [dbo].[GetDtmString]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 2 June 2016
-- Description:	Stored Procedure to generate Document Term Matrix for a given RssFeedItem
-- =============================================
CREATE PROCEDURE [dbo].[GetDtmString]
	@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @News nvarchar(max)
	select @News = [Description] from RssFeedItem where Id = @RssFeedItemId
	set @News = dbo.StripHtml(@News)

	declare @Words table(Word varchar(1000))
	declare @RootWords table(Word varchar(1000))
	declare @RootWordsString varchar(max)

	insert into @Words
	select Word
	from 
		dbo.SplitString(@News, ' ') S 
		left join BadWord B on (S.Word = B.Name)
	where 
		B.Name is null
		and ISNUMERIC(Word) <> 1

	select * into #Words from @Words 

	insert into @RootWords
	execute sp_execute_external_script
	  @language = N'R'
	, @script = N'
 
	   library("slam", lib.loc="C:\\OceanfrogsR");
	   library("NLP", lib.loc="C:\\OceanfrogsR");
	   library("tm", lib.loc="C:\\OceanfrogsR");
		library("SnowballC", lib.loc="C:\\OceanfrogsR");
    
			a <- as.matrix(InputDataSet$Word);
			OutputDataSet <- as.data.frame(stemDocument(a));
			print (OutputDataSet);
							 '
		, @input_data_1 = N' select [Word] from #Words;'   
	
	-- select * from @RootWords
	select @RootWordsString = COALESCE(@RootWordsString  + ', ', '') + Word FROM @RootWords

	--select 'IndustryId = ' + convert(varchar(16), O.IndustryId) + ', RssFeedItemID = ' + convert(varchar(16), @RssFeedItemId)
	--	+ ', Words = ' + @RootWordsString

	select O.IndustryId, @RssFeedItemId as RssFeedItemId, @RootWordsString as Words
	from 
		Tag T
		-- inner join IndustryTag IT on (T.Id = IT.TagId)
		inner join Organization O on (O.Name = T.Name)
	where 
		CHARINDEX(T.Name, @News) > 0
END
