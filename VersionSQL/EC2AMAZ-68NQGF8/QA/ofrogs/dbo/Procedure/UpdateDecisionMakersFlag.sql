/****** Object:  Procedure [dbo].[UpdateDecisionMakersFlag]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateDecisionMakersFlag] 
	-- Add the parameters for the stored procedure here
	@UserId int,
	@Ids varchar(5000) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update SurgeContactDetail set isNew = 0, EmailGeneratedDate = GETDATE()
	where id in(SELECT
      [Data]
    FROM dbo.Split(@Ids, ','))
END
