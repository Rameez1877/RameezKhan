/****** Object:  Procedure [dbo].[Leads]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Leads] 
	-- Add the parameters for the stored procedure here
	@appuserid int,
	@Offset int = 0,
	@Limit int = 10000
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select PubDate,Link,Title,Description,TopicNames,max(Score) as Score,ProductId,ProductName,
	--OrganizationId,OrganizationName from
	--(
	select rfi.Id,rfi.PubDate as Pubdate,rfi.Link,rfi.Title,rfi.Description,dbo.[GetTopicNames](rfi.Id) 
	as [TopicNames],categoryscore.Score as Score,prod.Id as ProductId,prod.Name as ProductName,org.Id as OrganizationId,
	org.Name as OrganizationName
	from ofuser.ProductDefinition prod 
	join dbo.Label label on prod.LabelId = labelId 
	join dbo.Category category on category.LabelId = label.Id
	join dbo.CategoryScore categoryscore on categoryscore.CategoryId = category.Id
	join dbo.RssFeedItem rfi on rfi.Id = categoryscore.RssFeedItemId
	join dbo.RssFeedItemTag rfit on rfit.RssFeedItemId = rfi.Id
	join dbo.Tag tag on tag.Id = rfit.TagId
	join dbo.Organization org on org.Id = tag.OrganizationId
	where prod.AppUserId = @appuserid and categoryscore.Score >= 0.5
	--) R
	--group by R.PubDate,R.Link,R.Title,R.Description,R.TopicNames,R.ProductId,R.ProductName,
	--R.OrganizationId,R.OrganizationName
	order by Score desc
	OFFSET @Offset ROWS
	FETCH NEXT @Limit ROWS ONLY

END
