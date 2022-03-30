/****** Object:  Procedure [dbo].[PopulateIndeedJobPostLast6MonthsData]    Committed by VersionSQL https://www.versionsql.com ******/

-----------------------------------------------------------------
-- Author Name : Neeraj
-- Date : 20/07/2020
-- Description : To populate last 6 months data from Indeed
-----------------------------------------------------------------
CREATE Procedure [dbo].[PopulateIndeedJobPostLast6MonthsData]
AS
BEGIN
	declare @FromDate datetime = getdate() - 180
	declare @Id int 
	-- Table will contain last six months labeled data

	Delete from IndeedJobPostLast6Months where JobDate < @FromDate

	select @Id = max(Id) from IndeedJobPostLast6Months

	Insert into IndeedJobPostLast6Months
	(Id,TagTypeId,Keyword,JobTitle,CompanyName,[Location],Summary,JobPosted,InsertedDate,CountryCode,TagId,
	[Url],jobdate,jobDatedays,InsertedDate1,jobdays,DecisionMaker,Source,TagIdOrganization,SeniorityLevel,
	IsTechnoGraphicsProcessed,SourceID,IsLabelled,EmploymentType,Website)

	select Distinct
	i.Id,i.TagTypeId,i.Keyword,i.JobTitle,i.CompanyName,i.Location,i.Summary,i.JobPosted,i.InsertedDate,
	i.CountryCode,i.TagId,i.Url,i.jobdate,i.jobDatedays,i.InsertedDate1,i.jobdays,i.DecisionMaker,i.Source,
	i.TagIdOrganization,i.SeniorityLevel,i.IsTechnoGraphicsProcessed,i.SourceID,i.IsLabelled,i.EmploymentType,
	i.Website
	from IndeedJobPost i with (NOLOCK) Inner Join Jobpostexcellencearea j with (NOLOCK)
	on (i.id = j.jobpostid)
	where i.Id > @Id
	and i.jobdate is not null


	Update i set OrganizationId = t.organizationid
	from IndeedJobPostLast6Months i Inner Join Tag t on (i.TagIdOrganization = t.Id)
	where i.Id > @Id and i.TagIdOrganization <> 0

END
