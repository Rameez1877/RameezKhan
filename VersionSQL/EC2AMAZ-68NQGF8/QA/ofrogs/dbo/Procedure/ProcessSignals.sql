/****** Object:  Procedure [dbo].[ProcessSignals]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessSignals]
	@IndustryId int
AS
BEGIN
/*
	This stored procedure does the following:
	1. matches with signal ID 
*/
	SET NOCOUNT ON;

		-- Insert statements for procedure here
		DECLARE @IndustrySignalAnalysis TABLE 
	(
		IndustryId int,
		rssFeedItemId int,
		tagName varchar(100), 
		signalWord varchar(100),
		pubDate varchar(6) 
		--year int
		
	)

	
	 insert into @IndustrySignalAnalysis
	select @IndustryId, RF.id, T.name as tagName, 
	RFS.signalword,  REPLACE(CONVERT(VARCHAR(6), RF.PubDate, 0),' ','')
	from rssfeeditemsignal RFS, rssfeeditemtag RFT, tag T, rssfeeditem RF
	where RFS.rssfeeditemid = RFT.rssfeeditemid
	and RFT.tagid= T.id
	and t.tagtypeid = 1
	and RF.id = RFT.rssfeeditemid

	select ISA2.tagName, ISA2.pubDate, STUFF((select distinct ',' + signalWord
	from 	 @IndustrySignalAnalysis ISA1
	where 
		ISA1.tagName = ISA2.tagName FOR XML PATH('')),1,1,'') AS SignalWords	
					 
		from @IndustrySignalAnalysis ISA2
		group by ISA2.tagName, ISA2.pubDate

	END
