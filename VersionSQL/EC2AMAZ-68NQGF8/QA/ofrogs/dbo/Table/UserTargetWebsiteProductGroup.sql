/****** Object:  Table [dbo].[UserTargetWebsiteProductGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTargetWebsiteProductGroup](
	[UserID] [int] NOT NULL,
	[WebsiteProductGroupID] [int] NOT NULL,
 CONSTRAINT [PK_UserTargetWebsiteProductGroup] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[WebsiteProductGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
