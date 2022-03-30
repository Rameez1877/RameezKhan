/****** Object:  Procedure [dbo].[ChromeNews]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[ChromeNews]
@userid int

AS
BEGIN
	SET NOCOUNT ON;
	delete from chrome_news
	INSERT INTO chrome_news(Title,Link,TagId,Tag,PubDate)
	 select distinct RFI.title,RFI.Link,tg.id,tg.name,RFI.pubdate from rssfeeditemtag RFT, rssfeeditem RFI,tag tg
            where RFT.RssFeedItemId = RFI.Id and rft.tagid = tg.id
            --and year(RFI.pubdate) = YEAR(getdate())  and month(RFI.pubdate) = Month(getdate()) 
			and (RFI.pubdate >= DATEADD(MONTH, -3, GETDATE())) 
			and RFT.ConfidenceScore > 0.99
            AND RFT.tagid in (select T.Id from ofuser.customerTargetList CTL, tag T
            where CTL.organizationid = T.OrganizationId
            and CTL.AppUserId = @userid
			and ctl.isactive = 1
            and T.TagTypeId = 1)
            order by  rfi.pubdate desc
   
End	
