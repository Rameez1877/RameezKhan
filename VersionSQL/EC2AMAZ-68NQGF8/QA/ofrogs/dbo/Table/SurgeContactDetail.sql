/****** Object:  Table [dbo].[SurgeContactDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SurgeContactDetail](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserId] [int] NOT NULL,
	[LinkedinId] [int] NULL,
	[Name] [varchar](200) NOT NULL,
	[Designation] [varchar](500) NOT NULL,
	[EmailId] [varchar](200) NULL,
	[Phone] [varchar](200) NULL,
	[domain] [varchar](100) NULL,
	[ConfidenceScore] [int] NULL,
	[GeneratedBy] [varchar](20) NULL,
	[EmailGeneratedDate] [datetime] NULL,
	[Url] [varchar](200) NULL,
	[Functionality] [varchar](200) NULL,
	[Organization] [varchar](200) NULL,
	[Location] [varchar](200) NULL,
	[Gender] [varchar](10) NULL,
	[RocketreachOrganization] [varchar](300) NULL,
	[RocketreachDesignation] [varchar](500) NULL,
	[RocketreachLocation] [varchar](500) NULL,
	[Source] [varchar](50) NULL,
	[SeniorityLevel] [varchar](25) NULL,
	[PersonalEmail] [varchar](200) NULL,
	[isNew] [bit] NULL,
	[WorkOrderId] [int] NULL,
	[SnapShotId] [bigint] NULL,
	[OrganizationId] [int] NULL,
	[UniqueId] [int] NULL,
	[OptOut] [varchar](20) NULL,
	[CompanyPhone] [varchar](500) NULL,
 CONSTRAINT [primary_key] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_SurgeContactDetailUserIDLinkedinDataUrlUNIQUE] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[Url] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
