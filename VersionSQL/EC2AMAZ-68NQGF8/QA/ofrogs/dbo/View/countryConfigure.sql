/****** Object:  View [dbo].[countryConfigure]    Committed by VersionSQL https://www.versionsql.com ******/

create view countryConfigure
as
select UTC.UserId, c.name as CountryName from UserTargetCountry UTC, Country C
where c.id = UTC.countryID
