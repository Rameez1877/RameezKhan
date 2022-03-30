/****** Object:  Table [dbo].[LinkedinApiAudit]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LinkedinApiAudit](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SearchKeyword] [varchar](max) NOT NULL,
	[InsertedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Marketinglist] [int] NOT NULL,
	[countryid] [varchar](max) NOT NULL,
	[appuserid] [int] NOT NULL,
	[kywdType] [varchar](max) NOT NULL,
	[tagid] [int] NOT NULL,
	[ServerName] [varchar](max) NULL,
	[ServerInstanceName] [varchar](max) NULL,
	[Deleted Time] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[LinkedinApiAudit] ADD  CONSTRAINT [DF__LinkedinAud__IsAct__41049384]  DEFAULT ((0)) FOR [IsActive]
ALTER TABLE [dbo].[LinkedinApiAudit] ADD  CONSTRAINT [DF__LinkedinAud__Marke__41F8B7BD]  DEFAULT ((0)) FOR [Marketinglist]
ALTER TABLE [dbo].[LinkedinApiAudit] ADD  DEFAULT ('') FOR [countryid]
ALTER TABLE [dbo].[LinkedinApiAudit] ADD  DEFAULT ((0)) FOR [appuserid]
ALTER TABLE [dbo].[LinkedinApiAudit] ADD  DEFAULT ('Keyword') FOR [kywdType]
ALTER TABLE [dbo].[LinkedinApiAudit] ADD  DEFAULT ((0)) FOR [tagid]
