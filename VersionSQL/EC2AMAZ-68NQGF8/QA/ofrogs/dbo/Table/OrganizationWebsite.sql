/****** Object:  Table [dbo].[OrganizationWebsite]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationWebsite](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](500) NULL,
	[Website] [varchar](500) NULL,
	[Title] [varchar](7000) NULL,
	[Description] [varchar](7000) NULL,
	[keyword] [varchar](7000) NULL,
	[OrganizationID] [int] NULL,
	[FullWebsite] [varchar](500) NULL,
	[IsWebsitePulled] [varchar](10) NULL,
	[websiteMatchNomatch] [varchar](100) NULL,
	[pattern] [varchar](1000) NULL,
	[step] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationWebsite] ADD  DEFAULT ('N') FOR [IsWebsitePulled]
