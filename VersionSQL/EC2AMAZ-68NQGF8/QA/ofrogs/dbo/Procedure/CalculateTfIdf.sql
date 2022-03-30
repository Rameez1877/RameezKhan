/****** Object:  Procedure [dbo].[CalculateTfIdf]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 26 Nov, 2016
-- Description:	Stored Procedure to calculate the Tf-Idf of the Rss Feed News.
-- =============================================
CREATE PROCEDURE [dbo].[CalculateTfIdf]
	@IndustryId int
AS
BEGIN
	SET NOCOUNT ON;

	declare @TotalDocuments int 
	select @TotalDocuments = count(1) from RssFeedItem R inner join RssFeedItemIndustry RI on R.Id = RI.RssFeedItemId where IndustryId = @IndustryId

	delete from dbo.TfIdf where IndustryId = @IndustryId

	select Word, count(Word) WordDocCount
	into #WordDocs
	from
		DocumentTermMatrix D
		inner join RssFeedItemIndustry RI on (D.RssFeedItemId = RI.RssFeedItemId)
	where
		IndustryId = @IndustryId
	group by
		Word
		
	insert into dbo.TfIdf
	select D.RssFeedItemId, @IndustryId, D.Word, Frequency, Tf, log10(@TotalDocuments*1.0/W.WordDocCount), Tf*log10(@TotalDocuments*1.0/W.WordDocCount)
	from
		DocumentTermMatrix D
		inner join RssFeedItemIndustry RI on (D.RssFeedItemId = RI.RssFeedItemId)
		inner join #WordDocs W on (D.Word = W.Word)
	where
		RI.IndustryId = @IndustryId

	--update D
	--set
	--	Idf = log10(@TotalDocuments*1.0/W.WordDocCount)
	--from
	--	DocumentTermMatrix D
	--	inner join RssFeedItemIndustry RI on (D.RssFeedItemId = RI.RssFeedItemId)
	--	inner join #WordDocs W on (D.Word = W.Word)
	--where
	--	RI.IndustryId = @IndustryId

	--update D
	--set
	--	TfIdf = Tf*Idf
	--from
	--	DocumentTermMatrix D
	--	inner join RssFeedItemIndustry RI on (D.RssFeedItemId = RI.RssFeedItemId)
	--where
	--	RI.IndustryId = @IndustryId
END
