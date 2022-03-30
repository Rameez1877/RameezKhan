/****** Object:  Procedure [dbo].[QA_GetMenu]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Asef Daqiq
-- Create date: 28th Jan, 2022
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[QA_GetMenu] @UserId INT
AS
/*
[dbo].[QA_GetMenu] 4517
*/
BEGIN
    DECLARE -- @RoleId int = 0,
    @CustomerType VARCHAR(20);
    SELECT
        -- @RoleId = AppRoleId,
        @CustomerType = CustomerType
    FROM dbo.AppUser
    WHERE Id = @UserId;

    IF @CustomerType IS NULL
    BEGIN
        SET @CustomerType = 'marketing';
    END;
    -- if(@RoleId = 0)
    -- set @RoleId = 3
    SELECT Title,
           [Description],
           Icon,
           [Path] = CASE
                        WHEN @CustomerType = 'marketing' THEN
                            [Path]
                        WHEN @CustomerType = 'gcc' THEN
                            [Path] + '/gics'
                        WHEN @CustomerType = 'app' THEN
                            '/mobile-apps'
                        ELSE
                            [Path]
                    END,
           Section,
           SortOrder
    FROM dbo.Menus
    WHERE Id = 3
    UNION ALL
    SELECT Title,
           [Description],
           Icon,
           [Path],
           Section,
           SortOrder
    FROM dbo.Menus
    WHERE --Id IN (1, 6, 35, 34, 33, 32, 29)
        EXISTS
    (
        SELECT MenuId FROM dbo.AppRoleMenus WHERE CustomerType = @CustomerType
    )
        AND IsActive = 1;
    -- ORDER BY SortOrder

    SELECT a.Name,
           a.Path,
           a.Type
    FROM
    (
        SELECT TOP (3)
               [Name],
               [Path] = CASE
                            WHEN Type = 'Non App' THEN
                                '/target-customer/detail/' + CAST(Id AS VARCHAR(50))
                            WHEN Type = 'App' THEN
                                '/target-customer/app-accounts-detail/' + CAST(Id AS VARCHAR(50))
                            ELSE
                                '/target-customer/partner-accounts-detail/' + CAST(Id AS VARCHAR(50))
                        END,
               'Accounts' AS [Type]
        FROM dbo.TargetPersona
        WHERE EXISTS
        (
            SELECT TOP (1)
                   1
            FROM dbo.TargetPersonaOrganization
            WHERE TargetPersonaId = Id
        )
              AND CreatedBy = @UserId
        ORDER BY Id DESC
    ) a
    UNION ALL
    SELECT c.Name,
           c.Path,
           c.Type
    FROM
    (
        SELECT TOP (3)
               m.MarketingListName AS [Name],
               '/budgetcontrol/decisionMakersForMarketingList/' + CAST(m.Id AS VARCHAR(50)) AS [Path],
               'Contacts' AS [Type]
        FROM dbo.MarketingLists m
            INNER JOIN dbo.TargetPersona t
                ON (m.TargetPersonaId = t.Id)
        WHERE EXISTS
        (
            SELECT TOP (1)
                   1
            FROM dbo.DecisionMakersForMarketingList
            WHERE MarketingListId = m.Id
        )
              AND m.CreatedBy = @UserId
        ORDER BY m.Id DESC
    ) c;
END;
