/****** Object:  Procedure [dbo].[ProcessRssFeedItem2_2017_09_02]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ProcessRssFeedItem2_2017_09_02]
@OrganizationName VARCHAR(100),
@year VARCHAR(20)
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

	Select @tagID = id from tag T where T.tagtypeid =1 and T.organizationid = @OrganizationId

		
	DECLARE @TagIdTable TABLE(tagid INT,tagname VARCHAR(100))

	DECLARE @RFIT TABLE(rssfeeditemid INT,tagid INT, confidenceLevel float)
 
	-- INSERT INTO @TagIdTable Select Id,Name From dbo.Tag where OrganizationId = @OrganizationId and tagtypeid = 1
			INSERT INTO @RFIT 
			SELECT x.rssfeeditemid, x.Id, max(x.confidencelevel) FROM (
				select distinct RFI.Id as rssfeeditemid,O.id,
					case
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.fullname+ ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '''%' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.fullname+ '/%' 
								) then 
								case when len(O.fullname) > 4 then 1
								else 0.75
								end
						----Name logic
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + '''%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '/%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '''%'
								) Then
								case when len(O.name) > 4 then 
									case 
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ' %' then 0.9
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + ',%' then 0.85
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name + '''%' then 0.85
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + ',%' then 0.85
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '/%' then 0.85
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '''%' then 0.85
										end
									else 0.7
									end
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name + '%') Then
							case when len(O.name) > 4 then 0.7 else 0.55 end
						----Name2 logic
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' 
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + '''%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + ',%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '/%'
								OR RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '''%'
								) Then
								case when len(O.Name2) > 4 then 
									case 
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ' %' then 0.6
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + ',%' then 0.55
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '% ' + O.Name2 + '''%' then 0.55
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + ',%' then 0.55
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '/%' then 0.55
										when RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '''%' then 0.55
										end
									else 0.45
									end
						when (RFI.Title collate SQL_Latin1_General_CP1_CI_AS like '%' + O.Name2 + '%') Then
							case when len(O.Name2) > 4 then 0.4 else 0.35 end

						else 0
						end as confidencelevel
			 from 
			 Organization O, rssfeeditem RFI where 
			(O.name  = @OrganizationName)
			and O.IsActive = 1 
			and year(RFI.Pubdate) in (2017) 
			) as X
			GROUP BY x.rssfeeditemid, x.id
			HAVING max(x.confidencelevel) > 0

				
	--	select * from @RFIT
	DELETE	T1 FROM RssFeedItemIndustry T1 join @RFIT T2 on T1.RssFeedItemId = T2.rssfeeditemid and T1.IndustryId = @industryid
	--DELETE	T1 FROM RssFeedItemSignal T1 join @RFIT T2 on T1.RssFeedItemId = T2.rssfeeditemid and T1.IndustryId = @industryid
	INSERT INTO RssFeedItemIndustry SELECT distinct rssfeeditemid,@industryid,NULL FROM @RFIT RF where RF.confidenceLevel > 0.3

	SET @rssfeeditemindustry_rows = @@ROWCOUNT
	
	DELETE T1 FROM RssFeedItemTag T1 join @RFIT T2 on T2.rssfeeditemid = T1.rssfeeditemid  and T1.tagid = @tagID
		
	INSERT INTO RssFeedItemTag SELECT distinct rssfeeditemid,@tagID, 1, confidenceLevel from @RFIT RF 
	--SELECT DISTINCT rssfeeditemid,@tagID, confidenceLevel from @RFIT RF

	SET @rssfeeditemtag_rows = @@ROWCOUNT
	
	print 'Number of rows added in rssfeeditemindustry' 
	print @rssfeeditemindustry_rows
	print 'Number of rows added in rssfeeditemtag'
	print @rssfeeditemtag_rows

END
