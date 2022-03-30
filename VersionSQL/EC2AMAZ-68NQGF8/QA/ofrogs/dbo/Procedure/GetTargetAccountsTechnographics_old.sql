/****** Object:  Procedure [dbo].[GetTargetAccountsTechnographics_old]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetTargetAccountsTechnographics_old] 
@targetpersonaid int
AS
Begin

declare @userid int,
        @targetPersonaName varchar(200),
		@Technologies varchar(2000) = ''

--select @Technologies = Technologies 
--		from Targetpersona WHERE id = @TargetPersonaId

select @userid = CreatedBy,
       @targetPersonaName = [name] 
	   from targetpersona where Id = @targetpersonaid
 
 SELECT DISTINCT
		o.id as OrganizationId,
        o.name AS OrganizationName,
        Tech.Keyword as Technology,
        tssc.StackType as TechnologyCategory,
		c.name as CountryName,
		i.name as IndustryName,
		o.Revenue as Revenue,
		o.EmployeeCount as EmployeeCount,
	    case when O.WebsiteUrl like'%https%' then O.WebsiteUrl else 'https://' + O.WebsiteUrl end WebsiteUrl,
		--@targetPersonaName as targetPersonaName, 
			SortOrder = case when i.Name <> 'Unknown' 
				and o.EmployeeCount <> 'Unknown' 
				and	o.Revenue <> 'Unknown' then 1 
				else 0 end
 FROM   
	Technographics Tech WITH (NOLOCK)
	inner join TechStackTechnology tst on (tech.keyword = tst.stacktechnologyname)
	inner join TechStackSubCategory tssc on (tst.StackSubCategoryId = tssc.Id)
	inner join TargetPersonaorganization tpo on (tpo.OrganizationId = Tech.OrganizationId 
	and  tpo.targetpersonaid = @targetpersonaid)
	inner join Organization o  WITH (NOLOCK) on (tpo.OrganizationId = o.id)
	left join Industry i on (o.industryid = i.id)
	left join Country c on (o.countryid = c.id)
 WHERE
     tech.Keyword in(SELECT DISTINCT KEYWORD FROM Technographics T 
	 INNER JOIN TargetPersonaorganization TPO ON TPO.OrganizationId = T.OrganizationId
	 AND TPO.TargetPersonaId = @targetpersonaid)
	  
order by SortOrder desc

END
