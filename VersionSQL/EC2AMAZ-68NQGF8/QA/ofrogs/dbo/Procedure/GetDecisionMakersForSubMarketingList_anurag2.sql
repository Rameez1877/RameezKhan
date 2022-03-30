/****** Object:  Procedure [dbo].[GetDecisionMakersForSubMarketingList_anurag2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: 30/Oct/2019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetDecisionMakersForSubMarketingList_anurag2]
-- Add the parameters for the stored procedure here
@OrganizationId int,
@Location varchar(8000),
@SubMarketingList varchar(8000)
AS
/*
[dbo].[GetDecisionMakersForSubMarketingList_anurag2] 85459,13,'Accounting'
*/

BEGIN
  SET NOCOUNT ON;

  SELECT
    li.FirstName,
    li.LastName,
    li.designation,
	df.Functionality as SubMarketingList,
    li.CountryName AS country,
    li.url
 FROM cache.DecisionMakers li
  INNER JOIN cache.DecisionMakerFunctionality df
    ON (li.id = df.DecisionmakerId)
  INNER JOIN dbo.Tag T
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)

  WHERE li.id = @OrganizationId
  AND df.Functionality = @SubMarketingList
  AND li.CountryName = @Location
  and li.SeniorityLevel in ('C-Level','Director')
 
END
