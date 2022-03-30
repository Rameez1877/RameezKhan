/****** Object:  Table [dbo].[Temp_Append_Keywords]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Temp_Append_Keywords](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Client] [varchar](max) NOT NULL,
	[Industry] [varchar](max) NOT NULL,
	[Functionality] [varchar](max) NOT NULL,
	[Designation] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[MainMarketingListName] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Temp_Append_Keywords] ADD  DEFAULT ('') FOR [Client]
ALTER TABLE [dbo].[Temp_Append_Keywords] ADD  DEFAULT ('') FOR [Industry]
ALTER TABLE [dbo].[Temp_Append_Keywords] ADD  DEFAULT ('') FOR [Functionality]
ALTER TABLE [dbo].[Temp_Append_Keywords] ADD  DEFAULT ('') FOR [Designation]
ALTER TABLE [dbo].[Temp_Append_Keywords] ADD  DEFAULT ((0)) FOR [IsActive]
