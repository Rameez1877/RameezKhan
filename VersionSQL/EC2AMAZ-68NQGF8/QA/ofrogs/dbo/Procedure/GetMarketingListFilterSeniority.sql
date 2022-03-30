/****** Object:  Procedure [dbo].[GetMarketingListFilterSeniority]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMarketingListFilterSeniority] 
@TargetPersonaId int,
@ResultantCountry VARCHAR(8000) = '',
@Functionality VARCHAR(8000) = '',
@Seniority VARCHAR(8000) = ''	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	If @ResultantCountry is  null
	set @ResultantCountry =''
If @ResultantCountry is  null
	set @ResultantCountry =''
If @Functionality is  null
	set @Functionality =''

	If @Seniority is  null
	set @Seniority =''

   Select Top 10 Seniority, SUM(NoOfRecords) NoOfPersonLocation
    from MarketingListFilter
	where TargetPersonaID = @targetPersonaId
	 AND (@ResultantCountry = ''
    OR Location IN (SELECT
      [Data]
    FROM dbo.Split(@ResultantCountry, ','))
    )
	 AND (@Functionality = ''
    OR Functionality IN (SELECT
      [Data]
    FROM dbo.Split(@Functionality, ','))
    )
	 AND (@Seniority = ''
    OR Seniority IN (SELECT
      [Data]
    FROM dbo.Split(@Seniority, ','))
    )
	GROUP BY Seniority
	order by SUM(NoOfRecords) desc;
	
END
