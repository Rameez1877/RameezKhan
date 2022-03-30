/****** Object:  Table [dbo].[OrgStatisticsIndustryAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrgStatisticsIndustryAttributes](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[industryId] [int] NOT NULL,
	[AttributeName] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[OrgStatisticsIndustryAttributes] ADD  CONSTRAINT [DF__OrgStatis__indus__2DF1BF10]  DEFAULT ((0)) FOR [industryId]
ALTER TABLE [dbo].[OrgStatisticsIndustryAttributes] ADD  CONSTRAINT [DF__OrgStatis__Attri__2EE5E349]  DEFAULT ('') FOR [AttributeName]
