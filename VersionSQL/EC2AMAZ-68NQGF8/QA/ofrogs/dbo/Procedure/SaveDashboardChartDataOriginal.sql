/****** Object:  Procedure [dbo].[SaveDashboardChartDataOriginal]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveDashboardChartDataOriginal]
	@UserId int = 1
AS
BEGIN
	SET NOCOUNT ON;
	declare @PersonaIds varchar(100), @RegionIds varchar(100), @CountryIds varchar(1000), @IndustryIds varchar(1000)
	declare @EmployeeCounts varchar(1000), @Revenues varchar(1000), @TechnologyIds varchar(1000), @FunctionalityIds varchar(1000)

	SELECT @PersonaIds = PersonaIds, @RegionIds = RegionIds from AppUser where Id = @UserId

	If not exists (select 1 from AppUserSettings where UserId = @UserId)
	Begin
		insert into AppUserSettings(UserId, PersonaIds) values (@UserId, @PersonaIds)
	End

	select trim([value]) as [Id] into #PersonaIds from string_split(@PersonaIds, ',')
	select trim([value]) as [Id] into #RegionIds from string_split(@RegionIds, ',')

	select Id, [Name] into #Country from Country where IsRegion in (select Id from #RegionIds)

	select @CountryIds = STRING_AGG(Id, ',') from #Country

	select distinct p.Id, p.[Name] as Persona ,a.Functionality into  #TempPersona from persona p 
	inner join adoptionframework a  on (p.name = a.category)
	inner join mcdecisionmaker m on (m.name =a.Functionality and m.isteams=1 and m.isactive=1)
	and p.Id in (select Id from #PersonaIds)
 
	---Team Intelligence--
	select distinct Organizationid,c.TeamName into  #TempTeam from cache.OrganizationTeams c
	inner join #TempPersona tp on (c.teamname=tp.functionality)
	where tp.Id in (select Id from #PersonaIds)
	order by Organizationid
 
	-- select * from  #TempPersona
 
	--TechnoGraphics---
	select t.OrganizationId,t.keyword,tc.StackType 
	into  #TempTechnology from persona p 
	inner join adoptionframeworktechnologycategory att on  (p.name = att.category)
	inner join TechStackTechnology tss on (tss.StackSubCategoryId=att.TechnologyCategoryid)
	inner join techstacksubcategory tc on (tc.id=tss.stacksubcategoryid)
	inner join Technographics t on (t.keyword=tss.StackTechnologyName)
	where p.Id in (select Id from #PersonaIds)
 
	--Accounts by Functionality--
 
	select distinct s.OrganizationId,
	s.Functionality,
	s.investmenttype
	into  #TempSurge from SurgeSummary s 
	inner join adoptionframework a  on (s.functionality = a.functionality)
	inner join persona p  on (a.category = p.name)
	and p.Id in (select Id from #PersonaIds)
	order by  s.OrganizationId
 
	SELECT distinct o.Id, o.[Name], o.WebsiteUrl, o.EmployeeCount, o.Revenue, i.Id as IndustryId, i.name as [IndustryName], O.CountryId,
	t.keyword as Technology, t.StackType, s.Functionality, s.InvestmentType, c.TeamName
	into #Result
	FROM 
		organization o
		inner join industry i on (i.id = o.IndustryId)
		left JOIN  #TempTeam c ON (o.Id = c.OrganizationId )
		left join  #temptechnology t on (o.id =t.OrganizationId )
		left join #tempsurge s on (o.id = s.OrganizationId )
	where o.CountryId = 13 and --in (select Id from #Country) and 
		o.id in
	 (select organizationid from #TempTeam union 
		select organizationid from #temptechnology
		union 
		select organizationid from #tempsurge
	)
	order by t.keyword desc , s.Functionality desc,c.TeamName desc

	--select count(distinct Id) as HighScoringAccount, count(1) TotalAccounts from #Result

	--select top 4 C.Id, C.[Name], count(1) as [Value] from #Result R inner join #Country C on (C.Id = R.CountryId) group by C.Id, C.[Name]

	--select top 4 [IndustryName] as [Name], count(1) as [Value] from #Result R group by [IndustryName] order by 2 desc

	--select top 4 Technology as [Name], count(1) as [Value] from #Result where Technology is not null group by Technology order by 2 desc

	--select top 4 Revenue as [Name], count(1) as [Value] from #Result where Revenue is not null group by Revenue order by 2 desc

	--select top 4 EmployeeCount as [Name], count(1) as [Value] from #Result where EmployeeCount is not null group by EmployeeCount order by 2 desc

	--select top 4 Functionality as [Name], count(1) as [Value] from #Result where Functionality is not null group by Functionality order by 2 desc

	select distinct a.Functionality into  #TempPersona2 
	from persona p 
	inner join adoptionframework a  on (p.name = a.category)
	inner join mcdecisionmaker m on (m.name =a.Functionality and m.isteams=1 and m.isactive=1)
	and p.Id in (select Id from #PersonaIds)

	select @FunctionalityIds = STRING_AGG(Functionality, ',') from #TempPersona2

	--select @TechnologyIds = STRING_AGG(t.keyword, ',')
	--from persona p 
	--inner join adoptionframeworktechnologycategory att on  (p.name = att.category)
	--inner join TechStackTechnology tss on (tss.StackSubCategoryId=att.TechnologyCategoryid)
	--inner join techstacksubcategory tc on (tc.id=tss.stacksubcategoryid)
	--inner join Technographics t on (t.keyword=tss.StackTechnologyName)
	--where p.Id in (select Id from #PersonaIds)

	select @EmployeeCounts = STRING_AGG(EmployeeCount, ',') from (select distinct EmployeeCount from #Result) T
	select @IndustryIds = STRING_AGG(IndustryId, ',') from (select distinct IndustryId from #Result) T
	select @Revenues = STRING_AGG(Revenue, ',') from (select distinct Revenue from #Result) T
	select @TechnologyIds = STRING_AGG(Technology, ',') from (select distinct Technology from #Result) T

	-- select * from #Result

	update AppUserSettings
	set
		CountryIds = @CountryIds,
		IndustryIds = @IndustryIds,
		EmployeeCounts = @EmployeeCounts,
		Revenues = @Revenues,
		TechnologyIds = @TechnologyIds,
		FunctionalityIds = @FunctionalityIds
	where
		UserId = @UserId

	select * from AppUserSettings where UserId = @UserId

END
