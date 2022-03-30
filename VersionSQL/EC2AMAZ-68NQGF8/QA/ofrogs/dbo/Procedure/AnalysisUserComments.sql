/****** Object:  Procedure [dbo].[AnalysisUserComments]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[AnalysisUserComments]
As
Begin

declare @AnalyseComment TABLE
(
	id INT,
	Beername varchar(max),
	usercomment VARCHAR(MAX),
	label VARCHAR(MAX),
	Sentiment VARCHAR(MAX)
)

insert into @AnalyseComment(id, Beername , usercomment, label, Sentiment) 
Select ProductReview.id, name, usercomment,  case
	when Usercomment like '%Smell%' or 
		 Usercomment like '%aroma%' 
		 then 'Smell'

	when Usercomment like '%look%' or
		 Usercomment like '%color%' or
		 Usercomment like '%Copper color%' or
		 Usercomment like '%apperance%' or
		 Usercomment like '%design%' or
		 Usercomment like '%Beautiful%' or
		 Usercomment like '%pale gold%' or
		  Usercomment like '%colour%' or
		Usercomment like '%Brown%'
		 then 'Look'
	
	when Usercomment like '%taste%' or
		 Usercomment like '%flavor%' or
		 Usercomment like '%carbonate%' or
		 Usercomment like '%flavour%' or
		 Usercomment like '%sweet%' or
		 Usercomment like '%piss%' or
		 Usercomment like '%lime%' or
		 Usercomment like '%lemon%' or
		 Usercomment like '%water%'
		 then 'Taste'
	
	when Usercomment like '%feel%' 
		 then 'Feel'

	else 'nothing'
	end Label, 
	case
	when usercomment like '%waste%' or
		 usercomment like '%piss%' or
		 Usercomment like '%pee%' or
		 usercomment like '%nothing good%' or
         usercomment like '%not good%' or
		 usercomment like '%shit%' or
		 usercomment like '%disappoint%' or
		 usercomment like '%Bad%' or
		 usercomment like '%disgusting%' or
		 usercomment like '%idiots%'or 
		 usercomment like '%crap%' or
		 usercomment like '%Extermly poor%' or
		 usercomment like '%awful%' or
		 usercomment like '%not that impressive%' or
		 usercomment like '%sucks%' or
		 usercomment like '%worst%' or
		 usercomment like '%lack%' or
		 usercomment like '%worse%'
		 then 'negative'

	when usercomment like '%not disgusting%' or
		 usercomment like '%Great beer%' or
		 usercomment like '%Refreshing%' or
		 usercomment like '%special%' or
       	 Usercomment like '%Standard%' or 
		 usercomment like '%Pleasant%'  or
		 Usercomment like '%decent%' or 
		 Usercomment like '%iconic%' or 
		 Usercomment like '%Latest%' or 
		 Usercomment like '%best%' or
		 Usercomment like '%quality%' or
		 		 Usercomment like '%positive%' or
				 Usercomment like '%win%' or
				 Usercomment like '%wow%' or
				 Usercomment like '%good%' or
		 Usercomment like '%Sinificant%' or
		 Usercomment like '%privileged%' or
		 Usercomment like '%Excellent%'
		 then 'positive'
	else 'nothing'
	End


from ProductReview, Magazine 
where ProductReview.MagazineID = Magazine.id

Select Beername, usercomment, label, Sentiment--count(*) as Count 
from @AnalyseComment
group by Beername, usercomment, label, Sentiment
order by count(*) desc

/*Create view AnalyseComment
As
Select * from @AnalyseComment*/
End
