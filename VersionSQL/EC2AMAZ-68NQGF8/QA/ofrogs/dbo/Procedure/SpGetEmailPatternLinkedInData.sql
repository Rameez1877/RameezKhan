/****** Object:  Procedure [dbo].[SpGetEmailPatternLinkedInData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SpGetEmailPatternLinkedInData]
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;
  CREATE TABLE #TempOrgPattern
  (OrganizationID INT,
  PatternID INT)

  DECLARE @DomainName nvarchar(500),
          @FirstName nvarchar(500),
          @LastName nvarchar(500),
          @EmailID nvarchar(500),
          @OrganizationID int,
          @PatternId int

  DECLARE db_cursor_pattern CURSOR LOCAL FOR

  SELECT 
    t.OrganizationID,
    SUBSTRING(emailid, CHARINDEX('@', emailid) + 1, LEN(emailid) - CHARINDEX('@', emailid) + 1) DomainName,
    FirstName,
    LastName,
    li.EmailID
  FROM linkedindata li,
       tag t
  WHERE li.tagid <> 0
  AND LEN(li.emailid) > 1
  AND li.tagid = t.id
  AND t.OrganizationID is not null

  OPEN db_cursor_pattern
  FETCH NEXT FROM db_cursor_pattern INTO @OrganizationID, @DomainName, @FirstName, @LastName, @EmailID

  WHILE @@FETCH_STATUS = 0
  BEGIN

    EXEC SpGetEmailPattern @OrganizationID,
                           @DomainName,
                           @FirstName,
                           @LastName,
                           @EmailID,
                           @PatternId OUTPUT
    IF @PatternId IS NOT NULL
     INSERT INTO #TempOrgPattern
	  VALUES(@OrganizationID,@PatternId)
    FETCH NEXT FROM db_cursor_pattern INTO @OrganizationID, @DomainName, @FirstName, @LastName, @EmailID
  END

  CLOSE db_cursor_pattern
  DEALLOCATE db_cursor_pattern

  delete OrganizationEmailPattern
  INSERT INTO OrganizationEmailPattern
SELECT OrganizationID, PatternId
FROM #TempOrgPattern
GROUP BY OrganizationID, PatternId

END
