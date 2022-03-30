/****** Object:  Table [dbo].[IndustryAttributeScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustryAttributeScore](
	[IndustryID] [int] NULL,
	[AttributeID] [int] NULL,
	[ScorePer] [varchar](100) NULL,
	[Score] [float] NULL,
	[userid] [int] NULL
) ON [PRIMARY]
