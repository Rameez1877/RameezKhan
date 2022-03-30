/****** Object:  Table [dbo].[CompanyTechnologies]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CompanyTechnologies](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TagId] [int] NULL,
	[TechnologyName] [nvarchar](100) NULL,
	[Dated] [datetime] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CompanyTechnologies] ADD  CONSTRAINT [DF_Dated]  DEFAULT (getdate()) FOR [Dated]
