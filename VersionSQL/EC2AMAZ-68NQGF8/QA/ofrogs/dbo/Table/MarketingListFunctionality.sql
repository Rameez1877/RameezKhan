/****** Object:  Table [dbo].[MarketingListFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingListFunctionality](
	[UserId] [int] NULL,
	[TargetPersonaId] [int] NULL,
	[Functionality] [varchar](1000) NULL,
	[MarketingListId] [int] NULL
) ON [PRIMARY]
