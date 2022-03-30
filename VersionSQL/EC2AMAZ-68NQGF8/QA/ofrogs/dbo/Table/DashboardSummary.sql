/****** Object:  Table [dbo].[DashboardSummary]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DashboardSummary](
	[Id] [int] NULL,
	[Name] [varchar](100) NULL,
	[WebsiteUrl] [varchar](500) NULL,
	[EmployeeCount] [varchar](100) NULL,
	[Revenue] [varchar](100) NULL,
	[IndustryID] [int] NULL,
	[IndustryName] [varchar](100) NULL,
	[CountryId] [int] NULL,
	[CountryName] [varchar](200) NULL,
	[Technology] [varchar](100) NULL,
	[StackType] [varchar](100) NULL,
	[Functionality] [varchar](100) NULL,
	[InvestmentType] [varchar](100) NULL,
	[TeamName] [varchar](100) NULL,
	[WebSiteDescription] [varchar](8000) NULL,
	[UserID] [int] NULL,
	[Notes] [varchar](5000) NULL
) ON [PRIMARY]
