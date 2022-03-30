/****** Object:  Table [dbo].[PartnerDashboardData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PartnerDashboardData](
	[OrganizationID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[IndustryID] [int] NOT NULL,
	[Revenue] [varchar](50) NULL,
	[PartnerType] [varchar](500) NULL,
	[EmployeeCount] [varchar](50) NULL,
	[ProductAndSolutionID] [int] NOT NULL,
	[Product= 0 & Solution= 1] [bit] NULL,
	[TeamName] [varchar](200) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
