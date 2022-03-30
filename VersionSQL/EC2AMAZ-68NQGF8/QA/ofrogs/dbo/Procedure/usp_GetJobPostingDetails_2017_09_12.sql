/****** Object:  Procedure [dbo].[usp_GetJobPostingDetails_2017_09_12]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <03-Sep-2017>
-- Description:	<Get JobPosting details from the job excel raw data>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetJobPostingDetails_2017_09_12]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
			TRUNCATE TABLE tempRssFeedItemId

			;with CTE AS
			(
				SELECT e.BaseURL+e.JobURL AS URL, ROW_NUMBER()OVER(PARTITION BY e.BaseURL+e.JobURL ORDER by Company) as rwnum from job_excelrawdata e
			)
			DELETE from cte where rwnum>1


		 /* Check for duplicate records in the rssfeeditem*/
			UPDATE e SET e.IsDuplicate=1 FROM job_excelrawdata e 
			INNER JOIN rssfeeditem j ON e.BaseURL+e.JobURL=j.link collate SQL_Latin1_General_CP1_CI_AS

		/* Insert records to rssfeeditem table*/
		 INSERT INTO rssfeeditem
		 (RssFeedId,Title, Link,Description,News,PubDate,IsActive )
		 select 9233389 AS RssFeedId, JobName+' - '+LTRIM(RTRIM(REPLACE(Company,'"','')))+' - '+ LTRIM(RTRIM(REPLACE(jobLocation,'"',''))) AS Title, BaseURL+JobURL as JobURL,
		 [Job Desription],[Job Desription], dateadd(dd,-cast(case when dbo.udf_GetNumeric([Posting Date]) IN (0,'') then '0' else dbo.udf_GetNumeric([Posting Date]) end as int) , getdate()) as JobPublicationDate,1
		  from job_excelrawdata e 
		  where isnull(e.Company,'')<>''  AND ISNULL(e.IsDuplicate,0)<>1

		  INSERT INTO tempRssFeedItemId (ID,Link)
		  SELECT j.ID,j.link collate SQL_Latin1_General_CP1_CI_AS FROM job_excelrawdata e 
			INNER JOIN rssfeeditem j ON e.BaseURL+e.JobURL=j.link collate SQL_Latin1_General_CP1_CI_AS
			 where isnull(e.Company,'')<>''
		
		/* Inserting new organization by executing SP: SaveOrganization*/
			DECLARE @MyCursor CURSOR;
			DECLARE @Organization NVARCHAR(500);
			BEGIN
				SET @MyCursor = CURSOR FOR
				SELECT DISTINCT REPLACE(Company,'"','') AS Company FROM job_excelrawdata  t
				left join organization o
				ON o.Fullname =LTRIM(RTRIM(REPLACE(Company,'"','')))  collate SQL_Latin1_General_CP1_CI_AS or o.name=LTRIM(RTRIM(REPLACE(Company,'"',''))) collate SQL_Latin1_General_CP1_CI_AS or o.name2=LTRIM(RTRIM(REPLACE(Company,'"',''))) collate SQL_Latin1_General_CP1_CI_AS
				WHERE ISNULL(o.isActive,0)=0 and o.id IS NULL      

				OPEN @MyCursor 
				FETCH NEXT FROM @MyCursor 
				INTO @Organization

				WHILE @@FETCH_STATUS = 0
				BEGIN
					--select @Organization
					EXEC SaveOrganization 0, @Organization, @Organization, @Organization, NULL, NULL, NULL, 20, 7, 2, NULL
					/*
					    EXEC SaveOrganization 0, @Organization, @Organization, @Organization, NULL, NULL, NULL, 20, 7, 2, NULL
				  */
				  FETCH NEXT FROM @MyCursor 
				  INTO @Organization 
				END; 

				CLOSE @MyCursor 
				DEALLOCATE @MyCursor
			END

	/* Check for duplicate records in the jobposting*/
	UPDATE e SET e.IsDuplicate=2 FROM job_excelrawdata e INNER JOIN jobposting j ON e.BaseURL+e.JobURL=j.JobURL
	
	/*Get Organization ID and Insert records to jobposting table*/

	;WITH cte AS  
	(
		SELECT DISTINCT o.Name, LTRIM(RTRIM(REPLACE(Company,'"','')))  AS Company,o.id from job_excelrawdata  t
		INNER join organization o
		ON o.Fullname =LTRIM(RTRIM(REPLACE(Company,'"','')))  collate SQL_Latin1_General_CP1_CI_AS or o.name=LTRIM(RTRIM(REPLACE(Company,'"',''))) collate SQL_Latin1_General_CP1_CI_AS or o.name2=LTRIM(RTRIM(REPLACE(Company,'"',''))) collate SQL_Latin1_General_CP1_CI_AS
		WHERE ISNULL(o.isActive,0)=1
	)
	--SELECT * FROM cte
	, CETOrgID AS
	(
		select *, ROW_NUMBER()OVER(PARTITION BY Company ORDER BY id DESC ) AS rwnum from cte
	) 
	--SELECT * FROM CETOrgID
	SELECT * INTO #Org fROM CETOrgID WHERE rwnum=1

	INSERT INTO jobposting 
	(JobTitle,	JobURL,	JobLocation,	Organization, OrganizationId,	CreateDate,	CreatedBy,	JobPublishedDate,	JobPublicationDate,	JobDescription)
	select JobName, BaseURL+JobURL as JobURL,LTRIM(RTRIM(REPLACE(jobLocation,'"',''))) AS jobLocation, t.Name, t.ID, getdate() as CreateDate,1 as CreatedBy, [Posting Date],
	dateadd(dd,-cast(case when dbo.udf_GetNumeric([Posting Date]) IN (0,'') then '0' else dbo.udf_GetNumeric([Posting Date]) end as int) , getdate()) as JobPublicationDate
	,[Job Desription]
	  from job_excelrawdata e INNER JOIN #Org t ON  LTRIM(RTRIM(REPLACE(e.Company,'"',''))) =t.Company AND rwnum=1
	  where isnull(e.Company,'')<>''  AND ISNULL(e.IsDuplicate,0)<>2
	 -- AND BaseURL+JobURL NOT IN
	 -- (	
		--SELECT JobURL FROM jobposting(NOLOCK)
	 -- )

	

	 DROP TABLE #Org

END
