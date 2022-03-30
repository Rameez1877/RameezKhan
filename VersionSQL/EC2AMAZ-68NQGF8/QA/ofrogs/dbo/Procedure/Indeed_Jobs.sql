/****** Object:  Procedure [dbo].[Indeed_Jobs]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[Indeed_Jobs]
@userid int

AS
BEGIN
	SET NOCOUNT ON;
	delete from IndeedJobsmatch

	INSERT INTO IndeedJobsmatch(Company,Title,JobPosted,InsertedDate,typeofdate,keyword,Location,TagId,url)
	      select distinct
		   REPLACE(a.companyname, '''', '') as Company,
		    REPLACE(a.jobtitle, '''', '')as Title ,
		   REPLACE(a.JobPosted, '''', '') as JobPosted,
		   CONVERT(varchar,InsertedDate,101) as InsertedDate,'',
		   REPLACE(a.keyword, '''', '') as Keyword,
		   REPLACE(a.location, '''', '') as Location,a.TagId,
		    REPLACE(a.url, '''', '') as Url
		                    from IndeedJobPost  a  where a.TagId in (select Tagid from appusersignaltag where appuserid = 1)
				 order by keyword


  
		
		
 /*  update Indeedjobsmatch set typeofdate= REPLACE(SUBSTRING(jobposted, CHARINDEX(' ', jobposted), LEN(jobposted)), 'ago', '') 
   update Indeedjobsmatch set jobposted= LEFT(jobposted, CHARINDEX(' ', jobposted) - 1) 
   update Indeedjobsmatch set jobposted= REPLACE(jobposted, '+', '') */

 
End	
