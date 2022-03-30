/****** Object:  Procedure [dbo].[GenerateDTM]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 2 June 2016
-- Description:	Stored Procedure to generate Document Term Matrix for a given RssFeedItem
-- =============================================
CREATE PROCEDURE [dbo].[GenerateDTM]
	@RssFeedItemId int
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @News nvarchar(max)
	select @News = News from RssFeedItem where Id = @RssFeedItemId
	--set @News = cast(@News as varchar(max)) COLLATE SQL_Latin1_General_CP1253_CI_AI
	
	---- Generate RootWords
	--set @News = dbo.StripHtml(@News)

	declare @RootWords table(Word varchar(1000))
	declare @RootWordsString varchar(max)

	select Word into #Words
	from 
		dbo.SplitString(@News, ' ') S 
		left join BadWord B on (S.Word = B.Name)
	where 
		B.Name is null
		and ISNUMERIC(Word) <> 1
		
	insert into @RootWords
	execute sp_execute_external_script
	  @language = N'R'
	, @script = N'
		library("NLP", lib.loc="C:\\OceanfrogsR");
		library("tm", lib.loc="C:\\OceanfrogsR");
		library("SnowballC", lib.loc="C:\\OceanfrogsR");
		a <- as.matrix(InputDataSet$Word);
		OutputDataSet <- as.data.frame(stemDocument(a));'
		, @input_data_1 = N' select [Word] from #Words;'   
	
	select @RootWordsString = COALESCE(@RootWordsString  + ', ', '') + Word FROM @RootWords

	update RssFeedItem
	set RootWords = isnull(@RootWordsString, '')
	where
		Id = @RssFeedItemId

	insert into DocumentTermMatrix
	select @RssFeedItemId, Word, count(1) as Frequency
	from 
		@RootWords
	group by Word
END
