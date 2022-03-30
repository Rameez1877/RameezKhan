/****** Object:  Procedure [dbo].[GetNewsDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetNewsDetail] 
@OrganizationId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Insert statements for procedure here
SELECT convert(date,rfi.PubDate) PubDate, rfi.Link,  Rfi.Title, Rfi.News ,rs.name as RssSource
FROM RssFeedItem rfi, RssFeedItemTag rfit, Tag t,RssSource rs,RssFeed rf
where rfi.Id = rfit.RssFeedItemId
and rfit.TagId = t.id
and rfit.ConfidenceScore >= .8
and  rfi.PubDate is not null
and rs.id = rf.rssSourceId
and rf.id = rfi.RssFeedId
and t.OrganizationId = 89 --@OrganizationId

END
