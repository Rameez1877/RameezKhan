/****** Object:  Procedure [dbo].[OutputIndustrySignal]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputIndustrySignal] 
	-- Add the parameters for the stored procedure here
@id int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select PubDate,Link,Title,Description,TopicNames,max(Score) as Score,ProductId,ProductName,
	--OrganizationId,OrganizationName from
	--(
    if @id = 0
		Begin
			select *  from OutputIndustrySignalAnalysis 
		END
	else
        Begin
			select *  from OutputIndustrySignalAnalysis  where id=@id
		END
   
	--) R
	--group by R.PubDate,R.Link,R.Title,R.Description,R.TopicNames,R.ProductId,R.ProductName,
	--R.OrganizationId,R.OrganizationName
	

END
