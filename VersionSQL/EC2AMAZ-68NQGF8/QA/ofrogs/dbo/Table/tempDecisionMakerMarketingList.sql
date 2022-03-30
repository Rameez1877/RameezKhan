/****** Object:  Table [dbo].[tempDecisionMakerMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tempDecisionMakerMarketingList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketingListId] [int] NOT NULL,
	[DecisionMakerId] [int] NOT NULL,
	[LinkedInUrl] [varchar](500) NULL,
	[isNew] [bit] NULL
) ON [PRIMARY]
