/****** Object:  Table [dbo].[datacontentsections]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[datacontentsections](
	[id] [int] NULL,
	[section] [varchar](20) NULL,
	[sectioncontent] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
