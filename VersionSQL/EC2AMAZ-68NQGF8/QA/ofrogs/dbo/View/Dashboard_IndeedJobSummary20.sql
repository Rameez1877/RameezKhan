/****** Object:  View [dbo].[Dashboard_IndeedJobSummary20]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Dashboard_IndeedJobSummary20]
as
Select insertedDate createddate, Count(*) jobcount from IndeedJobpost 
where tagtypeid IN (20) and convert(date,insertedDate) 
BETWEEN  DATEADD(DD,-15, convert(date,getdate()))  AND convert(date,getdate()) 
GROUP BY insertedDate
