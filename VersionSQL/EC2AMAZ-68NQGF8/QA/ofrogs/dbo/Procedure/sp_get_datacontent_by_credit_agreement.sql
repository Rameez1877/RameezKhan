/****** Object:  Procedure [dbo].[sp_get_datacontent_by_credit_agreement]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:        <Author,,Name>
-- Create date: <Create Date,,>
-- Description:    <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_datacontent_by_credit_agreement]
-- Add the parameters for the stored procedure here
@id int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    DECLARE @DataContent varchar(max),
            @RCCCount int,
            @TCCount int,
            @FacilityType1 varchar(100),
            @FacilityType2 varchar(100),
            @FacilityType3 varchar(100),
            @FacilityType4 varchar(100),
            @ITCTextData varchar(1000),
            @ITCTextData$ int,
            @ITCTextData$Text varchar(20),
            @ITCTextData$Dot int,
            @ITCTextData$DotText varchar(20),
            @facilityAmount varchar(20),
            @facilityAmount1 varchar(20),
            @facilityAmount2 varchar(20),
            @facilityAmount3 varchar(20),
            @facilityAmount4 varchar(20),
            @ApplicableRateCount int,
            @ApplicableRateText varchar(2000),
            @EurocurrencyRateLoansCount int,
            @BaseRateLoansCount int,
            @EurocurrencyRateLoansPctext varchar(20),
            @BaseRateLoansPctext varchar(20),
            @EurocurrencyRateLoansPctextPos int,
            @BaseRateLoansPctextPos int,
            @EurocurrencyRateLoansPctextData varchar(20),
            @BaseRateLoansPctextData varchar(20),
            @LiborSpreadValue varchar(20),
            @LiborSpread varchar(50),
            @PrimeSpreadValue varchar(20),
            @PrimeSpread varchar(50),
            @PricingGridType varchar(50),
            @PricingGrid varchar(50),
            @PricingLevelPos int,
            @PricingLevelText varchar(2000),
            @HighestPricingLevelPos int,
            @LowestPricingLevelPos int,
            @PricingLevel varchar(50),
            @CommitmentFeePos int,
            @CommitmentFee varchar(50),
            @CommitmentPos int,
            @CommitmentPosText varchar(1500),
			@IntiallyAtTheHighest_UnDrawn  varchar(500),
			@LevelMax int
    DELETE FROM CreditAgreement
    WHERE DocID = @id
    SELECT
        @DataContent = DataContent
    FROM datacontent
    WHERE id = @id
    SET @RCCCount = CHARINDEX('“Revolving Credit Commitment”', @DataContent)
    SET @TCCount = CHARINDEX('“Initial Term Commitment”', @DataContent)
    SET @ApplicableRateCount = CHARINDEX('“Applicable Rate”', @DataContent)
    --
    -- Specific Logic For Facility Type And Amount For DOC ID =1 Starts HERE
    --
    IF @id = 1 
    BEGIN
        IF @RCCCount > 0
            AND @TCCount = 0
            SET @FacilityType1 = 'RCC'
        ELSE
        IF @RCCCount = 0
            AND @TCCount > 0
            SET @FacilityType1 = 'TC'
        ELSE
        IF @RCCCount > 0
            AND @TCCount > 0
            SET @FacilityType1 = 'RCC'
        SET @FacilityType2 = 'TC'

        IF @TCCount > 0
        BEGIN
            SET @ITCTextData = SUBSTRING(@Datacontent, @TCCount - 1, 2000)
            SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)
            SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
            SET @ITCTextData$Dot = CHARINDEX('.', @ITCTextData$Text)
            SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
            SET @facilityAmount = @ITCTextData$DotText + '0.00'
            IF @FacilityType1 = 'RCC'
                SET @facilityAmount2 = @facilityAmount
            ELSE
            IF @FacilityType1 = 'TC'
                SET @facilityAmount1 = @facilityAmount
        END
        IF @RCCCount > 0
        BEGIN
            SET @ITCTextData = SUBSTRING(@Datacontent, @RCCCount - 1, 2000)
            SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)
            SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
            SET @ITCTextData$Dot = CHARINDEX(' ', @ITCTextData$Text)
            SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
            SET @facilityAmount = @ITCTextData$DotText + '0.00'
            IF @FacilityType1 = 'RCC'
                SET @facilityAmount1 = @facilityAmount
            ELSE
            IF @FacilityType2 = 'RCC'
                SET @facilityAmount2 = @facilityAmount
        END
    END
    --
    -- Specific Logic For Facility Type And Amount For DOC ID =1 ENDS HERE
    --
    -- Logic For Doc ID = 2 Starts HERE
    IF @id = 2
    SET @CommitmentPos = CHARINDEX('“Commitment”', @datacontent)
    SET @CommitmentPosText = SUBSTRING(@datacontent, @CommitmentPos + 1, 500)
    SET @CommitmentPos = CHARINDEX('“', @CommitmentPosText) - 1
    SET @CommitmentPosText = SUBSTRING(@CommitmentPosText, 1, @CommitmentPos)
    IF CHARINDEX('Revolving Commitment', @CommitmentPosText) > 0
    BEGIN
        SET @FacilityType1 = 'Revolving Commitment'
        SET @facilityAmount1 = '0.00'
    END
    IF CHARINDEX('Revolving Commitment', @CommitmentPosText) > 0
    BEGIN
        SET @FacilityType1 = 'Revolving Commitment'
        SET @ITCTextData = SUBSTRING(@Datacontent, CHARINDEX('“Revolving Commitment”', @Datacontent), 200000)
        SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)
        IF @ITCTextData$ > 0
        BEGIN
            SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
            SET @ITCTextData$Dot = CHARINDEX(' ', @ITCTextData$Text)
            SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
            SET @facilityAmount1 = @ITCTextData$DotText + '0.00'
        END
        ELSE
            SET @facilityAmount1 = '0.00'

    END

    IF CHARINDEX('Tranche A1 Commitment', @CommitmentPosText) > 0
    BEGIN
        SET @FacilityType2 = 'Tranche A1 Commitment'
        SET @ITCTextData = SUBSTRING(@Datacontent, CHARINDEX('“Tranche A1 Commitment”', @Datacontent), 200000)
        SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)

        IF @ITCTextData$ > 0
        BEGIN
            SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
            SET @ITCTextData$Dot = CHARINDEX('.', @ITCTextData$Text)
            SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
            SET @facilityAmount2 = @ITCTextData$DotText + '0.00'
        END
        ELSE
            SET @facilityAmount2 = '0.00'
    END
    IF CHARINDEX('Tranche A2 Commitment', @CommitmentPosText) > 0
    BEGIN
        SET @FacilityType3 = 'Tranche A2 Commitment'
        SET @ITCTextData = SUBSTRING(@Datacontent, CHARINDEX('“Tranche A2 Commitment”', @Datacontent), 200000)
        SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)
        SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
        SET @ITCTextData$Dot = CHARINDEX('.', @ITCTextData$Text)
        SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
        SET @facilityAmount3 = @ITCTextData$DotText + '0.00'
    END

    IF CHARINDEX('Term Loan B Commitment', @CommitmentPosText) > 0
    BEGIN
        SET @FacilityType4 = 'Term Loan B Commitment'
        SET @ITCTextData = SUBSTRING(@Datacontent, CHARINDEX('“Term Loan B Commitment”', @Datacontent), 200000)
        SET @ITCTextData$ = CHARINDEX('$', @ITCTextData)
        SET @ITCTextData$Text = SUBSTRING(@ITCTextData, @ITCTextData$, 20)
        SET @ITCTextData$Dot = CHARINDEX('.', @ITCTextData$Text)
        SET @ITCTextData$DotText = SUBSTRING(@ITCTextData$Text, 1, @ITCTextData$Dot - 1)
        SET @facilityAmount4 = @ITCTextData$DotText + '0.00'
    END
	declare @LevelMaxCount int, @LevelText varchar(10)
	declare @DailyMarginPos Int, @DailyMarginText varchar(1000), @Level5FullLineText varchar(1000)
	DECLARE @one float, @two float, @three float, @four float
	If @id=2
	begin
	

	SET @CommitmentFeePos = charindex('“Commitment Fee Rate”',@DataContent)
	If @CommitmentFeePos >0
	SET @CommitmentPosText = substring(@DataContent,@CommitmentFeePos,600)

	--done on dec 16 start
--	print @CommitmentPosText
	SET @DailyMarginPos =  charindex('“Daily margin”',@DataContent)
	SET @DailyMarginText = substring(@DataContent,@DailyMarginPos,1100)
	--print @DailyMarginText
	--Print charindex('Level 5',@DailyMarginText)
	SET @Level5FullLineText = substring(@DailyMarginText, charindex('Level 5',@DailyMarginText),60)
	--print  @Level5FullLineText
	SET @one=  convert(float, substring(@Level5FullLineText,14,5))  * 100
SET @two= convert(float, substring(@Level5FullLineText,27,5))  * 100 
SET @three= convert(float, substring(@Level5FullLineText,40,5))  * 100 
SET @four= convert(float, substring(@Level5FullLineText,53,5))  * 100 
print  @one
	-- done on dec 16 end
	begin
	SELECT
        @LevelMaxCount = count(*)
    FROM dbo.FindPatternLocation(@CommitmentPosText, 'Level')
	SET @LevelMaxCount = @LevelMaxCount - 1
	SET @LevelText = 'Level ' +ltrim(str(@LevelMaxCount))
	
	SET @CommitmentFeePos = charindex(@LevelText,@CommitmentPosText)
	SET @CommitmentPosText  = substring(@CommitmentPosText,@CommitmentFeePos+13,6)
	SET @CommitmentPosText= ltrim(replace(@CommitmentPosText,'%',''))
	SET @CommitmentPosText= ltrim(replace(@CommitmentPosText,'	',''))
	--SET @CommitmentFee = convert(float,@CommitmentPosText)  * 100
	
	
	end
	end
	declare @ApplicableMarginPos Int,@ApplicableMarginText Varchar(1500), @WithRespectToTermLoanBAdvancesPos Int
	declare @WithRespectToTermLoanBAdvancesText  Varchar(500)
	declare @EurocurrencyRateAdvancesPos Int, @TermLoanBCommitmentLibor int
	declare @BaseRateAdvancesPos Int, @TermLoanBCommitmentSpread int

	If @id=2 -- For Term Loan B Commitment Libor Spread and Prime Spread
	begin
	SET @ApplicableMarginPos = charindex('“Applicable Margin',@Datacontent)
	--print @ApplicableMarginPos
	If @ApplicableMarginPos >0
	begin
	SET @ApplicableMarginText = substring(@Datacontent,@ApplicableMarginPos,1500)
	--print @ApplicableMarginText
	SET @WithRespectToTermLoanBAdvancesPos = charindex('with respect to Term Loan B Advances',@ApplicableMarginText)
	If @WithRespectToTermLoanBAdvancesPos >0 
	begin
	SET @WithRespectToTermLoanBAdvancesText =  substring(@ApplicableMarginText,@WithRespectToTermLoanBAdvancesPos+36,200)
	--print @WithRespectToTermLoanBAdvancesText
	SET @EurocurrencyRateAdvancesPos = charindex(', in the case of Eurocurrency Rate Advances',@WithRespectToTermLoanBAdvancesText)
	--print @EurocurrencyRateAdvancesPos
	If @EurocurrencyRateAdvancesPos > 0
	--print replace( right(substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1),5),'%','')
	--print substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1)
	begin
	SET @TermLoanBCommitmentLibor = convert(float,replace( right(substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1),5),'%',''))  * 100
	SET @BaseRateAdvancesPos =  charindex(', in the case of Base Rate Advances',substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1))
	--print right(substring(substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1),1,@BaseRateAdvancesPos-1),5)
	--print @BaseRateAdvancesPos
	--print right(substring(substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1),1,@BaseRateAdvancesPos-1),5)
	SET @TermLoanBCommitmentSpread=convert(float,replace(right(substring(substring(@WithRespectToTermLoanBAdvancesText,1,@EurocurrencyRateAdvancesPos-1),1,@BaseRateAdvancesPos-1),5),'%',''))  * 100

	--print @TermLoanBCommitmentSpread
	end 
	 
	
	end
	end

	end

    -- Logic For Doc ID = 2 Ends HERE


    --
    -- Applciable Rate
    --
	--print @ApplicableRateCount
    IF @ApplicableRateCount > 0
	
    BEGIN
        SET @ApplicableRateText = SUBSTRING(@datacontent, @ApplicableRateCount, 2000)
		If charindex('highest pricing level',@ApplicableRateText) >0 or charindex('highest pricing',@ApplicableRateText) >0 
		SET @IntiallyAtTheHighest_UnDrawn ='At the Highest'
        ELSE If charindex('initial pricing level',@ApplicableRateText) >0 or charindex('initial pricing', @ApplicableRateText) >0 
		SET @IntiallyAtTheHighest_UnDrawn ='Intially'
		else If  charindex('Pricing Level',@ApplicableRateText) >0
		begin
		SET @IntiallyAtTheHighest_UnDrawn =''
		end 
	
        -- Libor Spread Start
        SET @EurocurrencyRateLoansCount = CHARINDEX('Eurocurrency Rate Loans', @ApplicableRateText)
        IF @EurocurrencyRateLoansCount > 0
            SET @EurocurrencyRateLoansCount = @EurocurrencyRateLoansCount + 23 + 2-- 2 for comma and space and 23 for long text

        IF @EurocurrencyRateLoansCount > 0
            SET @EurocurrencyRateLoansPctext = SUBSTRING(@ApplicableRateText, @EurocurrencyRateLoansCount, 100)

        SET @EurocurrencyRateLoansPctextPos = CHARINDEX('%', @EurocurrencyRateLoansPctext)
        IF @EurocurrencyRateLoansPctextPos > 0
        BEGIN
            SET @EurocurrencyRateLoansPctextData = SUBSTRING(@EurocurrencyRateLoansPctext, 1, @EurocurrencyRateLoansPctextPos)
            SET @LiborSpreadValue = @EurocurrencyRateLoansPctextData
            SET @LiborSpread = 'Eurocurrency Rate Loan'
        END
        -- Libor Spread End
        -- Prime Spread Start
        SET @BaseRateLoansCount = CHARINDEX('Base Rate Loans', @ApplicableRateText)

        IF @BaseRateLoansCount > 0
            SET @BaseRateLoansCount = @BaseRateLoansCount + 15 + 2-- 2 for comma and space and 23 for long text

        IF @BaseRateLoansCount > 0
            SET @BaseRateLoansPctext = SUBSTRING(@ApplicableRateText, @BaseRateLoansCount, 100)

        SET @BaseRateLoansPctextPos = CHARINDEX('%', @BaseRateLoansPctext)
        IF @BaseRateLoansPctextPos > 0
        BEGIN
            SET @BaseRateLoansPctextData = SUBSTRING(@BaseRateLoansPctext, 1, @BaseRateLoansPctextPos)
            SET @PrimeSpreadValue = @BaseRateLoansPctextData
            SET @PrimeSpread = 'Base Rate Loan'
        END
    END
    -- Prime Spread End

    IF CHARINDEX('First Lien Leverage Ratio', @datacontent) > 0
    BEGIN
        SET @PricingGridType = 'First Lien Leverage Ratio'
        SET @PricingGrid = 'Yes'
    END
    ELSE
    IF CHARINDEX('consolidated total net leverage ratio', @datacontent) > 0
    BEGIN
        SET @PricingGridType = 'Consolidated Total Net Leverage Ratio'
        SET @PricingGrid = 'Yes'
    END
    -- Commitment Fee
    SET @PricingLevelPos = CHARINDEX('Pricing
Level', @ApplicableRateText)
    SET @PricingLevelText = SUBSTRING(@ApplicableRateText, @PricingLevelPos, 2000)
    SET @HighestPricingLevelPos = CHARINDEX('highest pricing level', @PricingLevelText)
    SET @LowestPricingLevelPos = CHARINDEX('lowest pricing level', @PricingLevelText)
    IF (@HighestPricingLevelPos = 0
        AND @LowestPricingLevelPos = 0)
        OR @HighestPricingLevelPos > 0
        SET @PricingLevel = 'High'
    ELSE
    IF @LowestPricingLevelPos > 0
        SET @PricingLevel = 'Low'

    IF @PricingLevel = 'High'
    BEGIN
        SELECT
            @CommitmentFeePos = MAX(pos)
        FROM dbo.FindPatternLocation(@PricingLevelText, '%')
        IF @CommitmentFeePos > 0
            SET @CommitmentFee = SUBSTRING(@PricingLevelText, @CommitmentFeePos - 10, 11)

    END
    IF @PricingLevel = 'Low'
    BEGIN
        SELECT
            @CommitmentFeePos = MIN(pos)
        FROM dbo.FindPatternLocation(@PricingLevelText, '%')
        IF @CommitmentFeePos > 0
            SET @CommitmentFee = SUBSTRING(@PricingLevelText, @CommitmentFeePos - 10, 11)

    END
   -- SET @CommitmentFee = REPLACE(LTRIM(RTRIM(@CommitmentFee)), ' ', '')
    IF @id = 1 
    BEGIN
	print @CommitmentFee
        INSERT INTO CreditAgreement (DocID,
                                     FacilityType,
                                     FacilityAmount,
                                     LiborSpread,
                                     LiborSpreadValue,
                                     PrimeSpread,
                                     PrimeSpreadValue,
                                     PricingGridType,
                                     PricingGrid,
                                     CommitmentFee,
									 IntiallyAtTheHighest_UnDrawn
        )
        VALUES ( @id,
                     @FacilityType1,
                     @facilityAmount1,
                     @LiborSpread,
                     substring(@LiborSpreadValue,1,len(@LiborSpreadValue)-1)  * cast(100 as decimal(5, 0))   ,
                     @PrimeSpread,
                     substring(@PrimeSpreadValue,1,len(@PrimeSpreadValue)-1)  * cast(100 as decimal(5, 0))    ,
                     @PricingGridType,
                     @PricingGrid,
                --   @CommitmentFee,

				convert(float,replace(replace(@CommitmentFee,'%',''),'	','')) * 100,
					 @IntiallyAtTheHighest_UnDrawn )

        IF LEN(@FacilityType2) > 0
            INSERT INTO CreditAgreement (DocID,
                                         FacilityType,
                                         FacilityAmount,
                                         LiborSpread,
                                         LiborSpreadValue,
                                         PrimeSpread,
                                         PrimeSpreadValue,
                                         PricingGridType,
                                         PricingGrid,
                                         CommitmentFee,
										 IntiallyAtTheHighest_UnDrawn
            )
                VALUES ( @id,
                         @FacilityType2,
                         @facilityAmount2,
                         @LiborSpread,
                         substring(@LiborSpreadValue,1,len(@LiborSpreadValue)-1)  * cast(100 as decimal(5, 0)) ,
                         @PrimeSpread,
                         substring(@PrimeSpreadValue,1,len(@PrimeSpreadValue)-1)  * cast(100 as decimal(5, 0))    ,
                         @PricingGridType,
                         @PricingGrid,
                     --  @CommitmentFee,
					convert(float,replace(replace(@CommitmentFee,'%',''),'	','')) * 100,
						 @IntiallyAtTheHighest_UnDrawn)
    END

    IF @id = 2
    BEGIN
        INSERT INTO CreditAgreement (DocID,
                                     FacilityType,
                                     FacilityAmount,
                                     LiborSpread,
                                     LiborSpreadValue,
                                     PrimeSpread,
                                     PrimeSpreadValue,
                                     PricingGridType,
                                     PricingGrid,
                                     CommitmentFee
        )
            VALUES ( @id,
                     @FacilityType1,
                     @facilityAmount1,
                    'Eurocurrency Rate Loan',--   @LiborSpread,
                   @three,
                     'Base Rate Loan',--   @PrimeSpread,
                   @four,
                    
                     @PricingGridType,
                     @PricingGrid,
                     --@CommitmentFee
					 convert(float,@CommitmentPosText)  * 100
					  )

        IF LEN(@FacilityType2) > 0
            INSERT INTO CreditAgreement (DocID,
                                         FacilityType,
                                         FacilityAmount,
                                         LiborSpread,
                                         LiborSpreadValue,
                                         PrimeSpread,
                                         PrimeSpreadValue,
                                         PricingGridType,
                                         PricingGrid,
                                         CommitmentFee
            )
                VALUES ( @id,
                         @FacilityType2,
                         @facilityAmount2,
                         'Eurocurrency Rate Loan',
                       @one,
                         'Base Rate Loan',
                       @two,
                    
                         @PricingGridType,
                         @PricingGrid,
                         --@CommitmentFee 
						 convert(float,@CommitmentPosText)  * 100
						 )

        IF LEN(@FacilityType3) > 0
            INSERT INTO CreditAgreement (DocID,
                                         FacilityType,
                                         FacilityAmount,
                                         LiborSpread,
                                         LiborSpreadValue,
                                         PrimeSpread,
                                         PrimeSpreadValue,
                                         PricingGridType,
                                         PricingGrid,
                                         CommitmentFee
            )
                VALUES ( @id,
                         @FacilityType3,
                         @facilityAmount3,
                         'Eurocurrency Rate Loan',
                         @three,
                         'Base Rate Loan',
                        @four,
                         @PricingGridType,
                         @PricingGrid,
                        -- @CommitmentFee
						convert(float,@CommitmentPosText)  * 100
						  )

        IF LEN(@FacilityType4) > 0
            INSERT INTO CreditAgreement (DocID,
                                         FacilityType,
                                         FacilityAmount,
                                         LiborSpread,
                                         LiborSpreadValue,
                                         PrimeSpread,
                                         PrimeSpreadValue,
                                         PricingGridType,
                                         PricingGrid,
                                         CommitmentFee
            )
                VALUES ( @id,
                         @FacilityType4,
                         @facilityAmount4,
                         'Eurocurrency Rate Loan',
                         @TermLoanBCommitmentLibor,
                         'Base Rate Loan',
                        @TermLoanBCommitmentSpread,
                         @PricingGridType,
                         @PricingGrid,
                     --    @CommitmentFee
						 convert(float,@CommitmentPosText)  * 100
						  )
    END
END
