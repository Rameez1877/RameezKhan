/****** Object:  Procedure [dbo].[SaveJobSource]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 4 Jul, 2016
-- Description:	Stored procedure to save organization and do the mapping for Industry, and Tag
-- =============================================
CREATE PROCEDURE [dbo].[SaveJobSource] 
	@Name nvarchar(1000),
	@IndustryId	int
	
AS
BEGIN
	SET NOCOUNT ON;


			
			insert RssSource (Name, [Url], IndustryId, [Description], Tags, CreatedById, CreatedDate, UpdatedById, UpdatedDate, IsActive, SourceTypeId, 
				rssTypeId, IsValid, ValidateDate) VALUES
			('indeed job' + @Name, 'http://www.indeed.com/rss?q=' + replace(@Name, ' ', '%20') + '&output=rss' , 
				@IndustryId, null, null, 1, getdate(), null, null, 1, 1, 3, null, null)
			
		    End
