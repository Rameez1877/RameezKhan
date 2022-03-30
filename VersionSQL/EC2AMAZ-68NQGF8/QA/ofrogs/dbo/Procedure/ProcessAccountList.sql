/****** Object:  Procedure [dbo].[ProcessAccountList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <02nd Feb 2021>
-- Description:	<>
-- =============================================
CREATE PROCEDURE ProcessAccountList
@UserId int = 0,
@Task int = 0,
@KeywordOrganizationId varchar(MAX) = ''
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetPersonaId int
	DECLARE @DeleteRows int = 0
	DECLARE @InsertRows int = 0

	-- To check the latest targetpersonaid for the given user
	IF @Task = 1
		BEGIN
			SELECT	TOP 1 
					Id as TargetPersonaId,
					Name as TargetPersonaName,
					CreatedBy as UserId,
					CreateDate as CreatedDate
			FROM	TargetPersona
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc
		END
	
	-- To check account details for the given userid
	IF @Task = 2
		BEGIN
			SELECT	TOP 1 
					@TargetPersonaId = Id
			FROM	TargetPersona
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc

			SELECT	DISTINCT
					t.TargetPersonaId,
					o.Name as Organization,
					o.Id as OrganizationId,
					o.WebsiteUrl,
					i.Name as Industry,
					o.EmployeeCount,
					o.Revenue
			FROM	TargetPersonaOrganization t
					INNER JOIN Organization o ON (t.OrganizationId = o.Id)
					INNER JOIN Industry i ON (o.IndustryId = i.Id)
			WHERE	t.TargetPersonaId = @TargetPersonaId

		END

	-- Delete not required Organizations from the latest account List
	IF @Task = 3
		BEGIN
			SELECT	TOP 1 
					@TargetPersonaId = Id
			FROM	TargetPersona
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc
			IF @KeywordOrganizationId <> ''
				BEGIN
					DELETE	FROM 
							TargetPersonaOrganization
					WHERE	TargetPersonaId = @TargetPersonaId
							AND OrganizationId IN (SELECT value FROM STRING_SPLIT(@KeywordOrganizationId,','))
					SELECT @DeleteRows = @@RowCount
				END
			ELSE
				BEGIN
					DELETE	FROM 
							TargetPersonaOrganization
					WHERE	TargetPersonaId = @TargetPersonaId
					SELECT @DeleteRows = @@RowCount
				END

			DELETE	FROM 
					TargetPersonaIndustry
			WHERE	TargetPersonaId = @TargetPersonaId

		END
	
	-- Insert required Organizations in the account list
	IF @Task = 4
		BEGIN
			SELECT	TOP 1 
					@TargetPersonaId = Id
			FROM	TargetPersona
			WHERE	CreatedBy = @UserId
			ORDER BY Id Desc

			INSERT INTO	TargetPersonaOrganization(TargetPersonaId,OrganizationId,SortOrder,AccountStatus,LeadScore)
			SELECT	DISTINCT
					@TargetPersonaId,
					value as OrganizationId,
					0 as SortOrder,
					1 as AccountStatus,
					0 as LeadScore
			FROM STRING_SPLIT(@KeywordOrganizationId,',')
			SELECT @InsertRows = @@RowCount
		END
		
		IF @DeleteRows <> 0
			BEGIN
				PRINT 'Total Number of records deleted = ' + TRIM(STR(@DeleteRows))
			END
		IF @InsertRows <> 0
			BEGIN
				PRINT 'Total Number of records inserted = ' + TRIM(STR(@InsertRows))
			END
END
