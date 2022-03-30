/****** Object:  Procedure [dbo].[OutputEntitySignalbyFactor]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputEntitySignalbyFactor] 
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
		EntityId varchar(300),
		Factor VARCHAR(100),
		Quarter VARCHAR(20),
		Normalized_Score float
	)

	DECLARE @OIT TABLE
	(
		EntityId varchar(300),
		TopicNames VARCHAR(3000)
	)

	INSERT INTO @OP 
	exec dbo.OutputProcessor2 @AppUserId, @IndustryId
	
	INSERT INTO @OIT 
	exec dbo.OutputInsightTopics2 @AppUserId, @IndustryId

	--OIT.TopicNames as TopicNames

	
	select @AppUserId, OP.Quarter, OP.Factor,OP.EntityId, OIT.TopicNames
	from @OP OP, @OIT OIT
	where OP.EntityId = OIT.EntityId
	
END
