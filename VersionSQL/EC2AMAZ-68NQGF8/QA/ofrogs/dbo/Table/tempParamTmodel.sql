/****** Object:  Table [dbo].[tempParamTmodel]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tempParamTmodel](
	[TPrunID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[burnin] [int] NOT NULL,
	[iter] [int] NOT NULL,
	[thin] [int] NOT NULL,
	[seed01] [int] NOT NULL,
	[seed02] [int] NOT NULL,
	[seed03] [int] NOT NULL,
	[seed04] [int] NOT NULL,
	[seed05] [int] NOT NULL,
	[nstart] [int] NOT NULL,
	[best_bin] [bit] NOT NULL,
	[NumOfTopicsK] [int] NOT NULL,
	[IndustryIDs] [varchar](45) NOT NULL,
	[RunTS] [datetime] NOT NULL,
	[RSSpubDT] [date] NULL,
	[RSSscore] [int] NULL,
	[wordInTopic] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TPrunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('4000') FOR [burnin]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('2000') FOR [iter]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('500') FOR [thin]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('2003') FOR [seed01]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('5') FOR [seed02]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('63') FOR [seed03]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('100001') FOR [seed04]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('765') FOR [seed05]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('5') FOR [nstart]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('TRUE') FOR [best_bin]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ('10') FOR [NumOfTopicsK]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT (getdate()) FOR [RunTS]
ALTER TABLE [dbo].[tempParamTmodel] ADD  DEFAULT ((10)) FOR [wordInTopic]
