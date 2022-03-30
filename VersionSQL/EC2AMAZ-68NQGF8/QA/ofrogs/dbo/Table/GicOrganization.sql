/****** Object:  Table [dbo].[GicOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GicOrganization](
	[CountryID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
 CONSTRAINT [PK_GicOrganization] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC,
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
