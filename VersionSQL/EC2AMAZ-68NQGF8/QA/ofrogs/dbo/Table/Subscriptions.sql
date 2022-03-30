/****** Object:  Table [dbo].[Subscriptions]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Subscriptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[EndDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[NumberOfNudges] [int] NULL,
	[NumberOfAccounts] [int] NULL,
	[NumberOfContacts] [int] NULL,
	[TechnologyIntelligence] [bit] NULL,
	[AccountScoring] [bit] NULL,
	[SecondaryResearchBasedIntent] [bit] NULL,
	[TouchPoints] [bit] NULL,
	[CRMIntegration] [bit] NULL,
	[OneHrConsultancy] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
