/****** Object:  Table [dbo].[IndeedRunHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndeedRunHistory](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TagName] [varchar](max) NULL,
	[LastRunDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
