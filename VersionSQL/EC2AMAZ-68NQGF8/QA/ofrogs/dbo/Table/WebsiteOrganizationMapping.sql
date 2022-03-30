/****** Object:  Table [dbo].[WebsiteOrganizationMapping]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[WebsiteOrganizationMapping](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NULL,
	[WebsiteUrl] [varchar](500) NULL,
	[OrganizationName] [varchar](100) NOT NULL,
	[IsProcessed] [bit] NOT NULL,
	[NewWebsiteUrl] [varchar](600) NULL,
	[WebSiteId] [int] NULL,
 CONSTRAINT [PK_WebsiteOrganizationMapping] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
