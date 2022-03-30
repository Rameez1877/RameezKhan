/****** Object:  Procedure [dbo].[sp_pop_organization_attribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_pop_organization_attribute]

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- code needs updation

	DELETE FROM MISCMarketingList
	-- Populate MISCMarketingList
	CREATE TABLE #TempLinkedinDesignations
		( id int,
		Title VARCHAR(200),
		Name VARCHAR(100)
		)

	INSERT INTO #TempLinkedinDesignations(id, Title, Name)
		SELECT distinct li.id,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') Title
		,li.name
		FROM LinkedInData li
		WHERE EXISTS (SELECT
			*
		  FROM McDecisionmaker Md
		  WHERE isactive = 1
		  AND IsOFList = 2
		  AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') + ' ') > 0)
		  and len(li.url) > 5 

	INSERT INTO MISCMarketingList (
		DecisionMakerId,
		DecisionMakerlistName,
		Name)
		  SELECT distinct
			#TempLinkedinDesignations.id DecisionMakerId,
			#TempLinkedinDesignations.Name DecisionMakerlistName,
			t1.Name MarketingListName
		  FROM McDecisionMaker t1, #TempLinkedinDesignations 
		  WHERE t1.IsOFList = 2
		  and ISactive=1
		  AND CHARINDEX(' ' + t1.keyword + ' ', ' ' + #TempLinkedinDesignations.Title + ' ') > 0
		  AND t1.Name <> 'Others'

	-- DROP TemporaryTable created
	DROP TABLE #TempLinkedinDesignations

	-- DELETE existing records in the table for AttributeID = 25
	DELETE FROM organizationattribute WHERE AttributeID = 25

	-- Populate existing records in the table for AttributeID = 25
	INSERT INTO organizationattribute (OrganizationId, AttributeID, AttributeValue)
		SELECT DISTINCT org.Id, 25, 'Yes'
		FROM LinkedInData l, tag t, McDecisionmakerlist mcl, Organization org
		where
		l.id = mcl.DecisionMakerId
		and l.tagid = t.id
		and t.OrganizationId = org.Id
		and mcl.Name = 'Of Digital Transformation List'
		and mcl.Mode = 'Keyword Based List'

	-- DELETE existing records in the table for AttributeID = 22
	DELETE FROM organizationattribute WHERE AttributeID = 22

	-- Populate existing records in the table for AttributeID = 22
	INSERT INTO organizationattribute (OrganizationId, AttributeID, AttributeValue)
		SELECT DISTINCT org.Id, 22, 'Yes'
		FROM LinkedInData l, tag t, MISCMarketingList misc, Organization org
		where
		l.id = misc.DecisionMakerId
		and l.tagid = t.id
		and t.OrganizationId = org.Id
		and misc.Name = 'Centre Of Excellence'



END
