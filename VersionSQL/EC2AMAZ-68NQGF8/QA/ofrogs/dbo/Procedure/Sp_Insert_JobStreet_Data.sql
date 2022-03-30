/****** Object:  Procedure [dbo].[Sp_Insert_JobStreet_Data]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sp_Insert_JobStreet_Data
AS
BEGIN
	
declare	@TagTypeId int ,
           @Keyword varchar(1)
           ,@JobTitle varchar(1000)
           ,@CompanyName varchar(1000)
           ,@Location varchar(1000)
           ,@Summary varchar(4000)
           ,@JobPosted varchar(1000)
           ,@CountryCode int
           ,@Url varchar(1000)
           ,@Source varchar(1000)
		   ,@INSERTEDDATE datetime,
		   @JObDate date,
		   @JobId int
    

DECLARE db_cursor CURSOR FOR 
 SELECT 
  0 AS TagtypeId,
  '' Keyword,
  job_title JobTitle,
  REPLACE(company, '(Recruitment Firm)', '') CompanyName,
  company_region Location,
  description Summary,
  STR(DATEDIFF(DAY, CONVERT(date, Job_PostedDate), CONVERT(date, GETDATE()))) + ' days ago' JobPosted,
  CountryCode CountryCode,
  job_link AS URL,
  'JobStreet' AS Source,
  Getdate(),
  Job_PostedDate,
  Job_id
FROM JobStreet31Jul2019
WHERE company NOT LIKE '%(Recruitment Firm)%'
and IsProcessed ='N'
and company <> 'Company Confidential'
and Job_PostedDate is not null

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @TagTypeId,
@Keyword
,@JobTitle
,@CompanyName
,@Location
,@Summary
,@JobPosted
,@CountryCode
,@Url
,@Source
,@INSERTEDDATE
,@JObDate,
@JobId
print getdate()
WHILE @@FETCH_STATUS = 0  
BEGIN  
     INSERT INTO [dbo].[IndeedJobPost]
           ([TagTypeId]
           ,[Keyword]
           ,[JobTitle]
           ,[CompanyName]
           ,[Location]
           ,[Summary]
           ,[JobPosted]
           ,[CountryCode]
           ,[Url]
           ,[Source],
		   INSERTEDDATE,
		   JObDate)
		   values(@TagTypeId,@Keyword
,@JobTitle
,@CompanyName
,@Location
,@Summary
,@JobPosted
,@CountryCode
,@Url
,@Source
,@INSERTEDDATE
,@JObDate)
update JobStreet31Jul2019 set IsProcessed ='Y' WHERE Job_ID = @Jobid
   FETCH NEXT FROM db_cursor INTO  @TagTypeId,
@Keyword
,@JobTitle
,@CompanyName
,@Location
,@Summary
,@JobPosted
,@CountryCode
,@Url
,@Source
,@INSERTEDDATE
,@JObDate
,@JobId

end 
CLOSE db_cursor  
DEALLOCATE db_cursor 
print getdate()
END
