/****** Object:  Table [dbo].[linkedinapi_bing]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[linkedinapi_bing](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SearchKeyword] [varchar](max) NOT NULL,
	[InsertedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Marketinglist] [int] NOT NULL,
	[countryid] [varchar](max) NOT NULL,
	[appuserid] [int] NOT NULL,
	[kywdType] [varchar](max) NOT NULL,
	[tagid] [int] NOT NULL,
	[appPriority] [int] NOT NULL,
	[appBatch] [int] NOT NULL,
	[RunDate] [datetime] NULL,
	[isOverride] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[linkedinapi_bing] ADD  DEFAULT ((0)) FOR [isOverride]
