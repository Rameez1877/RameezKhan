/****** Object:  Procedure [dbo].[GetAccountsToBeProcessedByTargetPersonaId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetAccountsToBeProcessedByTargetPersonaId]
@TargetPersonaId int
AS
BEGIN

Create Table #TempAccounts
(
	UserId int,
	OrganizationId int,
	Organization  varchar(100),
	WebsiteUrl varchar(100),
	LinkedInId int,
	FirstName varchar(100),
	LastName varchar(100),
	Designation varchar(200),
	LinkedInUrl varchar(200),
	Country varchar(100),
	EmailId varchar(100),
	PhoneNumber int,
	VerificationStatus varchar(50),
	ConfidenceScore int

)

  Insert Into #TempAccounts(OrganizationId,Organization,WebsiteUrl)
  select DISTINCT O.Id as OrganizationId,O.Name as Organization,O.WebsiteUrl 
  from Organization o Inner Join TargetPersonaOrganization t on (o.Id = t.organizationid)
  Where t.targetpersonaid = @TargetPersonaId

  Select * from #TempAccounts

END
