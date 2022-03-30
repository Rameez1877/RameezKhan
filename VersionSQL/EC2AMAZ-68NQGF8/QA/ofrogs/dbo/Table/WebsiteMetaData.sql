/****** Object:  Table [dbo].[WebsiteMetaData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteMetaData](
	[DomainName] [nvarchar](255) NULL,
	[MetaData] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
