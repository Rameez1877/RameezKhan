/****** Object:  View [dbo].[Dashboard_IndeedJobSummary25]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[Dashboard_IndeedJobSummary25]
as
Select   insertedDate, Count(*) jobcount from IndeedJobpost 
where tagtypeid IN (25) and convert(date,insertedDate) 
BETWEEN  DATEADD(DD,-15, convert(date,getdate()))  AND convert(date,getdate()) 
GROUP BY insertedDate
