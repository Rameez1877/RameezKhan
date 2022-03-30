/****** Object:  Table [dbo].[contentoutput]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[contentoutput](
	[id] [int] NULL,
	[keyword] [varchar](200) NULL,
	[content] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
