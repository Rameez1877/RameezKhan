/****** Object:  View [dbo].[orgScoreBoardGraph]    Committed by VersionSQL https://www.versionsql.com ******/

create view dbo.orgScoreBoardGraph 
as
select newsQuarter,displayname,concat(newsQuarter , '-', displayname) as names ,count(tagname)as orgcount  from OutputIndustrySignalAnalysis 
group by newsQuarter,displayname
