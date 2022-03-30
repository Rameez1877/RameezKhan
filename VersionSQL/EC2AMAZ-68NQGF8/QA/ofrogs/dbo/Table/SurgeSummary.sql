/****** Object:  Table [dbo].[SurgeSummary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SurgeSummary](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NULL,
	[Organization] [varchar](500) NULL,
	[IndustryID] [int] NULL,
	[Industry] [varchar](500) NULL,
	[Functionality] [varchar](100) NULL,
	[Technology] [varchar](100) NULL,
	[InvestmentType] [varchar](30) NULL,
	[CountryID] [int] NULL,
	[CountryName] [varchar](100) NOT NULL,
	[Duration] [int] NULL,
	[Surge] [int] NULL,
	[NoOfDecisionMaker] [int] NULL,
	[Revenue] [varchar](20) NULL,
	[EmployeeCount] [varchar](20) NULL,
	[TechnologyCategory] [varchar](100) NULL,
	[SpendEstimate] [varchar](100) NULL,
	[TechSpentEstimate] [int] NULL,
 CONSTRAINT [PK_SurgeSummary] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
