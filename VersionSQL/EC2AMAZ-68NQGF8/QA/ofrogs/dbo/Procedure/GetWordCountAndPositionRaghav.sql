/****** Object:  Procedure [dbo].[GetWordCountAndPositionRaghav]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE GetWordCountAndPositionRaghav @linkedindataId int
AS
	Declare @functionality varchar(200);
	Declare @wordCount int;

	select @functionality = functionality from LinkedInDatatemp where id = @linkedindataid
	--Print @functionality

	SELECT @wordCount = LEN(@functionality) - LEN(REPLACE(@functionality, ' ', '')) + 1

	Print @functionality
	Print @wordCount
