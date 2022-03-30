/****** Object:  Procedure [dbo].[GetContactListsToBeProcessedByContactListId]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetContactListsToBeProcessedByContactListId]
@MarketingListId int
AS
BEGIN

Create Table #TempContactList
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

  Insert Into #TempContactList(OrganizationId,Organization,WebsiteUrl,LinkedInId,FirstName,LastName,Designation,
              LinkedInUrl,Country,EmailId,PhoneNumber)
  select DISTINCT o.Id as OrganizationId,O.Name as Organization,O.WebsiteUrl,L.Id,L.FirstName,L.LastName,L.Designation,
         L.Url,L.ResultantCountry,L.EmailId,L.PhoneNumber
  from LinkedInData l 
       Inner Join 
	   Organization o on (l.OrganizationId = o.Id) 
	   Inner Join
       DecisionMakersForMarketingList d on (d.DecisionMakerId = l.id )
	   where d.marketinglistid = @MarketingListId

  Select * from #TempContactList

END
