/****** Object:  Table [dbo].[DecisionMakersForMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DecisionMakersForMarketingList](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MarketingListId] [int] NOT NULL,
	[DecisionMakerId] [int] NOT NULL,
	[LinkedInUrl] [varchar](500) NULL,
	[isNew] [bit] NULL,
	[Gender] [varchar](1) NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[Name] [varchar](100) NULL,
	[Designation] [varchar](400) NULL,
	[SeniorityLevel] [varchar](400) NULL,
	[OrganizationId] [int] NULL,
	[EmailId] [varchar](150) NULL,
	[Country] [varchar](100) NULL,
	[Functionality] [varchar](100) NULL,
	[Phone] [varchar](100) NULL,
	[EmailGeneratedDate] [datetime] NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [idx_DecisionMakersForMarketingList] ON [dbo].[DecisionMakersForMarketingList]
(
	[MarketingListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_INEXES2] ON [dbo].[DecisionMakersForMarketingList]
(
	[MarketingListId] ASC
)
INCLUDE([DecisionMakerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[DecisionMakersForMarketingList] ADD  DEFAULT ((0)) FOR [isNew]
