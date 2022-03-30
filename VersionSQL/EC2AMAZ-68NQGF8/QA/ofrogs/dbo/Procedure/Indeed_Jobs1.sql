/****** Object:  Procedure [dbo].[Indeed_Jobs1]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[Indeed_Jobs1]
@userid int

AS
BEGIN
	SET NOCOUNT ON;
	delete from IndeedJobsmatch
	delete from IndeedJobsnotmatch

	INSERT INTO indeedjobsmatch(Title,Company,JobPosted,InsertedDate,typeofdate,keyword,Location)
	       select distinct REPLACE(a.jobtitle, '''', '')as Title ,
		   REPLACE(a.companyname, '''', '') as Company,
		   REPLACE(a.JobPosted, '''', '') as JobPosted,
		   CONVERT(varchar,InsertedDate,101) as InsertedDate,'',
		   REPLACE(a.keyword, '''', '') as Keyword,
		   REPLACE(a.location, '''', '') as Location
                 from IndeedJobPost  a  where REPLACE(a.companyname, '''', '')  in (
            select b.name COLLATE Latin1_General_CI_AI from ofuser.customertargetlist c, tag b where c.newstagstatus =b.id and c.appuserid=@userid   )
		   
		   INSERT INTO indeedjobsnotmatch(Title,Company,JobPosted,InsertedDate,typeofdate,keyword,Location)
	        select distinct REPLACE(a.jobtitle, '''', '')as Title ,REPLACE(a.companyname, '''', '') as Company,REPLACE(a.JobPosted, '''', '') as JobPosted, CONVERT(varchar,InsertedDate,101) as InsertedDate,'',REPLACE(a.keyword, '''', '') as Keyword,REPLACE(a.location, '''', '') as Location
                 from IndeedJobPost  a  where REPLACE(a.companyname, '''', '') not in (
            select b.name COLLATE Latin1_General_CI_AI from ofuser.customertargetlist c, tag b where c.newstagstatus =b.id and c.appuserid=@userid   )
       
   update Indeedjobsmatch set typeofdate= REPLACE(SUBSTRING(jobposted, CHARINDEX(' ', jobposted), LEN(jobposted)), 'ago', '') 
   update Indeedjobsmatch set jobposted= LEFT(jobposted, CHARINDEX(' ', jobposted) - 1) 
   update Indeedjobsmatch set jobposted= REPLACE(jobposted, '+', '') 


   update Indeedjobsnotmatch set typeofdate= REPLACE(SUBSTRING(jobposted, CHARINDEX(' ', jobposted), LEN(jobposted)), 'ago', '') 
   update Indeedjobsnotmatch set jobposted= LEFT(jobposted, CHARINDEX(' ', jobposted) - 1)
   update Indeedjobsnotmatch set jobposted= REPLACE(jobposted, '+', '') 
End	
