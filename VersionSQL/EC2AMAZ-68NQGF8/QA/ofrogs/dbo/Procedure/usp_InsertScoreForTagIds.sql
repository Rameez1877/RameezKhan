/****** Object:  Procedure [dbo].[usp_InsertScoreForTagIds]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE usp_InsertScoreForTagIds	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @OrganizationName VARCHAR(200)
    -- Insert statements for procedure here
	/* Inserting  for Tag ID*/
			DECLARE @MyCursor CURSOR;
			DECLARE @TagID INT;
			BEGIN
				SET @MyCursor = CURSOR FOR
				select distinct TOP 50 t.ID from tag t inner join Organization o ON o.id=t.OrganizationId
					WHERE TagTYpeID=1 
					AND t.ID NOT IN 
					(
						select distinct tagid from RssFeedItemTag 
						UNION
						SELECT TagID_FeedItemTag FROM temp_CheckTag_Signal WHERE TagID_FeedItemTag IS NOT NULL
					)
				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @TagID

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					SELECT @OrganizationName=o.Name FROM tag t inner join Organization o ON o.id=t.OrganizationID
					WHERE TagTYpeID=1 
					EXEC ProcessRssFeedItem2 @OrganizationName, '2017'
					INSERT INTO temp_CheckTag_Signal (TagID_FeedItemTag) VALUES(@TagID)

				  FETCH NEXT FROM @MyCursor 
				  INTO @TagID 
				END; 
				CLOSE @MyCursor 
				DEALLOCATE @MyCursor
			END
END
