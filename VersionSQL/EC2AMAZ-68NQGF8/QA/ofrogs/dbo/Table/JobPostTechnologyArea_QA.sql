/****** Object:  Table [dbo].[JobPostTechnologyArea_QA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobPostTechnologyArea_QA](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[JobPostID] [int] NOT NULL,
	[Technology] [varchar](100) NULL,
	[TechnologyCategory] [varchar](100) NULL,
	[CountryID] [int] NULL,
	[JobDate] [date] NULL,
	[Organization] [varchar](200) NULL,
	[InsertedDate] [datetime] NULL,
	[NoOfDays] [int] NULL,
	[TagIdOrganization] [int] NULL,
	[TagIdKeyword] [int] NULL,
	[TechnologyUsedBy] [varchar](10) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[JobPostTechnologyArea_QA] ADD  CONSTRAINT [DF_JobPostTechnologyArea]  DEFAULT (getdate()) FOR [InsertedDate]
