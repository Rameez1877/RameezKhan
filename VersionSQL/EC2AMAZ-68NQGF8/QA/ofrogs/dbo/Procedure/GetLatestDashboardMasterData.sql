/****** Object:  Procedure [dbo].[GetLatestDashboardMasterData]    Committed by VersionSQL https://www.versionsql.com ******/

-- Kabir 16 feb 2022
-- last edit: 23 feb 2022
CREATE PROCEDURE [dbo].[GetLatestDashboardMasterData]
AS 
BEGIN
SET NOCOUNT ON;
		
		INSERT into MASTER.TechTeamIntent
		select distinct
		'Technology', StackTechnologyName,1
		from TechStackTechnology
		where IsActive = 1
		AND StackTechnologyName NOT IN (SELECT DISTINCT DataString FROM MASTER.TechTeamIntent WHERE DataType = 'Technology')


		INSERT into MASTER.TechTeamIntent
		select distinct
		'Intent', Name,1
		from McDecisionmaker
		where IsActive = 1
		AND Name NOT IN (SELECT DISTINCT DataString FROM MASTER.TechTeamIntent WHERE DataType = 'Intent')
		
		
		;with cte as ( select distinct
		'Team' a,Name,1 d
		from McDecisionmaker
		where IsActive = 1 and IsTeams = 1
		and Name NOT IN (SELECT DISTINCT DataString FROM MASTER.TechTeamIntent WHERE DataType = 'Team')
		union 
		select distinct
		'Team' a,TeamName,1 d
		from cache.OrganizationTeams
		where TeamName NOT IN (SELECT DISTINCT DataString FROM MASTER.TechTeamIntent WHERE DataType = 'Team')
		)
		INSERT into MASTER.TechTeamIntent
		select distinct * from cte


		;with cte as (
		select distinct
		TeamName
		from cache.OrganizationTeams where TeamName not in (select distinct 
		Name
		from McDecisionmaker where IsActive = 1 ))
		INSERT into MASTER.TechTeamIntent
		select 'Team',TeamName,1 from cte where TeamName not in (select distinct DataString from master.TechTeamIntent
		where DataType = 'Team')


		
TRUNCATE TABLE MASTER.OrganizationSummary


;with cte as(
SELECT distinct
o.id OrganizationId,F.ID ID
FROM Organization o 
inner join cache.OrganizationTeams OT  with(nolock) ON O.Id = OT.OrganizationId
INNER JOIN MASTER.TechTeamIntent F  with(nolock) ON F.DataString = OT.TeamName
where DataType = 'Team'

UNION

SELECT DISTINCT
O.Id OrganizationId, F.ID ID
FROM Organization O
INNER JOIN SurgeSummary S ON S.OrganizationId = O.Id
INNER JOIN MASTER.TechTeamIntent F  with(nolock) ON F.DataString = S.Functionality
where DataType = 'Intent'

UNION

SELECT DISTINCT 
o.Id OrganizationId, f.ID ID
FROM Organization O
INNER JOIN Technographics T ON T.OrganizationId = O.Id
INNER JOIN MASTER.TechTeamIntent F  with(nolock) ON F.DataString = T.Keyword
where DataType = 'Technology')
insert into MASTER.OrganizationSummary(OrganizationID,TechnologyFunctionalityID)
select distinct
OrganizationId,ID
from cte


TRUNCATE TABLE NewHireTouchPoint

	INSERT INTO NewHireTouchPoint(Id,Name,FirstName,LastName,Designation,DateOfJoining,
	Url,Country,EmailId,[Touch Point],NewHire,OrganizationID,ResultantCountry,Organization
	,WebsiteURL)

	SELECT distinct 
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.Designation as Designation,
			 l.DateOfJoining,	
			 l.Url,
			 l.ResultantCountry as Country,
			 sc.EmailId,
			 'Work Anniversary - Next Month' AS 'Touch Point',
			 'No' AS 'NewHire'
			,L.OrganizationID,ResultantCountry,O.name,o.Websiteurl
	FROM	LinkedInDataNewHire l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
			INNER JOIN Organization O ON O.id = sc.OrganizationID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND L.Id NOT IN (SELECT ID FROM NewHireTouchPoint)
			



		INSERT INTO NewHireTouchPoint(Id,Name,FirstName,LastName,Designation,DateOfJoining,
		Url,Country,EmailId,[Touch Point],NewHire,OrganizationID,ResultantCountry,Organization
		,WebsiteURL)
			SELECT distinct 
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.Designation as Designation,
			 l.DateOfJoining,	
			 l.Url,
			 l.ResultantCountry as Country,
			 sc.EmailId,
			 'Work Anniversary - This Month' AS 'Touch Point',
			 'No' AS 'NewHire'
			 ,L.OrganizationID,ResultantCountry,o.name,O.WebsiteURL
	FROM	LinkedInDataNewHire l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
			INNER JOIN Organization O ON O.id = sc.OrganizationID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND L.Id NOT IN (SELECT ID FROM NewHireTouchPoint)
			AND L.Id NOT IN (SELECT ID FROM NewHireTouchPoint)


	INSERT INTO NewHireTouchPoint(Id,Name,FirstName,LastName,Designation,DateOfJoining,
	Url,Country,EmailId,[Touch Point],NewHire,OrganizationID,ResultantCountry,Organization
	,WebsiteURL)
			SELECT distinct 
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.Designation as Designation,
			 l.DateOfJoining,	
			 l.Url,
			 l.ResultantCountry as Country,
			 sc.EmailId,
			 'Work Anniversary - Last Month' AS 'Touch Point',
			 'No' AS 'NewHire',L.OrganizationID,ResultantCountry,O.name,o.Websiteurl
	FROM	LinkedInDataNewHire l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
			INNER JOIN Organization O ON O.id = sc.OrganizationID
	WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) -1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			AND L.Id NOT IN (SELECT ID FROM NewHireTouchPoint)
		


	INSERT INTO NewHireTouchPoint(Id,Name,FirstName,LastName,Designation,DateOfJoining,
	Url,Country,EmailId,[Touch Point],NewHire,OrganizationID,ResultantCountry,Organization
	,WebsiteURL)
			SELECT distinct 
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.Designation as Designation,
			 l.DateOfJoining,	
			 l.Url,
			 l.ResultantCountry as Country,
			 sc.EmailId,
			 'New Hire' AS [Touch Point],
			 'Yes' AS 'NewHire',L.OrganizationID,ResultantCountry,O.name,o.Websiteurl
	FROM	LinkedInDataNewHire l With (Nolock)
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			Inner join SurgeContactDetail sc  With (Nolock) on (l.Url= sc.Url)
			INNER JOIN Organization O ON O.id = sc.OrganizationID
	WHERE 
			convert(date,l.DateOfJoining) > getdate() - 90
			AND L.Id NOT IN (SELECT ID FROM NewHireTouchPoint)



		


	TRUNCATE TABLE master.ContactListSummary

	insert into master.ContactListSummary(LinkedInID,TypeID,OrganizationID,ResultantCountryId,EmailID,SeniorityLevel)
	SELECT DISTINCT
	l.id LinkedInID,
	MT.ID TypeID,
	O.Id OrganizationID,
	l.ResultantCountryId,
	S.EmailId,
	L.SeniorityLevel
  FROM linkedindata l with (nolock)
  INNER JOIN McDecisionmakerlist m with (nolock)
    ON m.DecisionMakerId = l.id
	INNER JOIN MASTER.TechTeamIntent MT 
	ON MT.DataString = M.Name
	INNER JOIN Organization o with (nolock)
        on (o.Id = l.OrganizationId)
  INNER JOIN SurgeContactDetail s with (nolock)
    ON (s.Url = l.url)
	WHERE MT.DataType = 'Intent'

END
