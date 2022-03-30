/****** Object:  Table [dbo].[StgOrganizationFundingDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StgOrganizationFundingDetail](
	[OrganizationName] [varchar](500) NOT NULL,
	[FundingStage] [varchar](20) NULL,
	[FundingDate] [date] NULL,
	[FundingLink] [varchar](500) NULL,
	[AmountRaised] [int] NOT NULL
) ON [PRIMARY]
