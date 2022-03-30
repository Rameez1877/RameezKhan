/****** Object:  Table [dbo].[MoblieAppDashboard]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MoblieAppDashboard](
	[AppID] [int] NOT NULL,
	[OrganizationID] [int] NULL,
	[Revenue] [varchar](50) NULL,
	[EmployeeCount] [varchar](50) NULL,
	[CountryID] [int] NULL,
	[IndustryID] [int] NULL,
	[AppCategoryID] [int] NULL,
	[InstallsNewFormat] [varchar](6) NULL,
	[InstallsOldFormat] [varchar](2000) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
