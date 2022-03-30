/****** Object:  Procedure [dbo].[usp_ProcessRssFeedItem2_Test]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[usp_ProcessRssFeedItem2_Test]  --'Thales','2016'
@OrganizationName VARCHAR(100),
@year VARCHAR(20) ='2017'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tagID as int, @id AS int,@OrganizationId as int, @industryid AS int, @rssfeeditemtag_rows AS int, @rssfeeditemindustry_rows AS int

	SET @rssfeeditemtag_rows = 0;
	SET @rssfeeditemindustry_rows = 0;

	SELECT @industryid = IndustryId,@OrganizationId = Id from Organization where (Name = @OrganizationName or FullName = @OrganizationName or Name2 = @OrganizationName)
	and isactive = 1
	---SELECT @OrganizationId
	Select @tagID = id from tag T where T.tagtypeid =1 and T.organizationid = @OrganizationId

	 
	DECLARE @FULLName VARCHAR(100) ,@Name2 VARCHAR(1000)

	--SELECT *  FROM Organization(NOLOCK) 
	--WHERE name =@OrganizationName
	  
	SELECT @FULLName=FULLNAME,@Name2=Name2 FROM Organization(NOLOCK) 
	WHERE name =@OrganizationName
	
	SELECT TITLE,Id  INTO #temp FROM rssfeeditem(NOLOCK) WHERE   year(Pubdate)>= year(getdate())-1 --IN(2016,2017) --CAST(@year AS INT) 
	--Pubdate>=convert (date,DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()),0))
	AND 
	( 
		(LEN(@FULLName)>3 AND TITLE collate SQL_Latin1_General_CP1_CI_AS LIKE '%'+@FULLName+'%')
		 OR
		 (LEN(@FULLName)<=3 AND TITLE collate SQL_Latin1_General_CP1_CS_AS LIKE UPPER( '%'+@FULLName+'%'))
		 OR
		(LEN(@Name2)>3 AND TITLE collate SQL_Latin1_General_CP1_CI_AS LIKE '%'+@Name2+'%' ) 
		OR
		(LEN(@Name2)<=3 AND TITLE collate SQL_Latin1_General_CP1_CS_AS LIKE UPPER('%'+@Name2+'%') )
		OR
		(LEN(@OrganizationName)>3 AND TITLE collate SQL_Latin1_General_CP1_CI_AS LIKE '%'+@OrganizationName+'%')
		OR
		(LEN(@OrganizationName)<=3 AND TITLE collate SQL_Latin1_General_CP1_CS_AS LIKE UPPER('%'+@OrganizationName+'%'))
	)



		
	DECLARE @TagIdTable TABLE(tagid INT,tagname VARCHAR(100))

	DECLARE @RFIT TABLE(rssfeeditemid INT,tagid INT, confidenceScore float)

	
	select distinct RFI.Id as rssfeeditemid,O.id,
					case
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.fullname+ ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ' %' 
								OR dbo.fn_remove_Chars(RFI.Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '^%'
								) then 
								case when len(O.fullname) > 4 then
											CASE when dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.fullname) =1  THEN 1
											ELSE  0.1 END 
									when len(O.fullname) < =4  and   dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.fullname) =1   
									then 0.75
								else 0.0
								end
						------Name logic
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + '''%'
								OR dbo.fn_remove_Chars(RFI.Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%'
								) Then
								case when len(O.name) > 4 then 
									case 
										when dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name) =1  THEN 1
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' then 0.9
										WHEN dbo.fn_remove_Chars(RFI.Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '^%' then 0.85
										end
									when len(O.name) < =4  and   dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name) =1  
									then 0.75
									else 0.0
									end
						when (RFI.Title +' ' collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + ' %') Then
							case when len(O.name) > 4 AND  dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name) =1  THEN 1 
								when len(O.name) > 4	then 0.1
							when len(O.name) < =4  and   dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name) =1   
									then 0.75
							 else 0.0 end
						------Name2 logic
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + '''%'
								OR dbo.fn_remove_Chars(RFI.Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%'
								) Then
								case when len(O.Name2) > 4 then 
									case 
										when dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name2) =1 THEN 1
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' then 0.6
										WHEN dbo.fn_remove_Chars(RFI.Title) collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '^%' THEN 0.55 
										end
									when len(O.Name2) < =4  and   dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name2) =1   
									then 0.75
									else 0.1
									end
						when (RFI.Title+' ' collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + ' %') Then
							case when len(O.Name2) > 4 AND dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name2) =1 THEN 1
							 when len(O.Name2) > 4 
							 then 0.1
							when len(O.Name2) < =4  and   dbo.[fn_GetOrgName_Title](RFI.Title,' ',O.Name2) =1   
									then 0.75
							 else 0.0 end

						else 0 
						end as confidenceScore,
						CASE WHEN  dbo.[fn_SplitString](RFI.Title,' ',@industryid) =1  THEN 0.45
						ELSE 0 END AS Rewards
						INTO #temp_Score
			 from 
			 Organization(NOLOCK) O, #temp (NOLOCK) RFI where 
			(O.name  = @OrganizationName)
			and O.IsActive = 1 
 
	-- INSERT INTO @TagIdTable Select Id,Name From dbo.Tag where OrganizationId = @OrganizationId and tagtypeid = 1
			INSERT INTO @RFIT 
			SELECT x.rssfeeditemid, x.Id, max(x.confidenceScore) FROM (
				 SELECT rssfeeditemid,Id, confidenceScore+CASE WHEN confidenceScore >=0.3 THEN Rewards ELSE 0 END  AS confidenceScore FROM #temp_Score
			) as X
			GROUP BY x.rssfeeditemid, x.id
			HAVING max(x.confidenceScore) > 0

				
		--select * from @RFIT
	DELETE	T1 FROM RssFeedItemIndustry T1 join #temp_Score T2 on T1.RssFeedItemId = T2.rssfeeditemid and T1.IndustryId = @industryid
	--DELETE	T1 FROM RssFeedItemSignal T1 join @RFIT T2 on T1.RssFeedItemId = T2.rssfeeditemid and T1.IndustryId = @industryid
	INSERT INTO RssFeedItemIndustry SELECT distinct rssfeeditemid,@industryid,NULL FROM @RFIT RF where RF.confidenceScore >= 0.3

	SET @rssfeeditemindustry_rows = @@ROWCOUNT
	
	DELETE T1 FROM RssFeedItemTag T1 join #temp_Score T2 on T2.rssfeeditemid = T1.rssfeeditemid  and T1.tagid = @tagID
		
	INSERT INTO RssFeedItemTag SELECT distinct rssfeeditemid,@tagID, 1, confidenceScore from @RFIT RF 
	SELECT DISTINCT rssfeeditemid,@tagID, confidenceScore from @RFIT RF
	--SELECT * FROM #temp_Score
	SET @rssfeeditemtag_rows = @@ROWCOUNT
	
	print 'Number of rows added in rssfeeditemindustry' 
	print @rssfeeditemindustry_rows
	print 'Number of rows added in rssfeeditemtag'
	print @rssfeeditemtag_rows
	---exec [Usp_SignalJob_Count_Signal_Words] @tagID,0,0 

	DROP TABLE #temp
	DROP TABLE #temp_Score

END
