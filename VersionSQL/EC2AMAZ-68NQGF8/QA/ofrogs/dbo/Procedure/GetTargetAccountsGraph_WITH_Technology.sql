/****** Object:  Procedure [dbo].[GetTargetAccountsGraph_WITH_Technology]    Committed by VersionSQL https://www.versionsql.com ******/

-- [GetTargetAccountsGraph_WITH_Technology] 29516

CREATE procedure [dbo].[GetTargetAccountsGraph_WITH_Technology]
@targetpersonaid int
AS

BEGIN

create table #tempgraph(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)
create table #tempHQ(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)
create table #tempIndustry(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)
create table #tempRevenue(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)
create table #tempEmpCount(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)
create table #tempTechnology(TargetPersonaId int,DataType varchar(100),DataString varchar(2000),DataValue int)

insert into #tempHQ(TargetPersonaId,Datatype,DataString,DataValue)
select @targetpersonaid,'HQ',c.name as CountryName, COUNT(1) 
from TargetPersonaOrganization tor,Organization o,Country c
where tor.OrganizationId = o.Id and c.ID = o.CountryId  and targetpersonaid=@targetpersonaid
Group By c.name

insert into #tempIndustry(TargetPersonaId,Datatype,DataString,DataValue)
select @targetpersonaid,'Industry',i.Name as IndustryName, COUNT(1) 
from TargetPersonaOrganization tor,Organization o,Industry i
where tor.OrganizationId = o.Id and i.ID = o.IndustryId and targetpersonaid=@targetpersonaid
Group By i.Name

insert into #tempRevenue(TargetPersonaId,Datatype,DataString,DataValue)
select @targetpersonaid,'Revenue',o.Revenue as Revenue, COUNT(1) 
from TargetPersonaOrganization tor,Organization o,Country c
where tor.OrganizationId = o.Id and c.ID = o.CountryId  and targetpersonaid=@targetpersonaid
Group By o.Revenue

insert into #tempEmpCount(TargetPersonaId,Datatype,DataString,DataValue)
select @targetpersonaid,'Emp Count',o.EmployeeCount as EmployeeCount, COUNT(1) 
from TargetPersonaOrganization tor,Organization o,Country c
where tor.OrganizationId = o.Id and c.ID = o.CountryId and targetpersonaid=@targetpersonaid
Group By o.EmployeeCount

insert into #tempTechnology(TargetPersonaId,Datatype,DataString,DataValue)
select TOP 10 @targetpersonaid,'Technology',T.Keyword as Technology, COUNT(1) 
from TargetPersonaOrganization tor,Organization o,Country c,Technographics T
where tor.OrganizationId = o.Id and c.ID = o.CountryId and targetpersonaid=@targetpersonaid AND T.OrganizationId = TOR.OrganizationId AND O.Id = T.OrganizationId
Group By T.Keyword
ORDER BY 3 DESC


insert into #tempgraph(TargetpersonaId,Datatype,DataString,DataValue)
select TargetpersonaId,DataType,DataString,DataValue from #tempHQ
UNION
select TargetpersonaId,DataType,DataString,DataValue from #tempIndustry
UNION
select TargetpersonaId,DataType,DataString,DataValue from #tempRevenue
UNION
select TargetpersonaId,DataType,DataString,DataValue from #tempEmpCount
UNION
select TargetpersonaId,DataType,DataString,DataValue from #tempTechnology

select * from #tempgraph 

END
