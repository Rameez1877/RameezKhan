/****** Object:  Procedure [dbo].[GetMenu]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Asef Daqiq
-- Create date: 28th Jan, 2022
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetMenu] @UserId int
AS
/*
[dbo].[GetMenu] 4517
*/
BEGIN
  DECLARE @RoleId int = 0,
		  @CustomerType varchar(20)
  SELECT
    @RoleId = AppRoleId, @CustomerType = CustomerType
  FROM AppUser
  WHERE Id = @UserId
  
  if @CustomerType is null
  begin
	Set @CustomerType = 'marketing'
  end
  -- if(@RoleId = 0)
  -- set @RoleId = 3
   SELECT
    Title,
    [Description],
    Icon,
    [Path] = Case 
				When @CustomerType = 'marketing' then [Path]
				When @CustomerType = 'gcc' then [Path] + '/gics'
				When @CustomerType = 'app' then '/mobile-apps'
				else [Path]
			 end,
    Section,
	SortOrder
  FROM Menus 
  where id = 3

  UNION ALL

  SELECT
    Title,
    [Description],
    Icon,
    [Path],
    Section,
	SortOrder
  FROM Menus
  WHERE  --Id IN (1, 6, 35, 34, 33, 32, 29)
    Id in (select MenuId from AppRoleMenus where CustomerType = @CustomerType)
  AND IsActive = 1
 -- ORDER BY SortOrder

  SELECT
    a.[Name],
    a.[Path],
    a.[Type]
  FROM (SELECT TOP 3
    [Name],
    [Path] =
            CASE
              WHEN type = 'Non App' THEN '/target-customer/detail/' + CAST(Id AS varchar)
              WHEN type = 'App' THEN '/target-customer/app-accounts-detail/' + CAST(Id AS varchar)
              ELSE '/target-customer/partner-accounts-detail/' + CAST(Id AS varchar)
            END,
    'Accounts' AS [Type]
  FROM TargetPersona 
  WHERE exists(select top 1 1 from TargetPersonaOrganization where TargetPersonaId = Id)
  AND CreatedBy = @UserId
  ORDER BY id DESC
  ) a

  UNION ALL

  SELECT
    c.[Name],
    c.[Path],
    c.[Type]
  FROM (SELECT TOP 3
    m.MarketingListName AS [Name],
    '/budgetcontrol/decisionMakersForMarketingList/' + CAST(m.Id AS varchar) AS [Path],
    'Contacts' AS [Type]
  FROM MarketingLists m
  INNER JOIN TargetPersona t
    ON (m.TargetPersonaId = t.Id)
  	 WHERE exists(select top 1 1 from DecisionMakersForMarketingList where MarketingListId = m.Id)
  AND m.CreatedBy = @UserId
  ORDER BY m.id DESC) c
END
