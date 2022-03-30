/****** Object:  Procedure [dbo].[FeedCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE FeedCount
	-- Add the parameters for the stored procedure here
	@date date,@industryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		select count(*) CountPerDay_From_RFI,convert(date,Pubdate) as Pbdate from rssfeeditem R where 
		convert(date,Pubdate) = @date
		and Exists(select * from rssfeeditemIndustry RFII 
		where RFII.rssfeeditemid = R.Id and RFII.IndustryId = @industryId) 
		group by convert(date,Pubdate) 
		order by convert(date,Pubdate)

		select count(*) CountPerDay_From_RssSource,convert(date,Pubdate) as Pbdate from rssfeeditem R 
		where convert(date,Pubdate) = @date
		and Exists(select * from RssFeed RF join RssSource RS on RF.RssSourceId = RS.Id 
		where R.RssFeedId = RF.Id and RS.IndustryId = @industryId) 
		group by convert(date,Pubdate) 
		order by convert(date,Pubdate)
END
