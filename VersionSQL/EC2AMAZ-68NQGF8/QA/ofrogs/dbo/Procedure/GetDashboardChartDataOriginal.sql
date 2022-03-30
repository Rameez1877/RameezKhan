/****** Object:  Procedure [dbo].[GetDashboardChartDataOriginal]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].GetDashboardChartDataOriginal
	 @UserId int = 159
AS 
BEGIN
SET NOCOUNT ON
	declare @PersonaIds varchar(100), @RegionIds varchar(100), @CustomerType varchar(15), 
	--@RevenueCategoryIds varchar(15),
	@IndustryGroupIds varchar(100)

	SELECT @PersonaIds = PersonaIds, @RegionIds = RegionIds, @CustomerType = CustomerType,
	-- @RevenueCategoryIds = RevenueCategoryIds, 
	@IndustryGroupIds = IndustryGroupIds
	from AppUser where Id = @UserId

	select trim([value]) as [Id] into #PersonaIds from string_split(@PersonaIds, ',')
	select trim([value]) as [Id] into #RegionIds from string_split(@RegionIds, ',')
	-- select trim([value]) as [Id] into #RevenueCategoryIds from string_split(@RevenueCategoryIds, ',')
	select trim([value]) as [Id] into #IndustryGroupIds from string_split(@IndustryGroupIds, ',')


	select Id, [Name] into #Country from Country where IsRegion in (select Id from #RegionIds)

	--new changes 28 oct
	--select RM.Revenue into #Revenue from RevenueMapping RM
	--INNER JOIN REVENUECATEGORY RC ON (RC.NAME = RM.CATEGORY)
	--and RC.Id in (Select Id from #RevenueCategoryIds)

	--select  EM.EmployeeCount into #EmployeeCount from  EmployeeCountMapping EM 
	--INNER JOIN REVENUECATEGORY RC ON (RC.NAME = EM.CATEGORY)
	--and RC.Id in (Select Id from #RevenueCategoryIds)

	Select Id into #industry from Industry where IndustryGroupId in (select Id from #IndustryGroupIds)
	---end--

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
 
	SELECT distinct o.Id, o.[Name], o.WebsiteUrl, o.EmployeeCount, o.Revenue, i.name as [IndustryName], O.CountryId,
	t.keyword as Technology, t.StackType, s.Functionality, s.InvestmentType, c.TeamName
	into #Result
	FROM 
		organization o
		inner join industry i on (i.id = o.IndustryId)
		left JOIN  #TempTeam c ON (o.Id = c.OrganizationId )
		left join  #temptechnology t on (o.id =t.OrganizationId )
		left join #tempsurge s on (o.id = s.OrganizationId )
	where o.CountryId in (select Id from #Country) and-- = 13 and 
	--- new changes 28 Oct to include revenue, employeecount and industry
	-- o.Revenue in (select Revenue from #Revenue)
	 -- and o.EmployeeCount in (select EmployeeCount from #EmployeeCount)
	 o.IndustryId  in (select Id from #industry)
	---- end ---
	and	o.id in
	 (select organizationid from #TempTeam union 
		select organizationid from #temptechnology
		union 
		select organizationid from #tempsurge
	)
	order by t.keyword desc , s.Functionality desc,c.TeamName desc
	


	---------------------------------------------------------------------------  

	If not exists (select 1 from DashboardSummary where UserId = @UserId)
	Begin
		INSERT INTO DashboardSummary (Id,Name,WebsiteUrl,EmployeeCount,Revenue,IndustryID,IndustryName,CountryId,CountryName,Technology,
		StackType,Functionality,InvestmentType,TeamName,WebSiteDescription,UserID)
	SELECT DISTINCT T1.Id,T1.Name,T1.WebsiteUrl,T1.EmployeeCount,T1.Revenue,O.IndustryId,T1.IndustryName,T1.CountryId,C.Name,T1.Technology,
		T1.StackType,T1.Functionality,T1.InvestmentType,T1.TeamName,O.WebsiteDescription,@UserID
	FROM #Result T1
	INNER JOIN Organization O ON O.Id = T1.Id
	INNER JOIN Country C ON C.ID = T1.CountryId
--	CREATE TABLE DashboardSummary (Id INT,Name VARCHAR(100),WebsiteUrl VARCHAR(500),EmployeeCount VARCHAR(100),Revenue VARCHAR(100),
--IndustryID INT,IndustryName VARCHAR(100),CountryId INT,CountryName VARCHAR(200),Technology VARCHAR(100),
--	StackType VARCHAR(100),Functionality VARCHAR(100),InvestmentType VARCHAR(100),TeamName VARCHAR(100),WebSiteDescription VARCHAR(8000),
--		UserID INT)

	End

	ELSE

	BEGIN
	DELETE FROM DashboardSummary WHERE UserId = @UserId
			INSERT INTO DashboardSummary (Id,Name,WebsiteUrl,EmployeeCount,Revenue,IndustryID,IndustryName,CountryId,CountryName,Technology,
		StackType,Functionality,InvestmentType,TeamName,WebSiteDescription,UserID)
	SELECT DISTINCT T1.Id,T1.Name,T1.WebsiteUrl,T1.EmployeeCount,T1.Revenue,O.IndustryId,T1.IndustryName,T1.CountryId,C.Name,T1.Technology,
		T1.StackType,T1.Functionality,T1.InvestmentType,T1.TeamName,O.WebsiteDescription,@UserID
	FROM #Result T1
	INNER JOIN Organization O ON O.Id = T1.Id
	INNER JOIN Country C ON C.ID = T1.CountryId
	END
	--------------------------------------------------- 



	select count(distinct Id) as HighScoringAccount, count(1) TotalAccounts, @CustomerType as CustomerType from #Result

	select top 4 C.Id, C.[Name], count(DISTINCT (R.ID)) as [Value] from #Result R inner join #Country C on (C.Id = R.CountryId) group by C.Id, C.[Name] order by 3 desc

	select top 4 [IndustryName] as [Name], count(DISTINCT (ID)) as [Value] from #Result R group by [IndustryName] order by 2 desc

	select top 4 Technology as [Name], count(DISTINCT (ID)) as [Value] from #Result where Technology is not null group by Technology order by 2 desc
	
	select top 4 Revenue as [Name], count(DISTINCT (ID)) as [Value] from #Result where Revenue is not null group by Revenue order by 2 desc

	select top 4 EmployeeCount as [Name], count(DISTINCT (ID)) as [Value] from #Result where EmployeeCount is not null group by EmployeeCount order by 2 desc

	select top 4 Functionality as [Name], count(DISTINCT (ID)) as [Value] from #Result where Functionality is not null group by Functionality order by 2 desc

	
	--select * from #Result

END
