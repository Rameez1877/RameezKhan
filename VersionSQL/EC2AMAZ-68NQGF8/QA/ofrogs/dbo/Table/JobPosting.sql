/****** Object:  Table [dbo].[JobPosting]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobPosting](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JobTitle] [nvarchar](1024) NULL,
	[JobURL] [nvarchar](max) NULL,
	[JobLocation] [nvarchar](500) NULL,
	[Organization] [nvarchar](500) NULL,
	[CreateDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[JobPublishedDate] [nvarchar](2000) NULL,
	[JobPublicationDate] [datetime] NULL,
	[JobDescription] [nvarchar](max) NULL,
	[OrganizationId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
