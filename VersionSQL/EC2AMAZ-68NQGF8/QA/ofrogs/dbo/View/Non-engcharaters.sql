/****** Object:  View [dbo].[Non-engcharaters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Non-engcharaters]
AS
SELECT
 X.Rssfeeditemid
 FROM
( select  RssFeedItem.ID As 'Rssfeeditemid', RssFeedItem.Title,  RssFeed.RssSourceId, RssSource.Name as 'SourceName',RssSource.IsValid, RssSource.IsActive,
  patindex('%[^!-~]%' COLLATE Latin1_General_BIN, RssFeedItem.Title) as [Position],
  CAST( substring(RssFeedItem.Title,patindex('%[^!-~]%' COLLATE Latin1_General_BIN,RssFeedItem.Title),LEN(RssFeedItem.TITLE)) AS VARCHAR) as [InvalidCharacter],
  ascii(substring(RssFeedItem.Title,patindex('%[^!-~]%' COLLATE Latin1_General_BIN,RssFeedItem.Title),1)) as [ASCIICode]
  ,dbo.RemoveNonExtenedASCII(RssFeedItem.Title) AS ExtecnedCharacter
from  RssFeedItem
INNER JOIN RssFeed ON RssFeedItem.RssFeedid = RssFeed.id
INNER JOIN RssSource ON RssSource.id = RssFeed.RssSourceid
where (RssFeedItem.Title collate LATIN1_GENERAL_BIN != cast( RssFeedItem.Title as varchar(max))
 OR REPLACE( dbo.RemoveNonExtenedASCII(RssFeedItem.Title),' ','' )<>''
)
) X WHERE --X.Title LIKE '%Federação Mundial de H%' AND
 (len(InvalidCharacter)- len(replace(InvalidCharacter,'?','')) >2
   OR
   (len(InvalidCharacter)- len(replace(InvalidCharacter,'?','')) <=2 AND REPLACE( REPLACE ( ExtecnedCharacter,CHAR(13),' ' ), char(10),' ' ) <>'' )
 AND LEN(ExtecnedCharacter)>1
)
