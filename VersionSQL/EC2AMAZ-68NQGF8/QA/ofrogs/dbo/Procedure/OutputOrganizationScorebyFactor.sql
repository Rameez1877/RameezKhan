/****** Object:  Procedure [dbo].[OutputOrganizationScorebyFactor]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputProcessor3] 
	-- Add the parameters for the stored procedure here
	@AppUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @OP TABLE
	(
		Factor VARCHAR(100),
		OrganizationName VARCHAR(100),
		Quarter VARCHAR(20),
		Normalized_Score float
	)

	INSERT INTO @OP 
	exec dbo.OutputProcessor1 @AppUserId

	SELECT OrganizationName,Factor,MAX(Normalized_Score) as Normalized_Score FROM @OP GROUP BY OrganizationName,Factor


END
