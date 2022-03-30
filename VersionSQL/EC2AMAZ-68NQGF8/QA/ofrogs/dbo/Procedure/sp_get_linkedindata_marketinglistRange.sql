/****** Object:  Procedure [dbo].[sp_get_linkedindata_marketinglistRange]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_get_linkedindata_marketinglistRange]
-- Add the parameters for the stored procedure here  
@linkedinIdFrom int, 
@linkedinIdTo int 

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;

  DELETE FROM McDecisionmakerlist 
  WHERE mode = 'Keyword Based List' and DecisionMakerId BETWEEN @linkedinIdFrom and @linkedinIdTo

  select distinct li.id,
   REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  title,
     li.name into #Temp1
   from LinkedInData li
   WHERE EXISTS (SELECT
    *
  FROM decisionmakerlist dm
  WHERE isactive = 1
  AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  + ' ') > 0)
 and len(url) > 5 
 and Id BETWEEN @linkedinIdFrom and @linkedinIdTo

    INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT distinct
        1 AppUserId,
        #Temp1.id DecisionMakerId,
        #Temp1.Name DecisionMakerlistName,
        1 IsActive,
        t1.Name MarketingListName,
        'Keyword Based List'
      FROM McDecisionMaker t1, #Temp1 
      WHERE t1.IsOFList = 1
	  and ISactive=1
      AND CHARINDEX(' ' + t1.keyword + ' ', ' ' + #Temp1.Title + ' ') > 0
      AND t1.Name <> 'Others'
	  and charindex('machine learning',#Temp1.Title) = 0
       and charindex('deep learning',#Temp1.Title) = 0
   
    INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT distinct
        1 AppUserId,
        #Temp1.id DecisionMakerId,
        #Temp1.Name DecisionMakerlistName,
        1 IsActive,
        'Others' MarketingListName,
        'Keyword Based List'
		from #Temp1
		where not exists
		(select * from McDecisionmakerlist MC
		where mc.DecisionMakerId =#Temp1.id
		and mc.mode = 'Keyword Based List')  
		and Id BETWEEN @linkedinIdFrom and @linkedinIdTo


END
