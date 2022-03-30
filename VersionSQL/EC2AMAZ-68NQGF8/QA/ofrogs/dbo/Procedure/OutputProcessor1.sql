/****** Object:  Procedure [dbo].[OutputProcessor1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputProcessor1]
	-- Add the parameters for the stored procedure here
	@AppUserId INT,
	@IndustryId INT
---,	@normalizier float
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 Declare @normalizier float =  16.6;
	
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
	--	OrganizationName varChar(200)
		tagID int
	)
	
	DECLARE @TopicAndOrganizationNews TABLE
	(
		topicName varchar(100),
		RssFeedItemId int,
		tagID int,
		---year int,
		quarter varchar(20),
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
	select T.RssFeedItemId as rssfeeditemid, AUT.TopicName as topicName, T.Score as score
	from ofuser.AppUserTopic AUT join Topic T on AUT.TopicName COLLATE SQL_Latin1_General_CP1_CI_AS= T.Label 
	where T.Score >= 0.4 and AUT.AppUserId = @AppUserId 
	and T.label not in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic where isvisible = 0)
	and T.RssFeedItemId in (select TT.RssFeedItemId from topic TT where TT.label in (Select topicName COLLATE SQL_Latin1_General_CP1_CS_AS from @IndustryTopic))
	--and T.label not in  ('Airline', 'Airline hub', 'Airport', 'Civil aviation', 'Cargo', 'Transport operators', 'Cargo airline', 'Aviation organizations', 'Aviation industry', 'cargo', 'Airlines', 'Transportation engineering', 'Air Cargo', 'Airline trade associations', 'Aviation trade associations', 'Commercial item transport and distribution', 'Air cargo')
	--and T.RssFeedItemId in (select TT.RssFeedItemId from topic TT where TT.label in ('Airline', 'Airline hub', 'Airport', 'Civil aviation', 'Cargo', 'Transport operators', 'Cargo airline', 'Aviation organizations', 'Aviation industry', 'cargo', 'Airlines', 'Transportation engineering', 'Air Cargo', 'Airline trade associations', 'Aviation trade associations', 'Commercial item transport and distribution', 'Air cargo'))

	--union 

	--select CS.RssFeedItemId as rssfeeditemid, L.Name as topicName, cs.score as score
	--from ofuser.AppUserTopic AUT join Label L on AUT.TopicName = L.Name 
	--join Category C on C.LabelId = L.Id
	--join CategoryScore CS on CS.CategoryId = C.Id
	--and L.Name = 'HR Initiative' and AUT.AppUserId = @AppUserId 
	--and cs.Score > 0.3


	Insert into @OrganizationNews
	select distinct T.RssFeedItemId, RFT.TagId as tagID
	from ofuser.CustomerTargetList CTL ,  rssfeeditemtag RFT,
	 topic T 
--on T.Label COLLATE Latin1_General_CI_AI = O.Name 
	where  CTL.AppUserId = @AppUserId 
	and  CTL.NewsTagStatus = RFT.TagId

	and T.rssfeeditemid = RFT.rssfeeditemid
	--union 
	--select distinct e.rssfeeditemid, e.entityid COLLATE Latin1_General_CI_AI 
	--from entity E, entityfreebasetype EFT, @TopicNews TN
	--where  E.id = EFT.entityid
	--and EFT.freebasetypeid in (4218)
	--and e.rssfeeditemid = TN.rssfeeditemid

	


	Insert into @TopicAndOrganizationNews
	select TN.TopicName, TN.RssFeedItemId, ONE.tagID ,
	CASE 
		WHEN  year(RFI.pubdate) = 2017 and month(RFI.Pubdate) >=1 and  month(RFI.Pubdate) <=3 THEN 'Q1'
		WHEN  year(RFI.pubdate) = 2017 and month(RFI.Pubdate) >=4 and  month(RFI.Pubdate) <=6 THEN 'Q2'
		WHEN  year(RFI.pubdate) = 2017 and month(RFI.Pubdate) >=7 and  month(RFI.Pubdate) <=9 THEN 'Q3'
		ELSE 'PreviousYear'
	END as quarter,
	
	TN.score as score,
	'BusinessChallenge' as Factor
	--CASE 
	--WHEN RFI.Tags = 'jobs listing' and TN.TopicName = 'HR Initiative' THEN 'ITSpend'
	--WHEN RFI.Tags = 'jobs listing' and TN.TopicName <> 'HR Initiative' THEN 'Initiative'
	--WHEN RFI.Tags <> 'jobs listing' THEN 'BusinessChallenge'
	----	ELSE  'BusinessChallenge'
	--END as Factor
	from @TopicNews TN, @OrganizationNews ONE, rssfeeditem RFI
	where TN.RssFeedItemId = ONE.RssFeedItemId
	and TN.RssFeedItemId = RFI.ID
	--and (RFI.tags in ('Jobs Listing', 'News') 
	--or RFI.tags is null
	--)


	select ORN.tagID, ORN.factor,    ORN.quarter,
	 
		(max(ORN.score) * @normalizier) as normalized_score
	 from 
	@TopicAndOrganizationNews ORN 
	group by  ORN.tagID, ORN.factor,  ORN.quarter

END
