/****** Object:  Procedure [dbo].[InsertGlassDoorAwardDataToAwards]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        Janna
-- Create date: 10 Sep 2019
-- Description:  Insert Unprocessed Data from GlassDoorAward To Awards Table
-- =============================================
CREATE PROCEDURE [dbo].[InsertGlassDoorAwardDataToAwards]
AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @GlassDoorAwardID int,
          @Rows int,
          @StartTime datetime,
          @EndTime datetime,
          @AwardIDMinimum int,
          @AwardIDMaximum int
  SET @StartTime = GETDATE()
  --
  -- If the data is getting pulled into GlassDoorAward Table, While this process 
  -- starts, we want to lock for the known value and insert into awards table
  --
  SELECT
    @GlassDoorAwardID = MAX(ID)
  FROM GlassDoorAward WITH (NOLOCK)
  WHERE IsProcessed = 0

  IF @GlassDoorAwardID IS NULL
    PRINT 'Nothing To Process'
  IF @GlassDoorAwardID IS NOT NULL
  BEGIN
    INSERT INTO Awards (Title
    , Year
    , Organization
    , Type
    , Source_Website_Url
    , AwardSource
    , Source,
	 TagID,
	 Of_OrganizationID
	)
      SELECT
        gd.Title,
        gd.Year,
        gd.Organization,
        'O',
        gd.Source_Website_URL,
        gd.AwardSource,
        'glassdoor',
		t.id TagiD,
		t.OrganizationId
      FROM glassdooraward gd WITH (NOLOCK)
	  Left Outer Join Tag T on (t.name collate SQL_Latin1_General_CP1_CI_AS = gd.Organization and t.tagtypeid=1)
      WHERE gd.IsProcessed = 0
      AND gd.id <= @GlassDoorAwardID
    SELECT
      @Rows = @@ROWCOUNT

    UPDATE glassdooraward
    SET IsProcessed = 1
    WHERE IsProcessed = 0
    AND id <= @GlassDoorAwardID
  END
  -- Get range value of non labelled records for labelling under marketing list name

  SELECT
    @AwardIDMinimum = MIN(ID),
    @AwardIDMaximum = MAX(ID)
  FROM Awards
  WHERE IsLabelled = 0

  EXEC PopulateAwardExcellenceAreaRange @AwardIDMinimum,
                                        @AwardIDMaximum
  UPDATE Awards
  SET IsLabelled = 1
  WHERE ID BETWEEN @AwardIDMinimum AND @AwardIDMaximum

  SET @EndTime = GETDATE()
  IF @GlassDoorAwardID IS NULL
    INSERT INTO JobStatusLog--
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertGlassDoorAwardDataToAwards',--
      @StartTime,--
      @EndTime,--
      'No Records To Process')
  IF @GlassDoorAwardID IS NOT NULL
    INSERT INTO JobStatusLog --
    (ProcessName,
    StartTime,
    EndTime,
    Remarks)
      VALUES ('InsertGlassDoorAwardDataToAwards',--
      @StartTime,--
      @EndTime,--
      'Number of Rows Inserted in Award Table ' + STR(@Rows))
END
