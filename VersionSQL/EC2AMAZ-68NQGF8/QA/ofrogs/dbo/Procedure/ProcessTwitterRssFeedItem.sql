/****** Object:  Procedure [dbo].[ProcessTwitterRssFeedItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProcessTwitterRssFeedItem] 
	-- Add the parameters for the stored procedure here
	@Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	delete from RssFeedItemTag where RssFeedItemId = @Id

	insert into RssFeedItemTag
	select RFI.Id,T.Id from tag T cross join rssfeeditem RFI where T.tagtypeid = 9 and RFI.Id = @Id 
	and ( RFI.Title like '%[^a-z0-9]' + T.Name + '[^a-z0-9]%' or RFI.Title like '%' + T.Name + '[^a-z0-9]%' or
	RFI.Title like '%[^a-z0-9]' + T.Name + '%' or RFI.Title like '%' + T.Name + '%')

	insert into RssFeedItemTag
	select RFI.Id,T.Id from tag T cross join rssfeeditem RFI where T.tagtypeid = 10 and RFI.Id = @Id 
	and ( RFI.Description like '%[^a-z0-9]' + T.Name + '[^a-z0-9]%' or RFI.Description like '%' + T.Name + '[^a-z0-9]%' or
	RFI.Description like '%[^a-z0-9]' + T.Name + '%' or RFI.Description like '%' + T.Name + '%')
END
