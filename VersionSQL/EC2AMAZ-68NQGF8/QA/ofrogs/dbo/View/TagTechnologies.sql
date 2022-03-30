/****** Object:  View [dbo].[TagTechnologies]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[TagTechnologies]
AS

	WITH CTE AS
	(
		select T.Name as TagName, ct.TechnologyName,I.IndustryID from CompanyTechnologies ct
		INNER JOIN dbo.Tag AS T ON ct.TagId = T.Id and T.TagTypeId = 1
		INNER JOIN industrytag AS I ON I.TagID=T.Id
		WHERE ct.TechnologyName NOT IN (SELECT StackTechnologyName FROM TechStackTechnology WHERE LEN(StackTechnologyName)=1)
	)

	SELECT * FROM (
	select TN2.TagName, TN2.IndustryID,COUNT(TN2.TechnologyName) AS NoOfTechnologies,
	STUFF((select distinct ',' + TN1.TechnologyName
	from CTE TN1
	where 
		TN2.TagName = TN1.TagName
		and TN2.IndustryID = TN1.IndustryID 
		FOR XML PATH('')),1,1,'') AS TechnologyName
		from CTE TN2
		group by TN2.TagName, TN2.IndustryID
		) AS S --WHERE NoOfSignalWords>1
