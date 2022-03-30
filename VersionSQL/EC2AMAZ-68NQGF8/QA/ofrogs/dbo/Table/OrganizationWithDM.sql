/****** Object:  Table [dbo].[OrganizationWithDM]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationWithDM](
	[organizationid] [int] NULL,
	[CountryID] [int] NULL,
	[Name] [varchar](1000) NULL,
	[Description] [varchar](4000) NULL,
	[WebsiteUrl] [varchar](4000) NULL,
	[CountryName] [varchar](4000) NULL,
	[IndustryName] [varchar](4000) NULL,
	[Revenue] [varchar](4000) NULL,
	[EmployeeCount] [varchar](4000) NULL,
	[IndustryId] [int] NULL,
	[glassdoordescription] [varchar](4000) NULL
) ON [PRIMARY]
