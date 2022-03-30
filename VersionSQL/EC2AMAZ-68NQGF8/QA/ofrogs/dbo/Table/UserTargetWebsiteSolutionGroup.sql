/****** Object:  Table [dbo].[UserTargetWebsiteSolutionGroup]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserTargetWebsiteSolutionGroup](
	[UserID] [int] NOT NULL,
	[WebsiteSolutionGroupID] [int] NOT NULL,
 CONSTRAINT [PK_UserTargetWebsiteSolutionGroup] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[WebsiteSolutionGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
