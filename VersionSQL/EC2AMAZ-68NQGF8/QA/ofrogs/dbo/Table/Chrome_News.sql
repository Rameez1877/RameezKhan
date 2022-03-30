/****** Object:  Table [dbo].[Chrome_News]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Chrome_News](
	[Title] [varchar](max) NULL,
	[Link] [varchar](max) NULL,
	[TagId] [int] NULL,
	[Tag] [varchar](max) NULL,
	[PubDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
