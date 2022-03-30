/****** Object:  Table [dbo].[GICDashboardOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GICDashboardOrganization](
	[OrganizationID] [int] NOT NULL,
	[Revenue] [varchar](50) NULL,
	[EmployeeCount] [varchar](50) NULL,
	[HeadquarterID] [int] NULL,
	[GIC_CountryID] [int] NOT NULL,
	[IndustryId] [int] NULL
) ON [PRIMARY]
