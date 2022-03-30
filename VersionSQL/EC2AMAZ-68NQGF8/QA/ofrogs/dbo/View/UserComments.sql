/****** Object:  View [dbo].[UserComments]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE view UserComments
As
SELECT        dbo.ProductReview.ID, dbo.Magazine.Name, dbo.ProductReview.UserComment, CASE WHEN Usercomment LIKE '%Smell%' OR
                         Usercomment LIKE '%aroma%' THEN 'Smell' WHEN Usercomment LIKE '%look%' OR
                         Usercomment LIKE '%color%' OR
                         Usercomment LIKE '%Copper color%' OR
                         Usercomment LIKE '%apperance%' OR
                         Usercomment LIKE '%design%' OR
                         Usercomment LIKE '%pale gold%' OR
                         Usercomment LIKE '%colour%' OR
                         Usercomment LIKE '%Brown%' THEN 'Look' WHEN Usercomment LIKE '%taste%' OR
                         Usercomment LIKE '%flavor%' OR
                         Usercomment LIKE '%carbonate%' OR
                         Usercomment LIKE '%flavour%' OR
                         Usercomment LIKE '%sweet%' OR
                         Usercomment LIKE '%piss%' OR
                         Usercomment LIKE '%lime%' OR
                         Usercomment LIKE '%lemon%' OR
                         Usercomment LIKE '%tastes like water%' THEN 'Taste' WHEN Usercomment LIKE '%feel%' THEN 'Feel' 
						 else 'Nothing'
						 END AS Label, case
						  WHEN usercomment LIKE '%waste%' OR
                         usercomment LIKE '%piss%' OR
                         Usercomment LIKE '%pee%' OR
                         usercomment LIKE '%nothing good%' OR
                         usercomment LIKE '%not good%' OR
                         usercomment LIKE '%shit%' OR
                         usercomment LIKE '%disappoint%' OR
                         usercomment LIKE '%terrible%' OR
                         usercomment LIKE '%Bad%' OR
                         usercomment LIKE '%disgusting%' OR
                         usercomment LIKE '%chlorine water%' OR
                         usercomment LIKE '%idiot%' OR
                         usercomment LIKE '%crap%' OR
                         usercomment LIKE '%Extermly poor%' OR
                         usercomment LIKE '%not that impressive%' OR
                         usercomment LIKE '%no reason to drink this%' OR
                         usercomment LIKE '%sucks%' OR
                         usercomment LIKE '%worst%' OR
                         usercomment LIKE '%lack%' OR
                         usercomment LIKE '%garbage%' OR
                         usercomment LIKE '%skunky water%' OR
                         usercomment LIKE '%looks unwell%' OR
                         usercomment LIKE '%last option%' OR
                         usercomment LIKE '%drink only if it is free%' OR
                         Usercomment LIKE '%least favorite%' OR
                         usercomment LIKE '%worse%' THEN 'Negative' 

						 WHEN usercomment LIKE '%not disgusting%' OR
                         usercomment LIKE '%Great beer%' OR
                         usercomment LIKE '%Refreshing%' OR
                         usercomment LIKE '%Pleasant%' OR
                         Usercomment LIKE '%decent%' OR
                         Usercomment LIKE '%iconic%' OR
                         Usercomment LIKE '%best%' OR
                         Usercomment LIKE '%high quality%' OR
                         Usercomment LIKE '%Significant%' OR
                         Usercomment LIKE '%privileged%' OR
                         Usercomment LIKE '%Excellent%' THEN 'Positive' 

						 ELSE 'Nothing'	end as 'Sentiment'
FROM            dbo.ProductReview INNER JOIN
                         dbo.Magazine ON dbo.ProductReview.MagazineID = dbo.Magazine.Id
