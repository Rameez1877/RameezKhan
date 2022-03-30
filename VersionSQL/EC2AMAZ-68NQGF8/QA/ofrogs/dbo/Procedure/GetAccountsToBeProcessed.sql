/****** Object:  Procedure [dbo].[GetAccountsToBeProcessed]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[GetAccountsToBeProcessed]
@UserId int
AS
BEGIN
	

	select T.id as Id, T.Name as TargetListName,GetDate() as UploadedDate,'Deepak Krishnan' as UploadedBy,
			Count(Distinct(tp.OrganizationId)) as NumberOfAccounts
	from TargetPersona t Inner Join TargetPersonaOrganization tp on (t.Id = tp.TargetPersonaId)
	where t.CreatedBy = @UserId
	Group By T.Id,T.Name,Convert(Date,T.CreateDate)
	Order By 2 Desc

END
