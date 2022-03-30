/****** Object:  Procedure [dbo].[GetDecisionMakersForMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[GetDecisionMakersForMarketingList]
@UserID INT,
@MarketingListId INT,
@Page INT = 0,
@Size INT = 10,
@Functionality VARCHAR(500) = '',
@CountryName VARCHAR(200) = ''

AS

BEGIN
    DECLARE @AppRoleID int 
    SELECT
        @AppRoleID = A.AppRoleID
    FROM AppUser A with (nolock)
    WHERE A.Id = @UserId

	DECLARE @TargetPersonaId int
	DECLARE @TargetPersonaType varchar(10), @MarketingListName varchar(200)
	Select @TargetPersonaId = TargetPersonaId, @MarketingListName = MarketingListName from MarketingLists where id = @marketingListId
	Select @TargetPersonaType = [Type] from TargetPersona where id = @TargetPersonaId

		
				
				;WITH CTE AS (
				SELECT	DISTINCT 
				d.DecisionMakerId as Id,
				O.Name Organization,
				o.Id as OrganizationId,
				d.Country,d.Functionality,
				d.[Name] + ', ' + d.Designation as Username,
				d.LinkedInUrl [Url], 
				d.FirstName,
				d.LastName,
				d.Designation,
				IIF(@AppRoleID = 3 AND @Page > 1, '*', LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(d.EmailId, CHAR(10), CHAR(32)),CHAR(13), CHAR(32)),CHAR(160), CHAR(32)),CHAR(9),CHAR(32))))) as EmailId,
				IIF(h.Url IS NOT NULL,'Exported','Not Exported') as ExportStatus,
				@UserID AS UserID,
				o.WebsiteUrl,SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			     LEN(O.WebsiteUrl)) AS [Domain],
				 @MarketingListName as MarketingListName,
				 @MarketingListId as MarketingListId,
				 @TargetPersonaId as TargetPersonaId,
				 @TargetPersonaType as TargetPersonaType
		FROM	DecisionMakersForMarketingList d
				INNER JOIN Organization O ON O .Id = D.OrganizationId
				LEFT JOIN HubSpotSharedProfiles h ON (d.LinkedInUrl = h.Url AND h.UserId = @UserId)
			
		WHERE	d.MarketingListId = @MarketingListId)

			select * ,
				   @TargetPersonaId as TargetPersonaId,
				   @TargetPersonaType as TargetPersonaType
				   ,COUNT(*) OVER (PARTITION BY @UserID) as TotalRecords
			FROM	CTE
			WHERE (@Functionality = '' OR Functionality LIKE '%' + @Functionality + '%')
			
			AND (@CountryName = '' OR Country = @CountryName )
			
			
					order by EmailId
					OFFSET (@Page * @Size) ROWS
					FETCH NEXT @Size ROWS ONLY
	END
