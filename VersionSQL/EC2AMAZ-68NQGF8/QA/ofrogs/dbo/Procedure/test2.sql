/****** Object:  Procedure [dbo].[test2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:  	<Author,,Name>
-- Create date: 30/Oct/2019
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].test2
-- Add the parameters for the stored procedure here
@OrganizationId int,
@SubMarketingList varchar(200)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT
	li.name,
	li.organization,
    li.designation,
	li.emailid,
	li.gender,
	Mc.name as SubMarketingList,
    li.ResultantCountry AS country,
    li.url,
	s.noofdecisionmaker
 FROM LinkedInData  li with (nolock)
  INNER JOIN SurgeSummary s  with (nolock)
  on (s.organizationId = @organizationId)
  INNER JOIN McDecisionMakerList Mc  with (nolock)
    ON (Li.id = mc.DecisionmakerID)
  INNER JOIN dbo.Tag T  with (nolock)
    ON (T.Id = li.TagId
    AND T.TagTypeId = 1)
   WHERE T.OrganizationID = @OrganizationId
  AND mc.mode = 'Keyword Based List'
  AND mc.Name = @SubMarketingList
  And s.Functionality = @SubMarketingList
  and li.senioritylevel in ('C-Level','Director','Influencer')
 
END
