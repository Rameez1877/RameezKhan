/****** Object:  View [dbo].[UserCommentsNew]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view UsercommentsNew
As
SELECT DISTINCT 
 dbo.ProductReview.ID AS ProductReviewID, 
 dbo.Magazine.Name AS MagazineName, 
 dbo.ProductReview.UserComment, 
 dbo.ReviewDictionary.Sentiment as SentimentHelp, 
 dbo.ReviewDictionary.SentimentWord,
 case when dbo.ReviewDictionary.Sentiment like '%Positive%' then 'Positive'
	  when dbo.ReviewDictionary.Sentiment like '%Negative%' then 'Negative'
	  else 'Nothing'
	  end as Sentiment,
 case when dbo.ReviewDictionary.Sentiment like '%Look%' then 'Look'
	  when dbo.ReviewDictionary.Sentiment like '%Feel%' then 'Feel'
	  when dbo.ReviewDictionary.Sentiment like '%Smell%' then 'Smell'
	  when dbo.ReviewDictionary.Sentiment like '%Taste%' then 'Taste'
	  else 'Nothing'
	  end as Label
FROM  dbo.ProductReview INNER JOIN
                         dbo.Magazine ON dbo.ProductReview.MagazineID = dbo.Magazine.Id CROSS JOIN
                         dbo.ReviewDictionary
WHERE        (dbo.ProductReview.UserComment LIKE '%' + dbo.ReviewDictionary.SentimentWord + '%')
