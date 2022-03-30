/****** Object:  Procedure [dbo].[OutputInsightTopics2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputInsightTopics2] 
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
		TopicName varchar(100),
		score float

	)
		DECLARE @EntityNews TABLE 
	(
		RssFeedItemId int,
		EntityId varchar(300)

	)

	DECLARE @TopicAndEntityNews TABLE
	(
		topicName varchar(100),
		RssFeedItemId int,
		EntityId varchar(300),
		---year int,
		url varchar(3000),
		score float,
		factor varchar(100)
	)
	
	DECLARE @IndustryTopic TABLE
	(  	TopicName varchar(100),
		isVisible int
		 
	)
	Insert into @IndustryTopic
	select topicName COLLATE SQL_Latin1_General_CP1_CS_AS, isVisible from IndustryTopic where IndustryID = @IndustryId 
	

	
	Insert into @TopicNews
	--select T.RssFeedItemId as rssfeeditemid, AUT.TopicName as topicName, T.Score as score
	--from ofuser.AppUserTopic AUT join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CI_AS= T.Label 
	--where T.Score >= 0.4 and AUT.AppUserId = @AppUserId 
	
	select T.RssFeedItemId as rssfeeditemid, T.Label as topicName, T.Score as score
	from  Topic T 
	where T.Score >= 0.6
	and T.label in (select topicname COLLATE SQL_Latin1_General_CP1_CS_AS from industrytopic where industryid = 35)


	Insert into @EntityNews 
	select distinct e.rssfeeditemid, e.entityid COLLATE Latin1_General_CI_AI 
	from entity E, entityfreebasetype EFT
	where  E.id = EFT.entityid
	--and EFT.freebasetypeid in (4218)
	--and e.rssfeeditemid = TN.rssfeeditemid
	-- and E.ConfidenceScore >= 1
	 and  E.EntityId  collate SQL_Latin1_General_CP1_CI_AS in (
select name from organization where industryid = 23 and isactive = 1)

		
		
	Insert into @TopicAndEntityNews
	select TN.TopicName, TN.RssFeedItemId, ONE.EntityId , RFI.title as url,
	TN.score as score,
	'BusinessChallenge' as Factor
	
	from @TopicNews TN, @EntityNews ONE, rssfeeditem RFI
	where TN.RssFeedItemId = ONE.RssFeedItemId
	and TN.RssFeedItemId = RFI.ID
	and  TN.TopicName not in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic where isvisible = 0)
	

	select TN2.EntityId,STUFF((select distinct ',' + TopicName 
	from 	 @TopicAndEntityNews TN1
	where 
		TN2.EntityId = TN1.EntityId FOR XML PATH('')),1,1,'') AS TopicNames	

		,STUFF((select distinct ',' + url
	from 	 @TopicAndEntityNews TN1
	where 
		TN2.EntityId = TN1.EntityId FOR XML PATH('')),1,1,'') AS Urls	


		from @TopicAndEntityNews TN2
		group by TN2.EntityId


END
