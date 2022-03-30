/****** Object:  Procedure [dbo].[sp_pop_lidata_DomainName_Emailid]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    <Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_pop_lidata_DomainName_Emailid
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  CREATE TABLE #LidataUpdateDomain (
    id int,
    DomainName varchar(500)
  )
  CREATE TABLE #TempDomainEmail (
    DomainName varchar(500),
    PatternID int
  )
 --
 -- Update Domain Name Start
 --
  INSERT INTO #LidataUpdateDomain
    SELECT
      li.id,
      od.DomainName
    FROM linkedindata li,
         tag t,
         organizationdomain od
    WHERE li.tagid = t.id
    AND t.organizationid = od.organizationid

  UPDATE linkedindata
  SET DomainName = (SELECT
    DomainName
  FROM #LidataUpdateDomain li1
  WHERE li1.id = linkedindata.id)
  WHERE id IN (SELECT
    id
  FROM #LidataUpdateDomain)

 --
 --Update Domain Name End
 --

 --
 -- Update EmailID Start
 --
  INSERT INTO #TempDomainEmail
    SELECT
      DomainName,
      MAX(PatternID)
    FROM Emailtable
    WHERE IsVAlid = 1
    GROUP BY DomainName
	UPDATE LinkedInData
SET emailid = (SELECT
  CASE
    WHEN t.PatternId = 1 THEN CONCAT(LinkedInData.FirstName, LinkedInData.LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 2 THEN CONCAT(SUBSTRING(FirstName, 1, 1), LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 3 THEN CONCAT(FirstName, '@', LinkedInData.DomainName)
    WHEN PatternId = 4 THEN CONCAT(FirstName, SUBSTRING(LastName, 1, 1), '@', LinkedInData.DomainName)
    WHEN PatternId = 5 THEN CONCAT(FirstName, '.', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 6 THEN CONCAT(FirstName, '+', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 7 THEN CONCAT(FirstName, '-', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 8 THEN CONCAT(FirstName, '_', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 9 THEN CONCAT(FirstName, '.', SUBSTRING(LastName, 1, 1), '@', LinkedInData.DomainName)
    WHEN PatternId = 10 THEN CONCAT(FirstName, '-', SUBSTRING(LastName, 1, 1), '@', LinkedInData.DomainName)
    WHEN PatternId = 11 THEN CONCAT(FirstName, '_', SUBSTRING(LastName, 1, 1), '@', LinkedInData.DomainName)
    WHEN PatternId = 12 THEN CONCAT(SUBSTRING(FirstName, 1, 1), '.', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 13 THEN CONCAT(SUBSTRING(FirstName, 1, 1), '-', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 14 THEN CONCAT(SUBSTRING(FirstName, 1, 1), '_', LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 15 THEN CONCAT(LastName, '.', FirstName, '@', LinkedInData.DomainName)
    WHEN PatternId = 16 THEN CONCAT(SUBSTRING(LastName, 1, 1), FirstName, '@', LinkedInData.DomainName)
    WHEN PatternId = 17 THEN CONCAT(LastName, '@', LinkedInData.DomainName)
    WHEN PatternId = 18 THEN CONCAT(LastName, SUBSTRING(FirstName, 1, 1), '@', LinkedInData.DomainName)
    WHEN PatternId = 19 THEN CONCAT(SUBSTRING(FirstName, 1, 1), '-', SUBSTRING(LastName, 1, 1), '@', LinkedInData.DomainName)
  END
FROM #TempDomainEmail t
WHERE LinkedInData.DomainName = t.DomainName)
WHERE LinkedInData.DomainName IN (SELECT
  domainname
FROM #TempDomainEmail)
AND LEN(LinkedInData.emailid) < 5

DROP TABLE #TempDomainEmail
DROP TABLE #LidataUpdateDomain

END
