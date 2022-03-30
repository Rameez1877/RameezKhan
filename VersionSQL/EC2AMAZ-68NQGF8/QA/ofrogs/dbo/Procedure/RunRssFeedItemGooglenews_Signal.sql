/****** Object:  Procedure [dbo].[RunRssFeedItemGooglenews_Signal]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[RunRssFeedItemGooglenews_Signal]
@RssFeedItemId int,
@industryid int,
@tagid int

AS
BEGIN
	SET NOCOUNT ON;

	Declare @signalid int, @Signalword varchar(1000)
	 Set @signalid=(select distinct signalid  from rssfeeditem rfi ,signalword sw 
                    WHERE (rfi.description  collate SQL_Latin1_General_CP1_CI_AS LIKE sw.name + '%' 
					 or rfi.title collate SQL_Latin1_General_CP1_CI_AS LIKE sw.name + '%')
                    and rfi.id =@RssFeedItemId)
	if(@signalid is not null)
		 begin
			 SET @Signalword = ( select Name from Signal where Id = @Signalid  )
		 end
	 else
		begin
		 set @signalid=0
		 set @Signalword='Others'
	    end	 
	insert into rssfeeditemsignal(RssFeedItemId,SignalId,Signalword,IndustryId,TagId,ScoreDate)
                       values(@RssFeedItemId,@signalid,@Signalword,@industryid,@tagid,Getdate());
    

End
