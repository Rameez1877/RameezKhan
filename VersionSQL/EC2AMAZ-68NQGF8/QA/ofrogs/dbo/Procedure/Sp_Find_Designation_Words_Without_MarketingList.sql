/****** Object:  Procedure [dbo].[Sp_Find_Designation_Words_Without_MarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Find_Designation_Words_Without_MarketingList]
	
AS
BEGIN

	SET NOCOUNT ON;

select distinct designation into #TempDesignation
from linkedindata li where len(url)>5 and 
 exists(select * from mcdecisionmakerlist mc
where li.id = mc.decisionmakerid and mc.mode='keyword based list'
and name='Others')
and tagid = 0
SELECT designation, VALUE as Keyword into #TempKeywords
FROM #TempDesignation AS PP
    CROSS APPLY STRING_SPLIT(designation, ' ') AS SPL
declare @a int
	select @a= count(*) from #TempKeywords
	print @a

	delete from #TempKeywords
	where Keyword in ('`',
'~',
'!',
'@',
'#',
'$',
'%',
'^',
'&',
'*',
'(',
')',
'_',
'+',
'=',
'-',
'|',
'\',
'[',
'{',
']',
'}',
'|',
'\',
';',
':',
'''',
'"',
',',
'<',
'.',
'>',
'/',
'?'
)
select @a= count(*) from #TempKeywords
	print @a

	
	delete from #TempKeywords
	where Keyword in (select name from badword)

	select @a= count(*) from #TempKeywords
	print @a

	delete from #TempKeywords
	where Keyword in ('i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your', 'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her', 'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having', 'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'but', 'if', 'or', 'because', 'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in', 'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don', 'should', 'now','for','mm')

	select @a= count(*) from #TempKeywords
	print @a

	delete from #TempKeywords
	where  LEN(Keyword) < 2

	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords
	where
 CHARINDEX('-', Keyword) > 0
    AND ISNUMERIC(REPLACE(Keyword, '-', '')) = 1
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword
	IN ('brown', 'black', 'red', 'brown', 'white', 'red', 'blue', 'gray', 'green')
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword = '**'
    OR Keyword = '***'
    OR Keyword = '****'
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword
	in(select name from country)
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword
	in(select name from state)
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword
	in(select name from city)
	select @a= count(*) from #TempKeywords
	print @a
	delete from #TempKeywords where Keyword
	in(select name from continent)
	select @a= count(*) from #TempKeywords
	print @a

	delete  from #TempKeywords where Keyword
	LIKE '%[^0-9a-zA-Z ]%'
	select @a= count(*) from #TempKeywords
	print @a
	delete  from #TempKeywords where Keyword
	NOT LIKE '%[^0-9]%'
	select @a= count(*) from #TempKeywords
	print @a
	select Keyword, count(*) NoOfREcords  from #TempKeywords 
	group by Keyword Order By  count(*)  desc
END
