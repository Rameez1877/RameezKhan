/****** Object:  Procedure [dbo].[OutputTopicsandLinks]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputProcessor5]
	-- Add the parameters for the stored procedure here
	@AppUserId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		-- Insert statements for procedure here
		DECLARE @TopicNews TABLE 
	(
		RssFeedItemId int,
		TopicName varchar(100),
		score float

	)

	DECLARE @OrganizationNews TABLE
	(
		RssFeedItemId int,
		OrganizationName varChar(200)
	)



	DECLARE @TopicAndOrganizationNews TABLE
	(
		topicName varchar(100),
		RssFeedItemId int,
		OrganizationName varchar(100),
		---year int,
		quarter varchar(20),
		score float,
		factor varchar(100)
	)


	Insert into @TopicNews

	select T.RssFeedItemId as rssfeeditemid, AUT.TopicName as topicName, T.Score as score
	from ofuser.AppUserTopic AUT join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CS_AS = T.Label 
	where T.Score >= 0.3 and AUT.AppUserId = @AppUserId 

	union 

	select CS.RssFeedItemId as rssfeeditemid, L.Name as topicName, cs.score as score
	from ofuser.AppUserTopic AUT join Label L on AUT.TopicName = L.Name 
	join Category C on C.LabelId = L.Id
	join CategoryScore CS on CS.CategoryId = C.Id
	and L.Name = 'HR Initiative' and AUT.AppUserId = @AppUserId 
	and cs.Score > 0.3


	Insert into @OrganizationNews
	select T.RssFeedItemId, O.name
	from ofuser.CustomerTargetList CTL join Organization O on CTL.OrganizationId = O.id
	join Topic T on T.Label COLLATE Latin1_General_CI_AI = O.Name 
	where  CTL.AppUserId = @AppUserId and O.isactive = 1
	---- we need to utilize full name, name 2 here. 


----Insert into @TopicAndOrganizationNews
	select TN.TopicName, TN.RssFeedItemId, ONE.OrganizationName , RFI.Link, RFI.title, 
	CASE 
		WHEN  month(RFI.Pubdate) >=1 and  month(RFI.Pubdate) <=3 THEN 'Q1'
		WHEN  month(RFI.Pubdate) >=4 and  month(RFI.Pubdate) <=6 THEN 'Q2'
		ELSE 'Previous Year'
	END as quarter ,
	TN.score,
	CASE 
	WHEN RFI.Tags = 'jobs listing' and TN.TopicName = 'HR Initiative' THEN 'IT Spend'
	WHEN RFI.Tags = 'jobs listing' and TN.TopicName <> 'HR Initiative' THEN 'Initiative'
	WHEN RFI.Tags <> 'jobs listing' THEN 'Business Challenge'
	END as Factor
	from @TopicNews TN, @OrganizationNews ONE, rssfeeditem RFI
	where TN.RssFeedItemId = ONE.RssFeedItemId
	and TN.RssFeedItemId = RFI.ID
	and RFI.tags in ('Jobs Listing', 'News')


	--select ORN.*
	-- from 
	--@TopicAndOrganizationNews ORN 
	-----group by ORN.factor,  ORN.OrganizationName, ORN.quarter



 

END
