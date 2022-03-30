/****** Object:  Procedure [dbo].[Getcolleagues]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Asef Daqiq>
-- Create date: <5 March 2020>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Getcolleagues] 
	-- Add the parameters for the stored procedure here
	@TargetPersonaId int
AS
BEGIN
	DECLARE @UserId int,
	        @Organization varchar(300),
			@EmailID VARCHAR(200)
			
	SELECT
	 @UserId = CreatedBy 
	FROM TargetPersona 
	WHERE Id = @TargetPersonaId

	SELECT 
		@Organization = OrganizationName
		,@EmailID = Email  
	FROM AppUser
	WHERE Id = @UserId

	-- Edit(01) 
	-- 09-Nov-2021 - Kabir - Same manual matching
	SET @EmailID = (SELECT right(@EmailID,len(@EmailID) - CHARINDEX('@',@EmailID) +1))

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Id, Email 
	FROM AppUser
	WHERE 
	--OrganizationName =  @Organization 
	Email LIKE '%' + @EmailID + '%' 
	AND Id != @UserId
	and IsActive = 1
END
