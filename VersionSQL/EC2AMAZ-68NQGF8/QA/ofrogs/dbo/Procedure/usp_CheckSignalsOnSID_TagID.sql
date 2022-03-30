/****** Object:  Procedure [dbo].[usp_CheckSignalsOnSID_TagID]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE usp_CheckSignalsOnSID_TagID 
	-- Add the parameters for the stored procedure here
	@Type VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/* Inserting  for Tag ID*/
		DECLARE @MyCursor CURSOR;
		IF(@Type='Signal')
		BEGIN
			
			DECLARE @SignalID INT;
			BEGIN
				SET @MyCursor = CURSOR FOR
				select TOP 50 ID from signal
				WHERE ID NOT IN
				 (
					select SignalID from RssFeedItemSignal
					UNION
					SELECT SignalID FROM temp_CheckTag_Signal WHERE SignalID IS NOT NULL
				 )
				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @SignalID

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					EXEC Usp_SignalJob_Count_Signal_Words 0,0,@SignalID

					INSERT INTO temp_CheckTag_Signal (SignalID) VALUES(@SignalID)

				  FETCH NEXT FROM @MyCursor 
				  INTO @SignalID 
				END; 
				CLOSE @MyCursor 
				DEALLOCATE @MyCursor
			END
		END
		IF(@Type='Tag')
		BEGIN
			
			DECLARE @TagID INT;
			BEGIN
				SET @MyCursor = CURSOR FOR
				select distinct TOP 50 t.ID from tag t inner join Organization o ON o.id=t.OrganizationId
				WHERE TagTYpeID=1 
				AND t.ID NOT IN 
				(
					select distinct tagid from RssFeedItemSignal where tagid IS NOT NULL
					UNION
					SELECT TagID_Signal FROM temp_CheckTag_Signal WHERE TagID_Signal IS NOT NULL
				)

				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @TagID

				WHILE @@FETCH_STATUS = 0
				BEGIN
					
					EXEC Usp_SignalJob_Count_Signal_Words @TagID,0,0

					INSERT INTO temp_CheckTag_Signal (TagID_Signal) VALUES(@TagID)

				  FETCH NEXT FROM @MyCursor 
				  INTO @TagID 
				END; 
				CLOSE @MyCursor 
				DEALLOCATE @MyCursor
			END
		END
END
