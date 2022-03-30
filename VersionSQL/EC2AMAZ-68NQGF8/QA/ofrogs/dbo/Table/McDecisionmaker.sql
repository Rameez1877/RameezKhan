/****** Object:  Table [dbo].[McDecisionmaker]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[McDecisionmaker](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppUserId] [int] NOT NULL,
	[Name] [varchar](86) NULL,
	[IsActive] [bit] NOT NULL,
	[IsOFList] [int] NULL,
	[Keyword] [varchar](86) NULL,
	[MainMarketingListName] [varchar](100) NULL,
	[InsertedDate] [datetime] NULL,
	[AliasName] [varchar](100) NULL,
	[MarketingListType] [varchar](30) NULL,
	[IsInternalList] [bit] NOT NULL,
	[IntentTypeId] [int] NULL,
	[IsGoodKeyword] [bit] NULL,
	[IsTeams] [bit] NULL,
	[NeedHierarchyId] [int] NULL,
	[FunnelTypeId] [int] NULL,
	[IsSurgeSummary] [bit] NULL,
 CONSTRAINT [PK_McDecisionmaker] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
