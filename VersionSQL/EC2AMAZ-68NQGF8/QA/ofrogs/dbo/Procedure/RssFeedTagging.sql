/****** Object:  Procedure [dbo].[RssFeedTagging]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RssFeedTagging] 
	@year varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @id int

	DECLARE cur CURSOR FOR SELECT id FROM rssfeeditem WHERE id 
	not in (SELECT distinct rssfeeditemid FROM rssfeeditemtag) and isactive = 1 and year(pubdate) = @year
	and validationdate is not null and news is not null

	OPEN cur

	FETCH NEXT FROM cur INTO @id

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC dbo.processrssfeeditem @id
		FETCH NEXT FROM cur INTO @id
	END

	CLOSE cur
	DEALLOCATE cur

END
