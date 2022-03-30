/****** Object:  Procedure [dbo].[sp_get_datacontent_by_keyword_start_position]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_keyword_start_position] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM datacontentsectionposition where id=@id
    DECLARE @Section varchar(50),
            @Position int,
            @PreviousMaxValue int

    DECLARE db_cursor_section_start_position CURSOR FOR
    SELECT
        section,
        MIN(position) minpos
    FROM datacontentposition
    WHERE id = @id
   GROUP BY section
    ORDER BY  CAST(rtrim(substring(section,9,10)) as float)
    OPEN db_cursor_section_start_position
    FETCH NEXT FROM db_cursor_section_start_position INTO @Section, @Position

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @PreviousMaxValue IS NULL
            SELECT
                @PreviousMaxValue = min(position)
            FROM datacontentposition
            WHERE id =@id
            AND position <> @Position
            AND section = @Section
        ELSE
            SELECT
                @PreviousMaxValue = min(position)
            FROM datacontentposition
            WHERE id =@id
            AND position <> @Position
            AND position > @PreviousMaxValue
            AND section = @Section

      	INSERT into datacontentsectionposition values(@id,@Section,@PreviousMaxValue)

        FETCH NEXT FROM db_cursor_section_start_position INTO @Section, @Position
    END

    CLOSE db_cursor_section_start_position
    DEALLOCATE db_cursor_section_start_position
END
