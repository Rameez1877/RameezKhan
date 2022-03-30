/****** Object:  Procedure [dbo].[PopulateDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[PopulateDashboardData]
	 @UserId int 
AS 
BEGIN
--SET NOCOUNT ON
--	declare @PersonaIds varchar(100), @RegionIds varchar(100), @CustomerType varchar(15), 
--	@IndustryGroupIds varchar(100)--,@USERID INT = 159

--	SELECT @PersonaIds = PersonaIds, @RegionIds = RegionIds, @CustomerType = CustomerType,
--	@IndustryGroupIds = IndustryGroupIds
--	from AppUser where Id = @UserId

--	IF @CustomerType IS NULL
--	BEGIN
--	SELECT 'User has no configuration'
--	END
--	ELSE
--	BEGIN
--	DELETE FROM DashboardDataSummary WHERE USERID = @UserId
--	DELETE FROM OtherProspect WHERE USERID = @UserId

--	select trim([value]) as [Id] into #PersonaIds from string_split(@PersonaIds, ',')
--	select trim([value]) as [Id] into #RegionIds from string_split(@RegionIds, ',')
--	select trim([value]) as [Id] into #IndustryGroupIds from string_split(@IndustryGroupIds, ',')


--	select Id, [Name] into #Country from Country where IsRegion in (select Id from #RegionIds)
--	Select Id,Name into #industry from Industry where IndustryGroupId in (select Id from #IndustryGroupIds)

--	select distinct p.Id, p.[Name] as Persona ,a.Functionality into  #TempPersona from persona p 
--	inner join adoptionframework a  on (p.name = a.category)
--	inner join mcdecisionmaker m on (m.name =a.Functionality and m.isteams=1 and m.isactive=1)
--	and p.Id in (select Id from #PersonaIds)
 
--	---Team Intelligence--
--	select distinct Organizationid,c.TeamName into  #TempTeam from cache.OrganizationTeams c
--	inner join #TempPersona tp on (c.teamname=tp.functionality)
--	where tp.Id in (select Id from #PersonaIds)
 
 
--	--TechnoGraphics---
--	select t.OrganizationId,t.keyword,tc.StackType 
--	into  #TempTechnology from persona p 
--	inner join adoptionframeworktechnologycategory att on  (p.name = att.category)
--	inner join TechStackTechnology tss on (tss.StackSubCategoryId=att.TechnologyCategoryid)
--	inner join techstacksubcategory tc on (tc.id=tss.stacksubcategoryid)
--	inner join Technographics t on (t.keyword=tss.StackTechnologyName)
--	where p.Id in (select Id from #PersonaIds)
 
--	--Accounts by Functionality--
 
--	select distinct s.OrganizationId,
--	s.Functionality,
--	s.investmenttype
--	into  #TempSurge from SurgeSummary s 
--	inner join adoptionframework a  on (s.functionality = a.functionality)
--	inner join persona p  on (a.category = p.name)
--	and p.Id in (select Id from #PersonaIds)
	
--	INSERT INTO DashboardDataSummary (OrganizationId,Name,WebsiteUrl,EmployeeCount,Revenue,
--	IndustryID,IndustryName,CountryId,CountryName,Technology,
--	StackType,Functionality,InvestmentType,TeamName,WebSiteDescription,UserID)
	
--	SELECT distinct o.Id, o.[Name], o.WebsiteUrl, o.EmployeeCount, o.Revenue,o.IndustryId
--	, i.name as [IndustryName], O.CountryId,CO.Name,
--	t.keyword , t.StackType, s.Functionality, s.InvestmentType, c.TeamName,O.WebsiteDescription,
--	@UserId
--	FROM 
--		organization o
--		inner join #industry i on (i.id = o.IndustryId)
--		INNER JOIN #Country CO ON (CO.ID = O.CountryId)
--		left JOIN  #TempTeam c ON (o.Id = c.OrganizationId )
--		left join  #temptechnology t on (o.id =t.OrganizationId )
--		left join #tempsurge s on (o.id = s.OrganizationId )
--	where o.id in
--	 (select organizationid from #TempTeam union 
--		select organizationid from #temptechnology
--		union 
--		select organizationid from #tempsurge
--	)
	

--	UPDATE DashboardDataSummary SET 
--	PersonaIds = @PersonaIds,
--	RegionIds = @RegionIds,
--	CustomerType = @CustomerType,
--	IndustryGroupIds = @IndustryGroupIds
--	WHERE USERID = @UserId AND OrganizationID = 
--	(SELECT TOP 1 OrganizationID	
--	FROM DashboardDataSummary
--	WHERE USERID = @USERID)

	
--	INSERT INTO OtherProspect (OtherProspectAccount, UserID)
--	SELECT COUNT(*),@UserId FROM DashboardDataSummary WHERE USERID = @UserId

--	END

select null
END
