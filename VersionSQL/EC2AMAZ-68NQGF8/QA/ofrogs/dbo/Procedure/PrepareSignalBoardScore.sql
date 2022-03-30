/****** Object:  Procedure [dbo].[PrepareSignalBoardScore]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PrepareSignalBoardScore]
	@IndustryId int = 0
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
if @IndustryId <> 0 
		Begin
			delete from outputtagscore WHERE outputtagscore.scoredate = CONVERT(date,getdate()) AND IndustryId in(@IndustryId)
			insert into OutputTagScore (tagid, tagName, Score, ScoreDate,IndustryId)
			select y.tagId, y.tagname, cast(round(sum(y.signalweight * 0.83),0) as int), GetDate(),@IndustryId from 
			(
			select  x.tagID, x.tagName, x.NewsQuarter,  x.IndustryId,
	
		   sum(x.signalscore) as signalweight
			from (
			 select distinct O.tagID, O.tagName, O.NewsQuarter, O.displayName, O.IndustryId, S.signalweight as signalscore from 
			 OutputIndustrySignalAnalysis O, Signal S
			 where 
			 O.IndustryId in( @IndustryId)
			and S.displayName = O.displayName
			---and tagid = 217
		   ) x
		   group by x.tagID, x.tagName, x.NewsQuarter,  x.IndustryId) y
		   group by y.tagID, y.tagName
		   order by tagid, tagname
		 end
    Else
		  begin
		  delete from outputtagscore WHERE outputtagscore.scoredate = CONVERT(date,getdate()) 
			insert into OutputTagScore (tagid, tagName, Score, ScoreDate,IndustryId)
			select y.tagId, y.tagname, cast(round(sum(y.signalweight * 0.83),0) as int), GetDate(),y.IndustryId from 
			(
			select  x.tagID, x.tagName, x.NewsQuarter,  x.IndustryId,
	
		   sum(x.signalscore) as signalweight
			from (
			 select distinct O.tagID, O.tagName, O.NewsQuarter, O.displayName, O.IndustryId, S.signalweight as signalscore from 
			 OutputIndustrySignalAnalysis O, Signal S
			 where 
			 S.displayName = O.displayName
			---and tagid = 217
		   ) x
		   group by x.tagID, x.tagName, x.NewsQuarter,  x.IndustryId) y
		   group by y.tagID, y.tagName,y.IndustryId
		   order by tagid, tagname
		  end
   END
