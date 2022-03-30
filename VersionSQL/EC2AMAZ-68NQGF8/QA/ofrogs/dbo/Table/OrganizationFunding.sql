/****** Object:  Table [dbo].[OrganizationFunding]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationFunding](
	[ID] [int] NULL,
	[OrganizationID] [int] NULL,
	[MarketID] [int] NULL,
	[Signal] [int] NOT NULL,
	[Location] [varchar](100) NOT NULL,
	[StageID] [int] NULL,
	[TotalRaised] [int] NULL,
	[InsertedDate] [datetime] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationFunding] ADD  DEFAULT (getdate()) FOR [InsertedDate]
ALTER TABLE [dbo].[OrganizationFunding]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationFundingMarketID] FOREIGN KEY([MarketID])
REFERENCES [dbo].[FundingMarket] ([Id])
ALTER TABLE [dbo].[OrganizationFunding] CHECK CONSTRAINT [FK_OrganizationFundingMarketID]
ALTER TABLE [dbo].[OrganizationFunding]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationFundingStageID] FOREIGN KEY([StageID])
REFERENCES [dbo].[FundingStage] ([Id])
ALTER TABLE [dbo].[OrganizationFunding] CHECK CONSTRAINT [FK_OrganizationFundingStageID]
