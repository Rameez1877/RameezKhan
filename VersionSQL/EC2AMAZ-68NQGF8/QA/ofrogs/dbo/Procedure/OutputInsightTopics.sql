/****** Object:  Procedure [dbo].[OutputInsightTopics]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputInsightTopics] 
	-- Add the parameters for the stored procedure here
	@AppUserId INT,
	@IndustryId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @TopicNews TABLE 
	(
		RssFeedItemId int,
		TopicName varchar(100)
	---	,score float

	)

	DECLARE @OrganizationNews TABLE
	(
		RssFeedItemId int,
	  tagID int
	)

	DECLARE @TopicOrganizationNews TABLE
	(  tagID int,
		TopicName varchar(100)
	)
		DECLARE @IndustryTopic TABLE
	(  	TopicName varchar(100),
		isVisible int
		 
	)
	Insert into @IndustryTopic
	select topicName COLLATE SQL_Latin1_General_CP1_CS_AS, isVisible from IndustryTopic where IndustryID = @IndustryId 
	
	Insert into @TopicNews
	select distinct T.RssFeedItemId as rssfeeditemid, AUT.TopicName as topicName
	from ofuser.AppUserTopic AUT join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CS_AS = T.Label 
	where T.Score >= 0.5 and AUT.AppUserId = @AppUserId 
	-- and T.label not in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic where isvisible = 0)
	and T.RssFeedItemId in (select TT.RssFeedItemId from topic TT where TT.label in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic))
	

	Insert into @OrganizationNews
	select distinct T.RssFeedItemId, RFT.TagId 
	from ofuser.CustomerTargetList CTL ,  rssfeeditemtag RFT,
	 topic T 
	where  CTL.AppUserId = @AppUserId 
	and  CTL.NewsTagStatus = RFT.TagId
	and T.rssfeeditemid = RFT.rssfeeditemid
	
	Insert into @TopicOrganizationNews
	select DISTINCT ONE.tagID,TN.TopicName
	from @TopicNews TN, @OrganizationNews ONE
		where TN.RssFeedItemId = ONE.RssFeedItemId
		and TN.TopicName in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic where isvisible = 1)
	--	group by ONE.tagID

	select TN2.tagID,STUFF((select distinct ',' + TopicName 
	from @TopicOrganizationNews TN1
	where 
		TN2.tagID = TN1.tagID FOR XML PATH('')),1,1,'') AS TopicNames	
		from @TopicOrganizationNews TN2
		group by TN2.tagID


		

 --   -- Insert statements for procedure here
	--select O.Name,STUFF((select  ',' + T2.Label from ofuser.CustomerTargetList CTL2 join Organization O2 on 
	--CTL2.OrganizationId = O2.id
	--join Topic T2 on T2.Label COLLATE Latin1_General_CI_AI = O2.Name 
	--where  CTL2.AppUserId = @AppUserId and O2.isactive = 1 and T2.Score > 0.6 and O2.Name = O.Name FOR XML PATH('')),1,1,'') as TopicList
	--from ofuser.CustomerTargetList CTL join Organization O on CTL.OrganizationId = O.id
	--join Topic T on T.Label COLLATE Latin1_General_CI_AI = O.Name 
	--where  CTL.AppUserId = @AppUserId and O.isactive = 1 and T.Score > 0.6
	--group by O.Name
END
