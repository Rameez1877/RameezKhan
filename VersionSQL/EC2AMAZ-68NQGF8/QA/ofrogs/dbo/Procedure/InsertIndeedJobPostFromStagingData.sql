/****** Object:  Procedure [dbo].[InsertIndeedJobPostFromStagingData]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Janna
-- Create date: 12 Sep 2019
-- Description:	Pull IndeedJobPost from Staging Table
-- =============================================
CREATE PROCEDURE [dbo].[InsertIndeedJobPostFromStagingData]
AS
BEGIN
  DECLARE @StartID int,
          @EndId int,
          @StartTime datetime,
          @EndTime datetime,
          @Rows int
  DECLARE @CompanyName varchar(500),
          @CountryCode int

  SET @StartTime = GETDATE()
  SELECT
    @StartID = MIN(Id),
    @EndId = MAX(ID)
  FROM training.dbo.IndeedJobPosttemp WITH (NOLOCK)
  WHERE IsProcessed = 'N'

  INSERT INTO [dbo].[IndeedJobPost] (SourceID,
  [TagTypeId]
  , [Keyword]
  , [JobTitle]
  , [CompanyName]
  , [Location]
  , [Summary]
  , [JobPosted]
  , [InsertedDate]
  , [CountryCode]
  , [TagId]
  , [Url]
  , [jobdate]
  , [jobDatedays]
  , [InsertedDate1]
  , [jobdays]
  , [DecisionMaker]
  , [Source]
  , [TagIdOrganization]
  , [SeniorityLevel]
  , [IsTechnoGraphicsProcessed])
    SELECT
      ID,
      CASE
        WHEN [TagTypeId] IS NULL THEN 0
        ELSE [TagTypeId]
      END TagTypeId,
      [Keyword],
      [JobTitle],
      [CompanyName],
      [Location],
      [Summary],
      [JobPosted],
      case when [InsertedDate] is null then getdate() else Inserteddate end,
      [CountryCode],
      [TagId],
      [Url],
      [jobdate],
      [jobDatedays],
      [InsertedDate1],
      [jobdays],
      NULL [DecisionMaker],
      'IndeedJobPosttemp From Training DB' [Source],
      NULL [TagIdOrganization],
      NULL [SeniorityLevel],
      'N' [IsTechnoGraphicsProcessed]
    FROM training.dbo.IndeedJobPosttemp WITH (NOLOCK)
    WHERE IsProcessed = 'N'
    AND ID BETWEEN @StartID AND @EndId
  --
  -- Get Number of Rows Inserted For Logging
  --
  SELECT
    @Rows = @@ROWCOUNT

  UPDATE training.dbo.IndeedJobPosttemp
  SET IsProcessed = 'Y'
  WHERE IsProcessed = 'N'
  AND ID BETWEEN @StartID AND @EndId
  SET @EndTime = GETDATE()

  IF @Rows = 0
    INSERT INTO JobStatusLog--
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertIndeedJobPostFromStagingData',--
      @StartTime,--
      @EndTime,--
      'No Records To Process')
  IF @Rows > 0
    INSERT INTO JobStatusLog --
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertIndeedJobPostFromStagingData',--
      @StartTime,--
      @EndTime,--
      'Number of Rows Inserted in IndeedJobPost Table ' + STR(@Rows))
  --
  -- Populate Marketing List For Jobs, which are pending Labelling
  -- 
  DECLARE @NotLabelledJobIDStart int,
          @NotLabelledJobIDEnd int

  SELECT
    @NotLabelledJobIDStart = MIN(ID),
    @NotLabelledJobIDEnd = MAX(ID)
  FROM IndeedJobPost WITH (NOLOCK)
  WHERE IsLabelled = 0

  EXEC PopulateJobPostExcellenceAreaRange @NotLabelledJobIDStart,
                                          @NotLabelledJobIDEnd
  --
  -- Create organizations for newly inserted records
  --
  DECLARE db_cursor_Ind CURSOR FOR
  SELECT DISTINCT
    companyname,
    countrycode
  FROM indeedjobpost
  WHERE companyname
  NOT IN (SELECT
    name COLLATE Latin1_General_CI_AI
  FROM tag
  WHERE tagtypeid = 1)
  AND ID BETWEEN @NotLabelledJobIDStart AND @NotLabelledJobIDEnd
  OPEN db_cursor_Ind
  FETCH NEXT FROM db_cursor_Ind INTO @CompanyName, @CountryCode

  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC SaveOrganization NULL,
                          @CompanyName,
                          @CompanyName,
                          @CompanyName,
                          '',
                          '',
                          '',
                          46,
                          '',
                          '',
                          @CountryCode,
                          '',
                          NULL

    FETCH NEXT FROM db_cursor_Ind INTO @CompanyName, @CountryCode
  END

  CLOSE db_cursor_Ind
  DEALLOCATE db_cursor_Ind

  --
  -- Update TagIDorganziation Column For Newly inserted records
  --
  SELECT
  id AS Tagid,
  Name,
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(name,
  ' Company Ltd', ''),
  ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"', ''),
  ' Co, Ltd', ''),
  ', Ltd', ''),
  ' Ltd', ''),
  ' ', ''),
  '&', 'and'),
  '®', ''),
  ', Inc', ''),
  ' plc', ''),
  ', L.P.', ''),
  ', a GE company', ''),
  ',', ''),
  '''', ''),
  '/', '')
  AS newname INTO #tempTag
FROM tag WITH (NOLOCK)
WHERE tagtypeid = 1

SELECT
  Id AS JobPostID,
  companyname,
  REPLACE(REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(
  REPLACE(companyname,
  ' Company Ltd', ''),
  ' Company LLC', ''),
  ' Private Limited', ''),
  ' Private Ltd', ''),
  ', Incorporated', ''),
  ' Incorporated', ''),
  ' Corporation', ''),
  ' + Co LLP', ''),
  ' Co Ltd', ''),
  ' Pvt Ltd', ''),
  ' Pty Ltd', ''),
  ' (p) Ltd', ''),
  ', LLP', ''),
  ' LLP', ''),
  ', Inc.', ''),
  ' Inc.', ''),
  ' Corp.', ''),
  ', LLC', ''),
  ' Limited ', ''),
  ' Pvt. Ltd', ''),
  ' Ltd.', ''),
  ' Co.,ltd', ''),
  ' LLC', ''),
  ' Limited', ''),
  ' Co., Ltd', ''),
  ' Pte Ltd', ''),
  '"', ''),
  ' Co, Ltd', ''),
  ', Ltd', ''),
  ' Ltd', ''),
  ' ', ''),
  '&', 'and'),
  '®', ''),
  ', Inc', ''),
  ' plc', ''),
  ', L.P.', ''),
  ', a GE company', ''),
  ',', ''),
  '''', ''),
  '/', '')
  AS neworg INTO #TempJobPost
FROM indeedjobpost WITH (NOLOCK)
WHERE tagidorganization IS NULL

SELECT
  JobPostID,
  Tagid INTO #TempLiFinalJobPost
FROM #TempJobPost li,
     #tempTag t
WHERE t.newname COLLATE SQL_Latin1_General_CP1_CI_AS = li.neworg

;
WITH CTE
AS (SELECT
  JobPostID,
  RN = ROW_NUMBER() OVER (PARTITION BY JobPostID ORDER BY Tagid)
FROM #TempLiFinalJobPost)
DELETE FROM CTE
WHERE RN > 1

UPDATE indeedjobpost
SET tagidorganization = (SELECT
  tagid
FROM #TempLiFinalJobPost
WHERE #TempLiFinalJobPost.JobPostID = indeedjobpost.ID)
WHERE tagidorganization IS NULL
AND ID IN (SELECT
  JobPostID
FROM #TempLiFinalJobPost)
END
