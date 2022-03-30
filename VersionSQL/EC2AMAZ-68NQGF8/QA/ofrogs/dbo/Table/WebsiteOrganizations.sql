/****** Object:  Table [dbo].[WebsiteOrganizations]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrganizations](
	[OrganizationId] [int] NULL,
	[OrganizationName] [nvarchar](255) NULL,
	[TransformedName] [varchar](200) NULL,
	[Description] [varchar](4000) NULL,
	[Revenue] [varchar](200) NULL,
	[IndustryName] [varchar](200) NULL,
	[EmployeeCount] [varchar](50) NULL,
	[CountryName] [varchar](100) NULL,
	[WebsiteUrl] [varchar](500) NULL
) ON [PRIMARY]
