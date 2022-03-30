/****** Object:  View [dbo].[indiaTest]    Committed by VersionSQL https://www.versionsql.com ******/

create view indiaTest 
as
select *from linkedinapi where countryid = 13
