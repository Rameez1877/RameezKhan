/****** Object:  Procedure [dbo].[Sp_Create_News_Topic_List]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sp_Create_News_Topic_List]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  DELETE NewsTopicList

  SELECT DISTINCT
    rss.id RssFeedItemId,
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
    (title, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') title,
    RSST.TagId,
    t.organizationid INTO #Temp1
  FROM rssfeeditem RSS,
       rssfeeditemtag RSST,
       TAG t
  WHERE RSS.id = RSST.RssFeedItemId
  AND RSST.confidencescore >= 0.8
  AND RSST.tagid = t.id
  AND EXISTS (SELECT
    sw.name AS keyword
  FROM SignalWord sw
  WHERE CHARINDEX(' ' + sw.name COLLATE Latin1_General_CI_AI + ' ', ' ' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(title, ',', ' '), '.', ' '), ':', ' '), '-', ' '), '|', ' '), '(', ' '), ')', ' '), '&', 'and'), '/', ' '), '  ', ' ') + ' ') > 0)


  INSERT INTO NewsTopicList (OrganizationID,
  RssFeedItemId,
  TopicName)
    SELECT DISTINCT
      #Temp1.OrganizationID,
      RssFeedItemId,
      S.Name
    FROM SignalWord SW,
         Signal S,
         #Temp1
    WHERE sw.signalid = s.id
    AND CHARINDEX(' ' + sw.name COLLATE Latin1_General_CI_AI + ' ', ' ' + #Temp1.Title + ' ') > 0

	 INSERT INTO NewsTopicList (OrganizationID,
  RssFeedItemId,
  TopicName)
    SELECT DISTINCT
      #Temp1.OrganizationID,
      RssFeedItemId,
      S.AliasName
    FROM Mcdecisionmaker S, #Temp1
    WHERE S.IsOfList in (1,2)
    AND CHARINDEX(' ' + keyword COLLATE Latin1_General_CI_AI + ' ', ' ' + #Temp1.Title + ' ') > 0
	and s.name <> 'Others'


END
