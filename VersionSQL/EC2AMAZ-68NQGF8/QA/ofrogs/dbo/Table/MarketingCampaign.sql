/****** Object:  Table [dbo].[MarketingCampaign]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingCampaign](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](max) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[AppUserId] [int] NOT NULL,
	[TargetName] [varchar](max) NULL,
	[SignalName] [varchar](max) NULL,
	[DecisionmakerName] [varchar](max) NULL,
	[MinTicketSize] [float] NOT NULL,
	[MaxTicketSize] [float] NOT NULL,
	[LeadConversion] [float] NOT NULL,
 CONSTRAINT [PK_MarketingCampaign] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[MarketingCampaign] ADD  DEFAULT ((0.0)) FOR [MinTicketSize]
ALTER TABLE [dbo].[MarketingCampaign] ADD  DEFAULT ((0.0)) FOR [MaxTicketSize]
ALTER TABLE [dbo].[MarketingCampaign] ADD  DEFAULT ((0.0)) FOR [LeadConversion]
