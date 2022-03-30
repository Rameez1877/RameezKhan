/****** Object:  Procedure [dbo].[SaveRssFeed]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Anurag Gandhi
-- Create date: 01 Dec, 2016
-- Description:	Stored Procedure to Save and process RssFeed.//
-- =============================================
CREATE PROCEDURE [dbo].[SaveRssFeed]
	@RssSourceId int,
	@XmlData nvarchar(max),
	@DtmXml xml
AS
BEGIN
	SET NOCOUNT ON;

	declare @RssDataId int

	insert RssData(RssSourceId, XmlData) values(@RssSourceId, @XmlData)
	select @RssDataId = @@Identity

	exec [dbo].[ProcessRssData_2017_08_29] @RssDataId
END
