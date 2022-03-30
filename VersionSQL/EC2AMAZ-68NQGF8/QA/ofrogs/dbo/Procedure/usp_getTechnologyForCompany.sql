/****** Object:  Procedure [dbo].[usp_getTechnologyForCompany]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[usp_getTechnologyForCompany]---usp_getTechnologyForCompany 249
	-- Add the parameters for the stored procedure here
	--@tagID INT
	@TechnologyName NVARCHAR(200)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

			
			/* Inserting Technologoes for Tag ID*/
			IF(@TechnologyName='')
			BEGIN
				DECLARE @MyCursor CURSOR;
				DECLARE @TagID INT;
				BEGIN
					SET @MyCursor = CURSOR FOR
					select distinct RFT.TagId
						from rssfeeditem RFI
							INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
							INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
							INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
							INNER JOIN dbo.Tag AS T ON RFT.TagId = T.Id and T.TagTypeId = 1
							where RS.rssTypeId=3 and   RF.CreatedDate>=cast(getdate()-1 as date) and   RF.CreatedDate<cast(getdate() as date)
							--*** Need to remove once completed for existing feeditem  and need to add the check on date for rssfeeditems
							--AND RFT.Tagid NOT IN
							--(
							--	select distinct tagid FROM CompanyTechnologies
							--	UNION
							--	SELECT TagID FROM ##tempTagID
							--) 
							--***---
					OPEN @MyCursor 
					FETCH NEXT FROM @MyCursor 
					INTO @TagID

					WHILE @@FETCH_STATUS = 0
					BEGIN
					select RFI.Id, RS.rssTypeId ,RFT.TagId,t.Name, RFI.Title,RFI.Description
							INTO #temp
								from rssfeeditem RFI
								INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
								INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
								INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
								INNER JOIN dbo.Tag AS T ON RFT.TagId = T.Id and T.TagTypeId = 1
								where RS.rssTypeId=3 and RFT.tagid=@TagID
								and   RF.CreatedDate>=cast(getdate()-1 as date) and   RF.CreatedDate<cast(getdate() as date)
				
					SELECT DISTINCT * into #tempTech FROM 
					(
						SELECT TagId, dbo.[fn_GetJobTech_Func_Title](Title,'Technology') AS TechnologyName FROM #temp

						UNION

						SELECT TagId, dbo.[fn_GetJobTech_Func_Title](Description,'Technology') AS TechnologyName FROM #temp
					) AS tb WHERE  TechnologyName IS NOT NULL
					
					INSERT INTO CompanyTechnologies(TagId, TechnologyName )	
					SELECT DISTINCT tagID, 
						 Split.a.value('.', 'NVARCHAR(100)') AS String  
					 FROM  (SELECT tagID ,
							 CAST ('<M>' + REPLACE([TechnologyName], ',', '</M><M>') + '</M>' AS XML) AS String  
						 FROM  #tempTech ) AS A CROSS APPLY String.nodes ('/M') AS Split(a); 

						DROP TABLE #temp
						DROP TABLE #tempTech

						--INSERT INTO ##tempTagID VALUES(@TagID)

					  FETCH NEXT FROM @MyCursor 
					  INTO @TagID 
					END; 
					CLOSE @MyCursor 
					DEALLOCATE @MyCursor
				END

			END
			ELSE 
			BEGIN
				--DECLARE @TechnologyName NVARCHAR(200) 
				--SET @TechnologyName='GitHub'
				INSERT INTO CompanyTechnologies(TagId, TechnologyName )
				select distinct RFT.TagId,@TechnologyName
						from rssfeeditem RFI
							INNER JOIN rssfeed RF ON RF.Id = RFI.RssFeedId
							INNER JOIN RssSource RS ON RF.RssSourceId = RS.Id
							INNER join rssfeeditemtag RFT on RFT.rssfeeditemid = RFI.id
							INNER JOIN dbo.Tag AS T ON RFT.TagId = T.Id and T.TagTypeId = 1
							where RS.rssTypeId=3 
							and( RFI.Title LIKE '% '+@TechnologyName +' %'
							 OR  RFI.Description LIKE '% '+@TechnologyName +' %')
							--and   RF.CreatedDate>=cast(getdate()-1 as date) and   RF.CreatedDate<cast(getdate() as date)
			END



		;WITH CTE AS
		(
			select TagID, TechnologyName, ROW_NUMBER()OVER(PARTITION BY TagID, TechnologyName ORDER BY Dated DESC) as rwnum from CompanyTechnologies
		)
		
		DELETE FROM CTE WHERE rwnum>1	


			
			
			
END
