/****** Object:  Procedure [dbo].[Sp_Update_LinkedinData_Bing_Data]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sp_Update_LinkedinData_Bing_Data
AS
BEGIN

  SET NOCOUNT ON;
  CREATE TABLE #Temp1 (
    Id int,
    designation varchar(1000),
    NewOrganization varchar(1000)
  )
   CREATE TABLE #Temp2 (
    Id int,
    designation varchar(1000),
    NewOrganization varchar(1000)
  )

  INSERT INTO #Temp1 (ID,
  designation,
  NewOrganization)
    SELECT
      id,
      designation,
      CASE
        WHEN CHARINDEX('-', designation) > 0 THEN LTRIM(SUBSTRING(designation, CHARINDEX('-', designation) + 1, LEN(designation) - CHARINDEX('-', designation) + 1))
        ELSE NULL
      END AS new_organization
    FROM linkedindata
    WHERE source = 'bing'
    AND organization LIKE 'inlinkedincom'

  UPDATE linkedindata
  SET Organization = (SELECT
    NewOrganization
  FROM #Temp1
  WHERE #Temp1.ID = linkedindata.ID)
  WHERE ID IN (SELECT
    ID
  FROM #Temp1)
  

   INSERT INTO #Temp2 (ID,
  designation,
  NewOrganization)
    SELECT
      id,
      designation,
      CASE
        WHEN CHARINDEX('-', designation) > 0 THEN LTRIM(SUBSTRING(designation, CHARINDEX('-', designation) + 1, LEN(designation) - CHARINDEX('-', designation) + 1))
        ELSE NULL
      END AS new_organization
    FROM linkedindata
    WHERE source = 'bing'
    AND organization LIKE 'linkedin'

	UPDATE linkedindata
  SET Organization = (SELECT
    NewOrganization
  FROM #Temp2
  WHERE #Temp2.ID = linkedindata.ID)
  WHERE ID IN (SELECT
    ID
  FROM #Temp2)
END
