/****** Object:  Procedure [dbo].[sp_get_datacontent_by_means]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: 07 Sep 2018
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_means]
-- Add the parameters for the stored procedure here
@id int,
@InputSection varchar(20)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


    DECLARE @section varchar(20),
            @SectionContent varchar(max),
            @pos int,
            @NoOfInvertedCommas int,
            @LeftCharacter varchar(1),
            @NoofCharactersLeftOver int,
            @LeftPosition int,
            @RightCharacter varchar(1),
            @NoofCharactersRightOver int,
            @RightPosition int,
            @NoOfFullStops int,
            @OurData varchar(4000),
            @MeansOrHasTheMeaning varchar(25)
    CREATE TABLE #TempPosition (
        Pos int,
        MeansOrHasTheMeaning varchar(25)
    )
    DELETE datacontentmeansdefinition
    WHERE id = @id
        AND section = @InputSection
    SELECT
        @Section = section,
        @SectionContent = SectionContent
    FROM datacontentsections
    WHERE id = @id
    AND section = @InputSection
    INSERT INTO #TempPosition
        SELECT
            pos,
            'means'
        FROM dbo.FindPatternLocation(@SectionContent, '” means')

    INSERT INTO #TempPosition
        SELECT
            pos,
            'has the meaning'
        FROM dbo.FindPatternLocation(@SectionContent, '” has the meaning')
    DECLARE db_cursor_means CURSOR FOR
    SELECT
        Pos
    FROM #TempPosition

    ORDER BY pos
    BEGIN


        OPEN db_cursor_means
        FETCH NEXT FROM db_cursor_means INTO @pos

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @NoOfInvertedCommas = 0
            SET @NoofCharactersLeftOver = 0
            --
            -- Find left and right extreme of means text
            -- First left extreme, go back from that character till we find two inverted commas
            ---- Start

            WHILE (@NoOfInvertedCommas < 2)
            BEGIN
                SET @NoofCharactersLeftOver = @NoofCharactersLeftOver + 1
                SET @LeftCharacter = SUBSTRING(@SectionContent, @pos - @NoofCharactersLeftOver, 1)
                IF @LeftCharacter = '“'
                BEGIN
                    SET @NoOfInvertedCommas = @NoOfInvertedCommas + 1
                END
                ELSE

                IF @NoOfInvertedCommas = 1
                    BREAK;
            END
            SET @LeftPosition = @Pos - @NoofCharactersLeftOver
            --   Now right side get full stop 
            SET @NoOfFullStops = 0
            SET @NoofCharactersRightOver = 0
            WHILE (@NoOfFullstops < 3)
            BEGIN
                SET @NoofCharactersRightOver = @NoofCharactersRightOver + 1
                SET @RightCharacter = SUBSTRING(@SectionContent, @pos + @NoofCharactersRightOver, 1)
                IF @RightCharacter = '.'
                    SET @NoOfFullstops = @NoOfFullstops + 1
                IF (@NoOfFullstops = 1
                    AND @MeansOrHasTheMeaning = 'means')
                    OR (@NoOfFullstops = 2
                    AND @MeansOrHasTheMeaning = 'has the meaning')
                    BREAK;
            END
            SET @RightPosition = @Pos + @NoofCharactersRightOver
            SET @OurData = SUBSTRING(@SectionContent, @LeftPosition, @RightPosition - @LeftPosition)
            INSERT INTO datacontentmeansdefinition (id,
                                                    section,
                                                    means_text
            )
                VALUES ( @id,
                         @Section,
                         @OurData )
            FETCH NEXT FROM db_cursor_means INTO @pos
        END
    END
    CLOSE db_cursor_means
    DEALLOCATE db_cursor_means
END
