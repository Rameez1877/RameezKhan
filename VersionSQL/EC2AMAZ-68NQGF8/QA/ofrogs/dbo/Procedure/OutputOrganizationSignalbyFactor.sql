/****** Object:  Procedure [dbo].[OutputOrganizationSignalbyFactor]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputOrganizationSignalbyFactor] 
	-- Add the parameters for the stored procedure here
	@AppUserId int,
	@IndustryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @OP TABLE
	(
		tagID int,
		Factor VARCHAR(100),
		Quarter VARCHAR(20),
		Normalized_Score float
	)

	DECLARE @OIT TABLE
	(
		tagID int,
		TopicNames VARCHAR(3000)
	)

	INSERT INTO @OP 
	exec dbo.OutputProcessor1 @AppUserId, @IndustryId
	
	INSERT INTO @OIT 
	exec dbo.OutputInsightTopics @AppUserId, @IndustryId

	--OIT.TopicNames as TopicNames

	insert into dbo.tblOutputOrganizationSignalByFactor(AppUserId,OrganizationName,MagazineId,Score,
	Recommendation_Flag,BusinessChallenge_Flag,Initiative_Flag,ITSpend_Flag, TopicNames)
	select @AppUserId,
	tag.name,MTM.name as MagazineId, 
	CONVERT(INT,ROUND(Business_Challenge + Initiative + ITSpend,0),0) as Score,

	'null' as Recommendation_Flag ,

		
	CASE 
		WHEN  (Business_Challenge) < 10 THEN 'weak'
		WHEN  (Business_Challenge) >= 10 and (Business_Challenge) < 20 THEN 'moderate'
		ELSE 'strong'
	END as BusinessChallenge_Flag ,

		CASE 
		WHEN  (Initiative) < 10 THEN 'weak'
		WHEN  (Initiative) >= 10 and (Initiative) < 20 THEN 'moderate'
		ELSE 'strong'
	END as Initiative_Flag ,

		CASE 
		WHEN  (ITSpend) < 10 THEN 'weak'
		WHEN  (ITSpend) >= 10 and (ITSpend) < 20 THEN 'moderate'
		ELSE 'strong'
	END as ITSpend_Flag ,
	OIT.TopicNames
	from 
	( SELECT TEMP.tagID as tagID, 
	  max(case when Temp.Factor = 'BusinessChallenge' then TEMP.Normalized_Score else 0 end) Business_Challenge,
	  max(case when Temp.Factor = 'Initiative' then TEMP.Normalized_Score else 0 end) Initiative,
	  max(case when Temp.Factor = 'ITSpend' then TEMP.Normalized_Score else 0 end) ITSpend
	  from
	  (SELECT tagID,Factor,Quarter, MAX(Normalized_Score) as Normalized_Score
	   FROM @OP GROUP BY tagID,Factor, Quarter) TEMP

	group by Temp.tagID) x left outer join (select MT.tagID as tagID, M.Id  as name from magazine M, MagazineTag MT 
	where  MT.magazineid = M.id) as MTM on MTM.tagid = x.tagid
	left outer join @OIT OIT on  x.tagID= OIT.tagID
	left outer join tag on x.tagid = tag.Id and tag.TagTypeId = 1
END
