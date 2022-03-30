/****** Object:  Procedure [dbo].[PopulateNewHires]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Neeraj>
-- Create date: <4th,Nov,2020>
-- Description:	<Populate last 6 moths new hire  data>
-- =============================================
CREATE PROCEDURE [dbo].[PopulateNewHires]
@UserId int,
@Count int
AS
BEGIN

	SET NOCOUNT ON;
	INSERT INTO WeeklyReportNewHires
	(
				Name,
				Organization,
				Designation,
				DateOfJoining,
				Url,
				Template,
				UserId,
				SentDate
	)
	SELECT	Distinct TOP (@Count)
			l.Name,
			Organization,
			trim(Designation) as Designation,
			DateOfJoining,
			Url,
			'Dear ' + l.FirstName + ',' + CHAR(13)+ CHAR(10)  + 'I see that you’ve been promoted to' + RTRIM(Designation) + ', and I’d like to congratulate you.' as Template,
			@UserId as UserId,
			GetDate() as SentDate
	FROM	LinkedInDataNewHire l
			Inner Join McDecisionMakerListNewHire m 
			ON (l.Id = m.DecisionMakerId)
			Inner Join Organization o
			ON (o.Id = l.OrganizationId)
			Inner Join Country c
			ON (c.Name = l.ResultantCountry)
	WHERE	m.Name In 
			(
				SELECT Functionality 
				FROM UserTargetFunctionality where UserID = @UserId
			)
			AND c.Id IN
				(
					SELECT	CountryId 
					FROM	UserTargetCountry
					WHERE	UserID = @UserId
				)
			AND o.IndustryId NOT IN (105,106,85)
			AND convert(date,l.DateOfJoining) > getdate() - 180
END
