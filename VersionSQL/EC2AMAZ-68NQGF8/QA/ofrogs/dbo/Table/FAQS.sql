/****** Object:  Table [dbo].[FAQS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FAQS](
	[ID] [int] NULL,
	[Screen] [varchar](200) NULL,
	[Question] [varchar](5000) NULL,
	[Answer] [varchar](5000) NULL,
	[UserStatus] [varchar](100) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
