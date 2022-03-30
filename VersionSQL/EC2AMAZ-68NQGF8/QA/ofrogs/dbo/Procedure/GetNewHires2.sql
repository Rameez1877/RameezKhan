/****** Object:  Procedure [dbo].[GetNewHires2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <23rd-Oct-2020>
-- Description:	<Display last 6 moths new hire  data>
-- =============================================
-- EXEC [GetNewHires2] 30054
CREATE PROCEDURE [dbo].[GetNewHires2] 
@TargetPersonaId int 
AS
BEGIN
	SET NOCOUNT ON;
	SELECT distinct top 500
			l.Id,
			l.Name,
			l.FirstName,
			l.LastName,
			l.OrganizationId,
			o.name as Organization,
			trim(l.Designation) as Designation,
			l.DateOfJoining,
			l.Url,
			l.ResultantCountry as Country,
			o.WebsiteUrl,
			SUBSTRING (O.WebsiteUrl, CHARINDEX( '.', O.WebsiteUrl) + 1,
			LEN(O.WebsiteUrl)) AS [Domain],
			sc.EmailId,
			sc.Phone,
			l.WorkAniversaryMonth as WorkAniversary
			--'Dear ' + l.FirstName + ',' + CHAR(13)+ CHAR(10)  + 'I see that you’ve been promoted to' + RTRIM(Designation) + ', and I’d like to congratulate you.' as Template
	FROM	LinkedInDataNewHire l with (nolock)
			Inner Join McDecisionMakerListNewHire m with (nolock)
			ON (l.Id = m.DecisionMakerId)
			Inner Join Organization o with (nolock)
			ON (o.Id = l.OrganizationId)
			inner join TargetPersonaOrganization tpo with (nolock) on (tpo.OrganizationId = o.id and tpo.TargetPersonaId = @TargetPersonaId)
			Left outer join SurgeContactDetail sc with (nolock) on (l.UniqueId = sc.UniqueId)
			--Inner Join Country c
			--ON (c.Name = l.ResultantCountry),
	WHERE	
	--m.Name In 
	--		(
	--			SELECT Functionality 
	--			FROM UserTargetFunctionality where UserID = @UserId
	--		)
	--		AND c.Id IN
	--			(
	--				SELECT	CountryId 
	--				FROM	UserTargetCountry
	--				WHERE	UserID = @UserId
	--			)
			 --o.IndustryId NOT IN (105,106,85) AND 
			DateOfJoining2 > getdate() - 365
			
END


			
