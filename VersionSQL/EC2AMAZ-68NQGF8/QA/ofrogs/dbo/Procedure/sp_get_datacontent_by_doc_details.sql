/****** Object:  Procedure [dbo].[sp_get_datacontent_by_doc_details]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_doc_details]
-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DELETE DocumentDetails
    WHERE id = @id
    DECLARE @DataOfInterest varchar(8000),
            @Company varchar(1000)
    DECLARE @CompanyPositionToSearchData int,
            @CompanyPosition int,
            @CompanyPositionEnd int,
            @BorrowerPosition int,
            @BorrowerPositionEnd int,
            @HoldingsPosition int,
            @HoldingsPositionEnd int,
            @AmongPosition int,
            @AdministrativeAgentPosition int,
            @AdministrativeAgentPositionEnd int,
            @CollateralAgentPosition int,
            @CollateralAgentPositionEnd int,
            @SyndicationAgentPosition int,
            @SyndicationAgentPositionEnd int,
            @CoDocumentationAgentsPosition int,
            @CoDocumentationAgentsPositionEnd int,
            @ArrangersPosition int,
            @ArrangersPositionEnd int,
            @ArrangersPosition1 int,
            @ArrangersPosition1End int,
            @ArrangersPosition2 int,
            @ArrangersPosition2End int,
            @LendersPosition int,
            @LendersPositionEnd int,
            @AdministrativeAgentPos int,
            @CollateralAgentPos int,
            @AdministrativeAgentData int,
            @AdministrativeAgentDataText varchar(1000),
            @CollateralAgentData int,
            @CollateralAgentDataText varchar(1000),
            @SyndicationAgentData int,
            @SyndicationAgentDataText varchar(1000),
            @CoDocumentationAgentsData int,
            @CoDocumentationAgentsDataText varchar(1000),
            @ArrangersData int,
            @ArrangersDataText varchar(1000),
            @TheBorrower varchar(1),
            @TheAdministrativeAgent varchar(1),
            @TheCollateralAgent varchar(1),
			@Holdings varchar(1000),
			@Borrower varchar(1000),
			@DailyMargilLevelPos Int,
			@DailyMargilLevel  varchar(2000)


    CREATE TABLE #TempPosition (
        Positiontype varchar(50),
        Position int
    )

    SELECT
        @DataOfInterest = SUBSTRING(datacontent, 1, CHARINDEX('Table of Contents', datacontent) - 1)
    FROM datacontent
    WHERE id = @id

    DELETE #TempPosition
    SET @TheAdministrativeAgent = 'N'
    SET @TheCollateralAgent = 'N'

    SET @CompanyPositionToSearchData = CHARINDEX('as the Company', @DataOfInterest)
    SET @CompanyPosition = CHARINDEX('as the Company', @DataOfInterest)
    SET @CompanyPositionEnd = @CompanyPosition + 14
    SET @AmongPosition = CHARINDEX('among', @DataOfInterest) --where to start comoany name info
    SET @AdministrativeAgentPosition = CHARINDEX('as Administrative Agent', @DataOfInterest)
    IF @AdministrativeAgentPosition = 0
    BEGIN
        SET @AdministrativeAgentPosition = CHARINDEX('as The Administrative Agent', @DataOfInterest)
        IF @AdministrativeAgentPosition > 0
            SET @TheAdministrativeAgent = 'Y'
    END


    IF @AdministrativeAgentPosition <> 0
        AND @TheAdministrativeAgent = 'N'
        SET @AdministrativeAgentPositionEnd = @AdministrativeAgentPosition + 23
    ELSE
    IF @AdministrativeAgentPosition <> 0
        AND @TheAdministrativeAgent = 'Y'
        SET @AdministrativeAgentPositionEnd = @AdministrativeAgentPosition + 27
    ELSE
        SET @AdministrativeAgentPositionEnd = 0

    SET @LendersPosition = CHARINDEX('as Lenders', @DataOfInterest)
    IF @LendersPosition <> 0
        SET @LendersPositionEnd = @LendersPosition + 11
    ELSE
        SET @LendersPositionEnd = 0


    SET @CollateralAgentPosition = CHARINDEX('as Collateral Agent', @DataOfInterest)
    IF @CollateralAgentPosition = 0
        SET @CollateralAgentPosition = CHARINDEX('as The Collateral Agent', @DataOfInterest)

    IF @CollateralAgentPosition <> 0
        AND @TheCollateralAgent = 'N'
        SET @CollateralAgentPositionEnd = @CollateralAgentPosition + 19
    ELSE
    IF @CollateralAgentPosition <> 0
        AND @TheCollateralAgent = 'N'
        SET @CollateralAgentPositionEnd = @CollateralAgentPosition + 23
    ELSE
        SET @CollateralAgentPositionEnd = 0

    SET @SyndicationAgentPosition = CHARINDEX('as Syndication Agent', @DataOfInterest)
    IF @SyndicationAgentPosition <> 0
        SET @SyndicationAgentPositionEnd = @SyndicationAgentPosition + 20
    ELSE
        SET @SyndicationAgentPositionEnd = 0


    SET @CoDocumentationAgentsPosition = CHARINDEX('as Co-Documentation Agents', @DataOfInterest)
    IF @CoDocumentationAgentsPosition <> 0
        SET @CoDocumentationAgentsPositionEnd = @CoDocumentationAgentsPosition + 26

    SET @ArrangersPosition1 = CHARINDEX('as Arrangers', @DataOfInterest)
    IF @ArrangersPosition1 <> 0
        SET @ArrangersPosition1End = @ArrangersPosition1 + 12
    SET @ArrangersPosition2 = CHARINDEX('as Joint Lead Arrangers', @DataOfInterest)
    IF @ArrangersPosition2 <> 0
        SET @ArrangersPosition2eND = @ArrangersPosition2 + 24
    IF @ArrangersPosition1 = 0
        AND @ArrangersPosition2 > 0
    BEGIN
        SET @ArrangersPosition = @ArrangersPosition2
        SET @ArrangersPositionEnd = @ArrangersPosition2End
    END
    ELSE
    IF @ArrangersPosition1 > 0
        AND @ArrangersPosition2 = 0
    BEGIN
        SET @ArrangersPosition = @ArrangersPosition1
        SET @ArrangersPositionEnd = @ArrangersPosition1End
    END
    ELSE
    IF @ArrangersPosition1 > 0
        AND @ArrangersPosition2 > 0
    BEGIN
        SET @ArrangersPosition =
        (CASE
            WHEN @ArrangersPosition1 > @ArrangersPosition2 THEN @ArrangersPosition1
            ELSE @ArrangersPosition2
        END)

        SET @ArrangersPositionEnd =
        (CASE
            WHEN @ArrangersPosition1End > @ArrangersPosition2End THEN @ArrangersPosition1End
            ELSE @ArrangersPosition2End
        END)
    END
    ELSE
    BEGIN
        SET @ArrangersPosition = 0
        SET @ArrangersPositionEnd = 0
    END
    IF @CompanyPositionToSearchData = 0
        SELECT
            @CompanyPositionToSearchData = CHARINDEX('as Holdings', @DataOfInterest)
        FROM datacontent
        WHERE id = @id
    IF @CompanyPositionToSearchData = 0
        SELECT
            @CompanyPositionToSearchData = CHARINDEX('as the Borrower', @DataOfInterest)
        FROM datacontent
        WHERE id = @id
    IF @CompanyPositionToSearchData = 0
        SELECT
            @CompanyPositionToSearchData = CHARINDEX('as a Borrower', @DataOfInterest)
        FROM datacontent
    SET @TheBorrower = 'Y'
    SET @BorrowerPosition = CHARINDEX('as the Borrower', @DataOfInterest)
    IF @BorrowerPosition = 0
    BEGIN
        SET @BorrowerPosition = CHARINDEX('as a Borrower', @DataOfInterest)
        SET @TheBorrower = 'N'
    END

    SET @HoldingsPosition = CHARINDEX('as Holdings', @DataOfInterest)
    IF @TheBorrower = 'Y'
        SET @BorrowerPositionEnd = @BorrowerPosition + 15
    ELSE

        SET @BorrowerPositionEnd = @BorrowerPosition + 13

    SET @HoldingsPositionENd = @HoldingsPosition + 11

    IF @CompanyPositionToSearchData = 0
        SET @Company = NULL
    ELSE
    BEGIN

        SET @Company = SUBSTRING(@DataOfInterest, @AmongPosition + 5, (@CompanyPositionToSearchData - 1) - (@AmongPosition + 5))

    END

    INSERT INTO #TempPosition
        VALUES ( 'Adminsitrative Agent',
                 CASE
                     WHEN @AdministrativeAgentPositionEnd = 0 THEN 99999
                     ELSE @AdministrativeAgentPositionEnd
                 END )

    INSERT INTO #TempPosition
        VALUES ( 'Company',
                 CASE
                     WHEN @CompanyPositionEnd = 0 THEN 99999
                     ELSE @CompanyPositionEnd
                 END )

    INSERT INTO #TempPosition
        VALUES ( 'Borrower',
                 CASE
                     WHEN @BorrowerPositionEnd = 0 THEN 99999
                     ELSE @BorrowerPositionEnd
                 END )

    INSERT INTO #TempPosition
        VALUES ( 'Holdings',
                 CASE
                     WHEN @HoldingsPositionEnd = 0 THEN 99999
                     ELSE @HoldingsPositionEnd
                 END )


    INSERT INTO #TempPosition
        VALUES ( 'Collateral',
                 CASE
                     WHEN @CollateralAgentPositionEnd = 0 THEN 99999
                     ELSE @CollateralAgentPositionEnd
                 END )


    INSERT INTO #TempPosition
        VALUES ( 'Syndicate',
                 CASE
                     WHEN @SyndicationAgentPositionEnd = 0 THEN 99999
                     ELSE @SyndicationAgentPositionEnd
                 END )


    INSERT INTO #TempPosition
        VALUES ( 'Document',
                 CASE
                     WHEN @CoDocumentationAgentsPositionEnd = 0 THEN 99999
                     ELSE @CoDocumentationAgentsPositionEnd
                 END )


    INSERT INTO #TempPosition
        VALUES ( 'Arranger',
                 CASE
                     WHEN @ArrangersPositionEnd = 0 THEN 99999
                     ELSE @ArrangersPositionEnd
                 END )

    INSERT INTO #TempPosition
        VALUES ( 'Lender',
                 CASE
                     WHEN @LendersPositionEnd = 0 THEN 99999
                     ELSE @LendersPositionEnd
                 END )

    DELETE FROM TempPosition
    INSERT INTO TempPosition
        SELECT
            *
        FROM #TempPosition
    --
    -- Administrative Agent
    --
    SELECT
        @AdministrativeAgentData = MAX(Position)
    FROM #TempPosition
    WHERE Position < @AdministrativeAgentPosition


    IF @AdministrativeAgentData < @AdministrativeAgentPosition
        AND @AdministrativeAgentData > 0
        SET @AdministrativeAgentDataText = REPLACE(SUBSTRING(@DataOfInterest, @AdministrativeAgentData, @AdministrativeAgentPosition - @AdministrativeAgentData), 'as Syndication Agent', '')
    ELSE
        SET @AdministrativeAgentDataText = NULL
    --
    -- Collateral Agent
    --
    SELECT
        @CollateralAgentData = MAX(Position)
    FROM #TempPosition
    WHERE Position < @CollateralAgentPositionEnd
    AND Position <> 0
    AND Position <> 99999

    IF @CollateralAgentData < @CollateralAgentPosition
        AND @CollateralAgentPosition <> 0
        SET @CollateralAgentDataText = REPLACE(SUBSTRING(@DataOfInterest, @CollateralAgentData, @CollateralAgentPositionEnd - @CollateralAgentData), 'as Collateral Agent', '')
    ELSE
        SET @CollateralAgentDataText = NULL

    --
    -- Syndication Agent
    --
    SELECT
        @SyndicationAgentData = MAX(Position)
    FROM #TempPosition
    WHERE Position < @SyndicationAgentPositionEnd
    AND Position <> 0
    AND Position <> 99999

    IF @SyndicationAgentData < @SyndicationAgentPosition
        AND @SyndicationAgentPosition <> 0
        SET @SyndicationAgentDataText = REPLACE(SUBSTRING(@DataOfInterest, @SyndicationAgentData, @SyndicationAgentPositionEnd - @SyndicationAgentData), 'as Syndication Agent', '')
    ELSE
        SET @SyndicationAgentDataText = NULL

    --
    -- Co-Document Agents 
    --
    SELECT
        @CoDocumentationAgentsData = MAX(Position)
    FROM #TempPosition
    WHERE Position < @CoDocumentationAgentsPositionEnd
    AND Position <> 0
    AND Position <> 99999

    IF @CoDocumentationAgentsData < @CoDocumentationAgentsPosition
        AND @CoDocumentationAgentsPosition <> 0
        SET @CoDocumentationAgentsDataText = REPLACE(SUBSTRING(@DataOfInterest, @CoDocumentationAgentsData, @CoDocumentationAgentsPositionEnd - @CoDocumentationAgentsData), 'as Co-Documentation Agents', '')
    ELSE
        SET @CoDocumentationAgentsDataText = NULL
    --
    -- Arrangers
    -- 
    SELECT
        @ArrangersData = MAX(Position)
    FROM #TempPosition
    WHERE Position < @ArrangersPositionEnd
    AND Position <> 0
    AND Position <> 99999

    IF @ArrangersData < @ArrangersPosition
        AND @ArrangersPosition <> 0
    BEGIN
        IF @ArrangersPosition1 <> 0
            SET @ArrangersDataText = REPLACE(SUBSTRING(@DataOfInterest, @ArrangersData, @ArrangersPositionEnd - @ArrangersData), 'as Arrangers', '')
        ELSE
            SET @ArrangersDataText = REPLACE(SUBSTRING(@DataOfInterest, @ArrangersData, @ArrangersPositionEnd - @ArrangersData), 'as Joint Lead Arrangers', '')
    END
    ELSE
        SET @ArrangersDataText = NULL
		delete TempPosition
		insert into TempPosition select * from #TempPosition

		SET @Borrower = replace(substring(@DataOfInterest,@HoldingsPositionEnd+3,@BorrowerPositionEnd-@HoldingsPositionEnd),'as the Borrower  ','')
		If len(@Borrower) < 5 
		set @Borrower =null
	   SET @Holdings =  replace(substring(@DataOfInterest,@AmongPosition+5,@BorrowerPositionEnd-@HoldingsPositionEnd),'as Holdings, ',' ')
		If len(@Holdings) < 5 
		set @Holdings =null
 
	select @DailyMargilLevel = case when charindex('Daily Margin
for',datacontent) >0 then
	substring(datacontent, charindex('Daily Margin
for',datacontent),2000)
	end
	from datacontent
	where id=@id
	If len(@DailyMargilLevel) > 0 and charindex('“',@DailyMargilLevel)-1 >0 

	set @DailyMargilLevel = substring(@DailyMargilLevel,1,charindex('“',@DailyMargilLevel)-1)

   INSERT INTO DocumentDetails (id,
                                 Company,
                                 AdministrativeAgent,
                                 CollateralAgent,
                                 SyndicationAgent,
                                 CoDocumentationAgents,
                                 Arrangers,
								 Borrower,
								 Holding,
								 DailyMargilLevel
    )
        VALUES ( @id,
                 RTRIM(LTRIM(@Company)),
                 @AdministrativeAgentDataText,
                 @CollateralAgentDataText,
                 @SyndicationAgentDataText,
                 @CoDocumentationAgentsDataText,
                 @ArrangersDataText,
				 @Borrower,
				 @Holdings,
				 @DailyMargilLevel)

END
