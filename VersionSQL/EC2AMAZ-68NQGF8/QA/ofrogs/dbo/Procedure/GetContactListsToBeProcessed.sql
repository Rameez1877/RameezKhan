/****** Object:  Procedure [dbo].[GetContactListsToBeProcessed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetContactListsToBeProcessed]
@UserId int
AS
BEGIN

Select m.id as Id,m.MarketingListName as ContactListName,GetDate() as UploadedDate,'Deepak Krishnan' as UploadedBy,
	   Count(Distinct(d.DecisionmakerId)) as NumberOfProfiles
from MarketingLists m Inner Join DecisionMakersForMarketingList D on (m.id = d.marketinglistid)
where m.CreatedBy = @UserId
Group By m.Id,m.MarketingListName,Convert(Date,m.CreateDate)
Order by 2 Desc

END
