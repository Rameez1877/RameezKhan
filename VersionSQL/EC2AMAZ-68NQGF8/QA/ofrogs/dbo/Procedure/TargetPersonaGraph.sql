/****** Object:  Procedure [dbo].[TargetPersonaGraph]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[TargetPersonaGraph]
@targetpersonaid int
AS

BEGIN

create table #tempgraph(TargetPersonaId int,Datatype varchar(100),DataString varchar(2000),DataValue int)
create table #tempHQ(TargetPersonaId int,Datatype varchar(100),DataString varchar(2000),DataValue int)
create table #tempIndustry(TargetPersonaId int,Datatype varchar(100),DataString varchar(2000),DataValue int)
create table #tempRevenue(TargetPersonaId int,Datatype varchar(100),DataString varchar(2000),DataValue int)
create table #tempEmpCount(TargetPersonaId int,Datatype varchar(100),DataString varchar(2000),DataValue int)

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


insert into #tempgraph(TargetpersonaId,Datatype,DataString,DataValue)
select TargetpersonaId,Datatype,DataString,DataValue from #tempHQ
UNION
select TargetpersonaId,Datatype,DataString,DataValue from #tempIndustry
UNION
select TargetpersonaId,Datatype,DataString,DataValue from #tempRevenue
UNION
select TargetpersonaId,Datatype,DataString,DataValue from #tempEmpCount

select * from #tempgraph

END
