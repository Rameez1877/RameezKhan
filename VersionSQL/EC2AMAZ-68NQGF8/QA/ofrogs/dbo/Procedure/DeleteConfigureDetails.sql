/****** Object:  Procedure [dbo].[DeleteConfigureDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteConfigureDetails]
	-- Add the parameters for the stored procedure here
	@userId int,
    @type varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
			update AppUser set isNewUser = 0 where Id = @userId

           if @type = 'Functionality'
		   begin
			delete from UserTargetFunctionality where UserID = @userId
		   end

           if @type = 'Technology'
		   begin
			delete from UserTargetTechnology where UserID = @userId 
		   end 
           
		   if @type = 'Country'
		   begin
			delete from UserTargetCountry where UserID = @userId
			end

			  if @type = 'Seniority'
		   begin
			delete from UserTargetSeniority where UserID = @userId
			end

			  if @type = 'Solution'
		   begin
			delete from UserTargetWebsiteSolutionGroup where UserID = @userId
			end

			  if @type = 'Product'
		   begin
			delete from UserTargetWebsiteProductGroup where UserID = @userId
			end

END
