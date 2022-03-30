/****** Object:  Procedure [dbo].[QA_GetAnniversaryAndNewHireSearchResult]    Committed by VersionSQL https://www.versionsql.com ******/

-- JAN-2022 - KABIR 
-- EXEC [QA_GetAnniversaryAndNewHireSearchResult] 159
CREATE PROCEDURE [dbo].[QA_GetAnniversaryAndNewHireSearchResult]  
 @UserID int
AS
BEGIN

DECLARE @All BIT, @Count INT ,@F VARCHAR(200)

SELECT @Count = COUNT(*) 
	FROM ContactSearchFunctionalityResult 
	WHERE UserID = @USERID
	
	IF @Count = 1
	SELECT @F = Functionality
	FROM ContactSearchFunctionalityResult 
	WHERE UserID = @USERID

	SET @All = IIF(@F = '1',1,0)

	IF @ALL = 0
	BEGIN

	;WITH CTE AS(
			SELECT
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.OrganizationID as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - Next Month' AS 'Touch Point',
			 'No' AS 'NewHire'
		
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			INNER JOIN CompanySearchResult C ON
			C.ID = L.ID
			INNER JOIN ContactSearchFunctionalityResult cs on
			cs.Functionality = MC.name
			WHERE 
			L.OrganizationID is not null
			AND C.USERID = @USERID and
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			
		
			 UNION

			 SELECT 
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.organizationid as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - This Month' AS [Touch Point],
			 'No' AS 'NewHire'
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			INNER JOIN CompanySearchResult C ON
			C.ID = L.ID
			INNER JOIN ContactSearchFunctionalityResult cs on
			cs.Functionality = MC.name
	WHERE 
			L.OrganizationID is not null
			AND C.USERID = @USERID and
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			UNION

		 	 SELECT
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.organization  AS Organization,
			 l.organizationid as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - Last Month' AS [Touch Point],
			 'No' AS 'NewHire'
		
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			INNER JOIN CompanySearchResult C ON
			C.ID = L.ID
			INNER JOIN ContactSearchFunctionalityResult cs on
			cs.Functionality = MC.name
			WHERE 
			L.OrganizationID is not null
			AND C.USERID = @USERID and
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			UNION

			SELECT --DISTINCT TOP (@Limit)
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 l.organization  AS Organization,
			 l.organizationid as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'New Hire' AS [Touch Point],
			 'Yes' AS 'NewHire'
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			INNER JOIN CompanySearchResult C ON
			C.ID = L.ID
			INNER JOIN ContactSearchFunctionalityResult cs on
			cs.Functionality = MC.name
	WHERE 
			L.OrganizationID is not null
			AND C.USERID = @USERID and
			 convert(date,l.DateOfJoining) > getdate() - 90
			 )
			 SELECT  DISTINCT 
			 Id
			 ,Name,
			 	 FirstName,
			 LastName,
			 Organization,
			   OrganizationId,
			 trim(Designation) as Designation,
			 convert(varchar, DateOfJoining, 107) DateOfJoining,
			 Url,
			 Country ,
			 EmailId,
			 WebsiteUrl,
			SUBSTRING (WebsiteUrl, CHARINDEX( '.', WebsiteUrl) + 1,
			LEN(WebsiteUrl)) AS [Domain],
			  [Touch Point],
			 NewHire
			 
			 FROM CTE
			 ORDER BY [Touch Point] DESC
			END


			ELSE IF @ALL = 1
			BEGIN 

			;WITH CTE AS(
			SELECT
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.OrganizationID as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - Next Month' AS 'Touch Point',
			 'No' AS 'NewHire'
		
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
		
		WHERE 
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) + 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			 UNION

			 SELECT --DISTINCT TOP (@Limit)
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.OrganizationID as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - This Month' AS [Touch Point],
			 'No' AS 'NewHire'
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
			WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) 
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			UNION

		 	 SELECT --DISTINCT TOP (@Limit)
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.OrganizationID as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'Work Anniversary - Last Month' AS [Touch Point],
			 'No' AS 'NewHire'
		
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
	WHERE	
			MONTH(convert(date,l.DateOfJoining)) = MONTH(GETDATE()) - 1
			AND YEAR(convert(date,l.DateOfJoining)) <> YEAR(GETDATE()) 
			UNION

			SELECT --DISTINCT TOP (@Limit)
			 l.Id
			 ,l.Name,
			 l.FirstName,
			 l.LastName,
			 L.Organization  AS Organization,
			 L.OrganizationID as OrganizationId,
			 l.Designation as Designation,
			 l.DateOfJoining,	l.Url,
			 l.ResultantCountry as Country ,
			 l.EmailId,
			 L.WebsiteUrl,
			 'New Hire' AS [Touch Point],
			 'Yes' AS 'NewHire'
			
	FROM	NewHireTouchPoint L
			Inner Join McDecisionMakerListNewHire MC  With (Nolock)
			ON (l.Id = MC.DecisionMakerId)
	WHERE	
			 convert(date,l.DateOfJoining) > getdate() - 90
			 )
			 SELECT  DISTINCT 
			 Id
			 ,Name,
			 	 FirstName,
			 LastName,
			 Organization,
			   OrganizationId,
			 trim(Designation) as Designation,
			 convert(varchar, DateOfJoining, 107) DateOfJoining,
			 Url,
			 Country ,
			 EmailId,
			 WebsiteUrl,
			SUBSTRING (WebsiteUrl, CHARINDEX( '.', WebsiteUrl) + 1,
			LEN(WebsiteUrl)) AS [Domain],
			  [Touch Point],
			 NewHire
			 
			 FROM CTE
			 ORDER BY [Touch Point] DESC


			END 

			END
