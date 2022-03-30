/****** Object:  Table [dbo].[UserDeletedDecisionMakers]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserDeletedDecisionMakers](
	[UserID] [int] NOT NULL,
	[MarketingListId] [int] NOT NULL,
	[LinkedInId] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[Comment] [varchar](5000) NULL,
 CONSTRAINT [PK_UserDeletedDecisionMakers] PRIMARY KEY CLUSTERED 
(
	[MarketingListId] ASC,
	[LinkedInId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserDeletedDecisionMakers] ADD  DEFAULT (getdate()) FOR [InsertedDate]
