/****** Object:  Table [dbo].[MarketingLists]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingLists](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TargetPersonaId] [int] NOT NULL,
	[MarketingListName] [varchar](250) NOT NULL,
	[TotalAccounts] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[TotalDecisionMakers] [int] NULL,
	[Locations] [varchar](2000) NULL,
	[Functionality] [varchar](5000) NULL,
	[Seniority] [varchar](250) NULL,
 CONSTRAINT [PK_MarketingLists] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MarketingLists] ADD  CONSTRAINT [DF_MarketingLists_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]
