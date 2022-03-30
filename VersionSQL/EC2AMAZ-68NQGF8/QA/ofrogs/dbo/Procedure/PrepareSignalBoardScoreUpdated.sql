/****** Object:  Procedure [dbo].[PrepareSignalBoardScoreUpdated]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PrepareSignalBoardScoreUpdated]
	@IndustryId int
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	--DECLARE @OutputIndustrySignalScore TABLE 
	--(
	--	tagId int,
	--	tagName varchar(100),
	--	score int,
	--	scoreDate Date
	--)
	delete from outputtagscore where IndustryID = @IndustryId
	insert into OutputTagScore
	select y.tagId, y.tagname, round(sum(y.signal_score)*(10/10),0), GetDate(), @IndustryId from 
	(
	select  tagID, tagName,  NewsQuarter,
	S.SignalWeight as signal_score
	 from Signal S, (
	select distinct tagID, tagName, NewsQuarter, displayName from 
	OutputIndustrySignalAnalysis OISA
	where 
	OISA.IndustryId = @IndustryId
	
	) x
	where x.displayname = S.displayname
	group by x.tagID, x.tagName, x.NewsQuarter, x.DisplayName, S.SignalWeight) y
	group by y.tagID, y.tagName
	order by tagid, tagname

END
