/****** Object:  Procedure [dbo].[ProcessRssData_2017_08_29]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 03 Sept, 2016
-- Description:	Stored Procedure to process the Raw RssData.//
-- =============================================
CREATE PROCEDURE [dbo].[ProcessRssData_2017_08_29]
	@RssDataId int,
	@DeleteOnSuccess bit = 1
AS
BEGIN
	SET NOCOUNT ON;

	declare @RssFeed XML
	declare @RssSourceId int
	declare @RssFeedId int
	
	select @RssSourceId = RssSourceId, @RssFeed = XmlData from RssData where Id = 800
	BEGIN TRY  
		SELECT 
			f.title, f.link, f.[description], f.pubdate, f.[Guid]
			into #Temp
			FROM (SELECT 
					x.feed.value('title[1]', 'nvarchar(80)') AS title, 
					x.feed.value('link[1]', 'nvarchar(200)') AS link, 
					x.feed.value('description[1]', 'nvarchar(max)') AS [description], 
					dbo.ParsePubDate(x.feed.value('pubDate[1]', 'nVarchar(40)')) AS [pubdate], 
					CONVERT(VARCHAR(80), x.feed.value('guid[1]', 'nVarchar(2000)')) AS [Guid] 
					FROM    @RSSfeed.nodes('//rss/channel/item') AS x (feed) 
					) f 
			LEFT JOIN RssFeedItem I ON COALESCE(F.Title, '-') = I.Title AND COALESCE(F.[Guid], '-') = I.[Guid]
			WHERE I.Id IS NULL 

			DELETE FROM #temp  WHERE GUID IN
			(
				SELECT X.GUID
				FROM
				( select  t.*,
				  patindex('%[^!-~]%' COLLATE Latin1_General_BIN,Title) as [Position],
				  CAST( substring(Title,patindex('%[^!-~]%' COLLATE Latin1_General_BIN,Title),LEN(Title)) AS VARCHAR) as [InvalidCharacter],
				  ascii(substring(Title,patindex('%[^!-~]%' COLLATE Latin1_General_BIN,Title),1)) as [ASCIICode]
				  ,dbo.RemoveNonExtenedASCII(t.Title) AS ExtenedCharacter
				from  #Temp t
				where	(t.Title collate LATIN1_GENERAL_BIN != cast( t.Title as varchar(max))
							OR REPLACE( dbo.RemoveNonExtenedASCII(t.Title),' ','' )<>''
						)
					) X 
						WHERE --REPLACE( REPLACE ( InvalidCharacter,CHAR(13),' ' ), char(10),' ' ) NOT IN ('®',' ')
						(
							len(InvalidCharacter)- len(replace(InvalidCharacter,'?','')) >2
							OR
							(len(InvalidCharacter)- len(replace(InvalidCharacter,'?','')) <=2 AND REPLACE( REPLACE ( ExtenedCharacter,CHAR(13),' ' ), char(10),' ' ) <>'' )
							AND LEN(ExtenedCharacter)>1
						)
			)  

		

		IF EXISTS (SELECT * FROM #Temp)
		Begin
			Insert RssFeed(RssSourceId, Title, Link, [Description], [Language], Category, Docs, ManagingEditor, Webmaster, Copyright, 
				PubDate, LastBuildDate, CreatedDate)
			SELECT
				@RssSourceId,
				x.feed.value('title[1]', 'nvarchar(80)') AS title, 
				x.feed.value('link[1]', 'nvarchar(200)') AS link, 
				x.feed.value('description[1]', 'nvarchar(2000)') AS [description], 
				COALESCE(x.feed.value('language[1]', 'nVarchar(10)'), 'en-US') AS [language], 
				x.feed.value('Category[1]', 'nVarchar(100)') AS [Category], 
				x.feed.value('docs[1]', 'nVarchar(80)') AS [docs], 
				x.feed.value('managingEditor[1]', 'nVarchar(80)') AS [ManagingEditor], 
				x.feed.value('webMaster[1]', 'nVarchar(80)') AS [Webmaster],
				x.feed.value('copyright[1]', 'nVarchar(80)') AS [Copyright],
				dbo.ParsePubDate(x.feed.value('pubDate[1]', 'nVarchar(80)')) AS PubDate,
				dbo.ParsePubDate(x.feed.value('lastBuildDate[1]', 'nVarchar(80)')) AS lastBuildDate,
				getUtcDate()
			FROM
				@RssFeed.nodes('//rss/channel') AS x(feed)

			set @RssFeedId = @@Identity

			Insert RssFeedItem(RssFeedId, Title, Link, [Description], PubDate, [Guid])
			select
				@RssFeedId, Title, Link, [Description], PubDate, [Guid]
			from
				#Temp
		End
		Else
		Begin
			print ('No data to save')
		End
		If @DeleteOnSuccess = 1
			delete from RssData where Id = @RssDataId
		Else
		Begin
			update RssData 
			set
				[Status] = 'Processed'
			where Id = @RssDataId
		End
	END TRY  
	BEGIN CATCH  
		update RssData 
		set
			[Status] = 'Error'
		where Id = @RssDataId
		print ERROR_MESSAGE()
	END CATCH  
END
