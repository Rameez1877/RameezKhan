/****** Object:  Table [dbo].[holddup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[holddup](
	[title] [nvarchar](4000) NULL,
	[description] [nvarchar](max) NULL,
	[link] [varchar](2048) NULL,
	[guid] [varchar](5000) NULL,
	[pubdate] [datetime] NULL,
	[Tags] [nvarchar](4000) NULL,
	[rootwords] [nvarchar](max) NULL,
	[tagstatus] [bit] NULL,
	[isactive] [bit] NOT NULL,
	[statusid] [int] NOT NULL,
	[wordcount] [int] NULL,
	[news] [varchar](max) NULL,
	[ValidationDate] [datetime] NULL,
	[id] [int] NULL,
	[rssfeedid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
