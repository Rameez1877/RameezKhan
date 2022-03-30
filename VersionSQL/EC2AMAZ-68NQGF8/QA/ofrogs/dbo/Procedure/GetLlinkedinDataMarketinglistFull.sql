/****** Object:  Procedure [dbo].[GetLlinkedinDataMarketinglistFull]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================  
-- Author:      <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sp_get_linkedindata_marketinglistfull]
-- Add the parameters for the stored procedure here  
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from  
  -- interfering with SELECT statements.  
  SET NOCOUNT ON;

  DELETE FROM McDecisionmakerlist
  WHERE mode = 'Keyword Based List'

 -- select distinct li.id,
 --  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  title,
 --    li.name into #Temp1
 --  from LinkedInData li
 --  WHERE EXISTS (SELECT
 --   *
 -- FROM decisionmakerlist dm
 -- WHERE isactive = 1
 -- AND CHARINDEX(' ' + keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ')  + ' ') > 0)
 --and len(url) > 5 

    INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT distinct
        1 AppUserId,
        li.id DecisionMakerId,
        li.Name DecisionMakerlistName,
        1 IsActive,
        t1.Name MarketingListName,
        'Keyword Based List'
      FROM McDecisionMaker t1, LinkedInData li
      WHERE t1.IsOFList = 1
	  and t1.ISactive=1
      AND CHARINDEX(' ' + t1.keyword + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(li.designation, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') + ' ') > 0
      AND t1.Name <> 'Others'
	  --and charindex('machine learning',#Temp1.Title) = 0
   --    and charindex('deep learning',#Temp1.Title) = 0
   
    INSERT INTO McDecisionmakerlist (AppUserId,
    DecisionMakerId,
    DecisionMakerlistName,
    IsActive,
    Name,
    Mode)
      SELECT distinct
        1 AppUserId,
        li.id DecisionMakerId,
        li.Name DecisionMakerlistName,
        1 IsActive,
        'Others' MarketingListName,
        'Keyword Based List'
		from LinkedinData li
		where not exists
		(select * from McDecisionmakerlist MC
		where mc.DecisionMakerId =li.id
		and mc.mode = 'Keyword Based List')  

		--update LinkedInData set decisionmaker ='DecisionMaker'
		--where senioritylevel in('C-Level','Director','Influencer' ,'Strength')

	 --	 update LinkedInData set decisionmaker ='Unknown' 
		-- WHERE senioritylevel not in ('C-Level','Director','Influencer','Strength' )

--exec Sp_Pop_JobPostExcellenceArea
--exec Sp_Pop_AwardExcellenceArea

END
