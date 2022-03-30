/****** Object:  Table [dbo].[IndeedUrlDummy]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndeedUrlDummy](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IndeedUrl] [varchar](max) NULL,
	[CountryName] [varchar](max) NULL,
	[CountryId] [numeric](18, 0) NULL,
	[UrlType] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
