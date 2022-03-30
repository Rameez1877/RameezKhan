/****** Object:  View [dbo].[Dashboard_emailcount]    Committed by VersionSQL https://www.versionsql.com ******/

Create view dbo.[Dashboard_emailcount]
as
 Select distinct emailid  from LinkedInData where emailid like '%@%'
