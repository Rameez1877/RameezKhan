/****** Object:  Function [dbo].[ParsePubDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 3 Sept, 2016
-- Description:	Parse Rss pubDate
-- =============================================
CREATE FUNCTION [dbo].[ParsePubDate] 
(
	@pubDate varchar(50)
)
RETURNS DateTime
AS
BEGIN
	If @pubDate is null or @pubDate = ''
	Begin
		return GetUtcDate()
	End
	If len(@pubDate) <= 19 -- Length 19 means its pure date time format without TimeZone
	Begin
		return convert(datetime, @pubDate)
	End
	set @pubDate = RIGHT(@pubDate, LEN(@pubDate) - CHARINDEX(' ', @pubDate))
	declare @zone varchar(10), @offset varchar(10)
	set @zone = Right(@pubDate, CHARINDEX(' ', REVERSE(@pubDate)) - 1)
	select @offset = UtcOffset from TimeZone where [Zone] = @zone
	set @pubDate = replace(@pubDate, @zone, @offset)
	return convert(datetime, cast(@pubDate as datetimeoffset), 1)
END
