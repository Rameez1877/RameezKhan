/****** Object:  Table [dbo].[LeadScoreSubMarketingList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreSubMarketingList](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SubMarketingListName] [varchar](100) NULL,
	[CountryName] [varchar](100) NULL,
	[OrganizationID] [int] NOT NULL,
	[Revenue] [varchar](30) NULL,
	[BudgetScore] [int] NULL,
	[AuthorityScore] [int] NULL,
	[NeedScore] [int] NULL,
	[TimeScore] [int] NULL,
	[TYPE] [varchar](10) NOT NULL,
	[TotalScore] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LeadScoreSubMarketingList] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
