/****** Object:  Procedure [dbo].[RssCustomerTargetTagging]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RssCustomerTargetTagging] 
--	@year varchar(20)
@appuserid INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @name varchar(200)

	DECLARE cur CURSOR FOR SELECT top 100 Org.name FROM ofuser.CustomerTargetList CTL, organization Org 
	where Org.id = CTL.organizationid and CTL.AppUserId = @appuserid and Org.createdbyid = 43
--	and CTL.NewsTagStatus is null

	OPEN cur

	FETCH NEXT FROM cur INTO @name

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.processrssfeeditem2 @name, 2017
		FETCH NEXT FROM cur INTO @name
	END

	CLOSE cur
	DEALLOCATE cur

END
