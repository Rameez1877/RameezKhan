/****** Object:  Procedure [dbo].[AnalyzeSentiment]    Committed by VersionSQL https://www.versionsql.com ******/

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
CREATE procedure AnalyzeSentiment
	
AS
BEGIN

	SET NOCOUNT ON;
	

DECLARE @SentimentWords TABLE 
	(
		ProductReviewID int,
		MagazineName varchar(max),
		UserComment varchar(max),
		Sentiment varchar(max),
		SentimentWord varchar(max)
	)
	
insert into @SentimentWords
SELECT DISTINCT dbo.ProductReview.ID AS ProductReviewID, dbo.Magazine.Name AS MagazineName, 
dbo.ProductReview.UserComment, dbo.ReviewDictionary.Sentiment, dbo.ReviewDictionary.SentimentWord
FROM            dbo.ProductReview INNER JOIN
                         dbo.Magazine ON dbo.ProductReview.MagazineID = dbo.Magazine.Id CROSS JOIN
                         dbo.ReviewDictionary
WHERE        dbo.ProductReview.UserComment LIKE '%' + dbo.ReviewDictionary.SentimentWord + '%'

select TN2.magazineName,  TN2.Sentiment,
	STUFF((select distinct ',' + TN1.sentimentword
	from @SentimentWords TN1
	where 
		TN2.magazineName = TN1.magazineName
		and TN2.Sentiment = TN1.Sentiment 
	
		FOR XML PATH('')),1,1,'') AS sentimentwordCollection	
		from @SentimentWords TN2
		group by  TN2.magazineName,  TN2.Sentiment
		order by  TN2.magazineName,  TN2.Sentiment

	End
