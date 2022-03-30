/****** Object:  Table [dbo].[tmp_Non_English_New]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tmp_Non_English_New](
	[title] [nvarchar](80) NULL,
	[link] [nvarchar](200) NULL,
	[description] [nvarchar](max) NULL,
	[pubdate] [datetime] NULL,
	[Guid] [varchar](80) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
