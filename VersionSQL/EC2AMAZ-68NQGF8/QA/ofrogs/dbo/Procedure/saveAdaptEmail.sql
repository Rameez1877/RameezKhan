/****** Object:  Procedure [dbo].[saveAdaptEmail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE saveAdaptEmail
	-- Add the parameters for the stored procedure here
	@id int,
	@email varchar(200),
	@score int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update LinkedInData set emailid = @email, score = @score, emailgeneratedby = 'adapt' 
	where id = @id
END
