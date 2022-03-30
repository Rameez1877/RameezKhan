/****** Object:  Procedure [dbo].[GetSimilarOrganizations]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- [GetSimilarOrganizations] 1
CREATE PROCEDURE [dbo].[GetSimilarOrganizations] 
	@OrganizationId int  
AS
BEGIN
	--declare @IndustryId int
	--select @IndustryId = IndustryId from dbo.Organization where Id = @OrganizationId
	--declare @AreaServed varchar(1000)
	--select @AreaServed = AreaServed from dbo.OrganizationWikiData where OrganizationId = @OrganizationId

	--select distinct top(5) 
	--	O.Id, O.[Name], M.Id as MagazineId, 
	--	iif(P.ProductId is null, 0, 1) as ProductMatched,
	--	iif(O.IndustryId is null, 0, 1) as IndustryMatched,
	--	iif(AreaServed = @AreaServed, 1, 0) as AreaMatched,
	--	iif(P.ProductId is null, 0, 1) + iif(O.IndustryId is null, 0, 1) + iif(AreaServed = @AreaServed, 1, 0) as Score
	--from dbo.Organization O
	--	inner join dbo.OrganizationWikiData OWD ON OWD.OrganizationId = @OrganizationId
	--	LEFT join Product P on (O.Id = P.OrganizationId)
	--	LEFT join Product OP on (OP.OrganizationId = @OrganizationId and P.[Name] like '%' + OP.[Name] + '%')
	--	left join Magazine M on (O.Id = M.OrganizationId)
	--where 
	--	O.IndustryId = @IndustryId
	--	and O.IsActive = 1
	--order by Score desc
	SELECT null
END
