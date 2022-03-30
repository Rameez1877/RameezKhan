/****** Object:  Procedure [dbo].[RunRssFeedItemSignal]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[RunRssFeedItemSignal]
@RssFeedItemId int,
@signalid int,
@industryid int,
@tagid int

AS
BEGIN


	SET NOCOUNT ON;
	
		
		DECLARE @Signalword varchar(1000)
        SET @Signalword = 
        (
           select Name from Signal where Id = @signalid
        )
		insert into rssfeeditemsignal
		(RssFeedItemId,SignalId,Signalword,IndustryId,TagId,ScoreDate)
             values(@RssFeedItemId,@signalid,@Signalword,@industryid,@tagid,Getdate());

	
End	
