/****** Object:  Procedure [dbo].[tagInsertion]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,Mohit Shah>
-- Create date: <Create Date,12-04-2017>
-- Description:	<Description,Inserts data into 3 tables namely Tag,IndustryTag,RssSource>
-- =============================================
CREATE PROCEDURE tagInsertion 
	-- Add the parameters for the stored procedure here
	@tagName varchar(100),@tagTypeId int,@industryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DECLARE @tagId INT;

	Insert into dbo.Tag Values(@tagName,@tagTypeId,NULL);

	SET @tagId = @@identity;

	Insert into dbo.IndustryTag Values(@industryId,@tagId);

	insert RssSource(Name, [Url], IndustryId, [Description], Tags, CreatedById, 
	CreatedDate, UpdatedById, UpdatedDate, IsActive, SourceTypeId, rssType, IsValid, ValidateDate)
			values(@tagName, 'https://news.google.com/news/feeds?pz=1&cf=all&ned=en&hl=COUNTRY&q=' + 
			replace(@tagName, ' ', '+') + '&output=rss',@industryId,@tagName, null, 1, 
			getdate(), null, null, 1, 1, null, null, null)
			
END
