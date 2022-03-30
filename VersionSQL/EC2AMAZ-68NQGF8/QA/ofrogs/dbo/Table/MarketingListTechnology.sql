/****** Object:  Table [dbo].[MarketingListTechnology]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingListTechnology](
	[UserId] [int] NULL,
	[TargetPersonaId] [int] NULL,
	[Technology] [varchar](1000) NULL,
	[MarketingListId] [int] NULL
) ON [PRIMARY]
