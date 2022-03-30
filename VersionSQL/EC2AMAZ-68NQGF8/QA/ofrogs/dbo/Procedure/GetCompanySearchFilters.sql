/****** Object:  Procedure [dbo].[GetCompanySearchFilters]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetCompanySearchFilters] @UserId int,@AllFilter BIT = 0
AS BEGIN
SET NOCOUNT ON;

DECLARE @Run BIT , @IsGIC BIT , @IsApp BIT, @Count int , @CountFilters INT,@IsStaffing BIT
DECLARE @PersonaIds VARCHAR(200), @RegionIds VARCHAR(200),  @IndustryGroupIds VARCHAR(200)


SELECT @PersonaIds = PersonaIds,@RegionIds = RegionIds,@IndustryGroupIds = IndustryGroupIds FROM AppUser WHERE Id = @UserID
SET @IsGIC = IIF((SELECT CustomerType FROM AppUser WHERE Id = @UserID)= 'gcc',1,0)
SET @IsApp = IIF((SELECT CustomerType FROM AppUser WHERE Id = @UserID)= 'app',1,0)
SET @IsStaffing = IIF((SELECT CustomerType FROM AppUser WHERE Id = @UserID)= 'staffing',1,0)





SET @Run = IIF(EXISTS(SELECT TOP 1 * FROM UserFilters WHERE UserID = @UserId),0,1)



IF @Run = 1 AND @AllFilter = 0 
BEGIN
PRINT 'Insert'

IF @IsStaffing = 1
BEGIN

PRINT '@IsStaffing'


insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingIndustry'



insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingCountry'



insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingEmployeeCount'


insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingRevenue'


insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingIntent'

insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingTeam'

insert into UserFilters
SELECT DISTINCT ID,FilterType,Category,Data,DataString,@UserId FROM UserFilters WHERE UserID = 123456789 AND FilterType = 'StaffingTechnology'


EXEC [GetCompanySearchFilters] @UserID,0

END
ELSE 
BEGIN
Print 'Not Staffing'

SELECT VALUE INTO #T  FROM string_split(@PersonaIds,',')
SELECT VALUE INTO #PersonaIds FROM string_split(@PersonaIds,',')
SELECT VALUE INTO #RegionIds FROM string_split(@RegionIds,',')
SELECT VALUE INTO #IndustryGroupIds FROM string_split(@IndustryGroupIds,',')


SELECT DISTINCT T.OrganizationID INTO #OrgID
FROM master.PersonaData T  WITH(NOLOCK)
INNER JOIN #PersonaIds P ON P.value = T.PersonaID
INNER JOIN #RegionIds R ON R.value = T.RegionID
INNER JOIN #IndustryGroupIds  I ON I.value = T.IndustryGroupID


SELECT DISTINCT  T.TechTeamIntentID TypeID  INTO #TTIID
FROM master.PersonaData T WITH(NOLOCK)
INNER JOIN #PersonaIds P ON P.value = T.PersonaID
INNER JOIN #RegionIds R ON R.value = T.RegionID
INNER JOIN #IndustryGroupIds  I ON I.value = T.IndustryGroupID


insert into UserFilters
select distinct
i.Id,'Industry',ig.Name IndustryGroup,i.Name,count(distinct OrganizationID),@UserId
from #OrgID t
inner join Organization o on o.Id = t.OrganizationID
inner join Industry i on i.Id = o.IndustryId
inner join IndustryGroup ig on ig.Id = i.IndustryGroupId
where o.CountryId is not null and O.IndustryId is not null
group by i.id,i.Name,ig.Name


insert into UserFilters
select distinct
c.Id,'Country',null,c.Name,count(distinct OrganizationID),@UserId
from #OrgID t
inner join Organization o on o.Id = t.OrganizationID
inner join Country c on c.Id = o.CountryId
where o.CountryId is not null and O.IndustryId is not null
group by c.id,c.Name




insert into UserFilters
select distinct 
0,'EmployeeCount',null,EmployeeCount,count(distinct OrganizationID),@UserId
from #OrgID t
inner join Organization o on o.Id = t.OrganizationID
where o.CountryId is not null and O.IndustryId is not null
group by EmployeeCount


insert into UserFilters
select distinct 
0,'Revenue',null,Revenue,count(distinct OrganizationID),@UserId
from #OrgID t
inner join Organization o on o.Id = t.OrganizationID
where o.CountryId is not null and O.IndustryId is not null
group by Revenue


insert into UserFilters
select distinct
tt.ID,tt.DataType,PE.Name,tt.DataString,null,@UserId
from #TTIID t
inner join master.TechTeamIntent tt on t.TypeID = tt.ID
INNER JOIN MASTER.PersonaTechTeamIntent P ON P.TechnologyFunctionalityID = T.TypeID
INNER JOIN Persona PE ON PE.Id = P.PersonaID
inner join #T on value = p.PersonaID
group by tt.ID,tt.DataType,tt.DataString,PE.Name


EXEC [GetCompanySearchFilters] @UserID,0
END
END



IF @AllFilter = 0 AND @Run = 0
BEGIN

IF @IsStaffing = 1 

BEGIN

PRINT 'Display while   @AllFilter = 0 AND @Run = 0'
-- Intent
SELECT DISTINCT
ID AdoptionID ,Category ,CASE Data WHEN  'Human Resource' THEN 'Human Resources' 
ELSE Data END AS Functionality
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingIntent'
order by Functionality



-- Team
SELECT DISTINCT
ID AdoptionID,Category--,Data  AS Functionality
,CASE Data WHEN  'Human Resource' THEN 'Human Resources' ELSE Data END AS Functionality
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingTeam'
order by Functionality


-- Technology
SELECT DISTINCT
ID AdoptionTechnologyID,Category TechnologyCategory,Data Technology
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingTechnology'





-- EmployeeCount
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name, DataString nooforganizations, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingEmployeeCount'
order by convert(int,DataString) desc




-- Revenue
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name , DataString nooforganizations, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingRevenue'
order by convert(int,DataString) desc



-- Country
SELECT DISTINCT
id,DATA countryname,DataString nooforganizations, data + ' (' + DataString + ') '  as name, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingCountry'
order by convert(int,DataString) desc



-- Industry
SELECT DISTINCT
ID,Data IndustryName , Category IndustryGroup ,DataString nooforganizations, data + ' (' + DataString + ') '  as Name,convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'StaffingIndustry'
order by convert(int,DataString) desc
END

ELSE
BEGIN

PRINT 'Display while   @AllFilter = 0 AND @Run = 0'
-- Intent
SELECT DISTINCT
ID AdoptionID ,Category ,CASE Data WHEN  'Human Resource' THEN 'Human Resources' 
ELSE Data END AS Functionality
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Intent'
order by Functionality



-- Team
SELECT DISTINCT
ID AdoptionID,Category--,Data  AS Functionality
,CASE Data WHEN  'Human Resource' THEN 'Human Resources' ELSE Data END AS Functionality
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Team'
order by Functionality


-- Technology
SELECT DISTINCT
ID AdoptionTechnologyID,Category TechnologyCategory,Data Technology
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Technology'





-- EmployeeCount
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name, DataString nooforganizations, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'EmployeeCount'
order by convert(int,DataString) desc




-- Revenue
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name , DataString nooforganizations, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Revenue'
order by convert(int,DataString) desc



-- Country
SELECT DISTINCT
id,DATA countryname,DataString nooforganizations, data + ' (' + DataString + ') '  as name, convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Country'
order by convert(int,DataString) desc



-- Industry
SELECT DISTINCT
ID,Data IndustryName , Category IndustryGroup ,DataString nooforganizations, data + ' (' + DataString + ') '  as Name,convert(int,DataString) Counts
FROM UserFilters
WHERE UserID = @UserId
AND FilterType = 'Industry'
order by convert(int,DataString) desc
END
END

IF @AllFilter = 1
BEGIN

	PRINT '@AllFilter = 1'


	IF @IsGIC = 0 and @IsApp = 0
	BEGIN

	PRINT 'Not gic and not App so company search probably'







-- Intent
SELECT DISTINCT
ID AdoptionID ,Category ,Data Functionality
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Intent'
order by Functionality



-- Team
SELECT DISTINCT
ID AdoptionID,Category,Data Functionality
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Team'
order by Functionality



-- Technology
SELECT DISTINCT
ID AdoptionTechnologyID,Category TechnologyCategory,Data Technology
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Technology'




-- EmployeeCount
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name, DataString nooforganizations,convert(int,Datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'EmployeeCount'
order by convert(int,Datastring) desc



-- Revenue
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name , DataString nooforganizations, convert(int,Datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Revenue'
order by convert(int,Datastring) desc



-- Country
SELECT DISTINCT
id,DATA countryname,DataString nooforganizations, data + ' (' + DataString + ') '  as name, convert(int,Datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Country'
order by convert(int,Datastring) desc



-- Industry
SELECT DISTINCT
ID,Data IndustryName , Category IndustryGroup ,DataString nooforganizations, data + ' (' + DataString + ') '  as Name, convert(int,Datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'Industry'
order by convert(int,Datastring) desc
END


ELSE IF @IsGIC = 1 AND @IsApp = 0
BEGIN

PRINT '@IsGIC = 1 AND @IsApp = 0'
	-- Intent
SELECT DISTINCT
'' AdoptionID ,'' Category ,'' Functionality


-- Team
SELECT DISTINCT
ID AdoptionID,Category,Data Functionality 
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicTeam'
order by Functionality



-- Technology
SELECT DISTINCT
ID AdoptionTechnologyID,Category TechnologyCategory,Data Technology
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicTechnology'




-- EmployeeCount
SELECT DISTINCT
Data ID, data + ' (' + DataString + ') '  as name, DataString nooforganizations,convert(int,datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicEmployeeCount'
order by convert(int,datastring) desc



-- Revenue
SELECT DISTINCT 
Data ID, data + ' (' + DataString + ') '  as name , DataString nooforganizations, convert(int,datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicRevenue'
order by convert(int,datastring) desc

-- Country
SELECT DISTINCT
id,DATA countryname, data + ' (' + DataString + ') '  as name, convert(int,datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicCountry'
order by convert(int,datastring) desc

-- Industry
SELECT DISTINCT
ID,Data IndustryName , Category IndustryGroup , data + ' (' + DataString + ') '  as Name, convert(int,datastring) Counts
FROM UserFilters
WHERE UserID = 123456789
AND FilterType = 'GicIndustry'
order by convert(int,datastring) desc
END

ELSE IF @IsApp = 1 and @IsGIC = 0
BEGIN
PRINT '@IsApp = 1'
END

END
END
