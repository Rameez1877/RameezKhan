/****** Object:  Table [dbo].[datacontent]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[datacontent](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[datacontent] [varchar](max) NULL,
	[docname] [varchar](15) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
