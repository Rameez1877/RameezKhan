/****** Object:  Procedure [dbo].[OutputOrganizationScore]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[OutputProcessor2] 
	-- Add the parameters for the stored procedure here
	@AppUserId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DECLARE @OP TABLE
	(
		Factor VARCHAR(100),
		OrganizationName VARCHAR(100),
		Quarter VARCHAR(20),
		Normalized_Score float
	)

	INSERT INTO @OP  
	exec dbo.OutputProcessor1 @AppUserId

	SELECT OrganizationName,MAX(Normalized_Score) as Normalized_Score FROM @OP GROUP BY OrganizationName
END
