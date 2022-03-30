/****** Object:  Procedure [dbo].[PopulateAccountSegment]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    <MK , MK>
-- Create date: <10/08/2019, SEPTEMBER>
-- Description:  <Passing MarketingList will result in List of organizations with the given MarketingList>
-- =============================================


CREATE PROCEDURE [dbo].[PopulateAccountSegment]

AS
BEGIN

  SET NOCOUNT ON;
  
  IF OBJECT_ID('tempdb..#MLtemp') IS NULL
  BEGIN
  print'ERROR: 1.Create #MLtemp table 2.Populate the table with MarketingLists'
  return -1
  END

  DECLARE @COUNT int
  SET @COUNT = (SELECT
    COUNT(MARKETINGLIST)
  FROM #MLtemp)
  IF @COUNT = 0
  BEGIN
    PRINT 'Error: #MLtemp is empty, insert MarketingLists'
    RETURN -1
  END


  --Deleting recrods belonging to today
  DELETE FROM AccountSegment
  WHERE AccountSegment.MarketingList = (SELECT
      *
    FROM #MLtemp)
    AND InsertedDate = CONVERT(date, GETDATE())

  INSERT INTO AccountSegment (OrganizationID, OrganizationName, MarketingList, SubMarketingList, ProfileCount, InsertedDate)
    SELECT
      O.ID,
      O.NAME,
      MDM.MainMarketingListName,
      MDML.Name,
      COUNT(DISTINCT MDML.DECISIONMAKERLISTNAME),
      GETDATE()
    FROM Organization AS O,
         linkedindata AS LI,
         McDecisionmaker AS MDM,
         McDecisionmakerlist AS MDML,
         #MLTEMP AS ML,
         Tag AS T WITH (NOLOCK)
    WHERE MDM.MainMarketingListName = ML.MARKETINGLIST
    AND O.Name <> ''
    AND O.Name IS NOT NULL
    AND O.IsActive = 1
    AND MDML.IsActive = 1
    AND MDML.MODE = 'KEYWORD BASED LIST'
    AND MDML.DecisionMakerId = LI.id
    AND LI.organization = T.NAME COLLATE SQL_Latin1_General_CP1_CI_AS
    AND T.OrganizationId = O.Id
    AND MDML.NAME = MDM.Name
	AND MDML.decisionmakerid = LI.id
    GROUP BY O.ID,
             O.Name,
             MDM.MainMarketingListName,
             MDMl.Name

  PRINT 'Saved in AccountSegment Table!'

  
END
