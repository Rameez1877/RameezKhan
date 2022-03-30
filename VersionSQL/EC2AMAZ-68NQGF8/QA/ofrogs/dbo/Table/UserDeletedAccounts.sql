/****** Object:  Table [dbo].[UserDeletedAccounts]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserDeletedAccounts](
	[UserID] [int] NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[Comment] [varchar](5000) NULL,
 CONSTRAINT [PK_UserDeletedAccounts] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[UserDeletedAccounts] ADD  DEFAULT (getdate()) FOR [InsertedDate]
