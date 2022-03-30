/****** Object:  Table [dbo].[StgOrganizationFunding]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StgOrganizationFunding](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationName] [varchar](500) NOT NULL,
	[ProfileURL] [varchar](500) NOT NULL,
	[Signal] [int] NOT NULL,
	[JoinDate] [varchar](10) NOT NULL,
	[Location] [varchar](100) NOT NULL,
	[Market] [varchar](100) NULL,
	[Website] [varchar](500) NOT NULL,
	[Employees] [varchar](100) NULL,
	[Stage] [varchar](50) NULL,
	[TotalRaised] [int] NULL,
	[OrganizationID] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
	[IsProcessed] [bit] NULL,
	[IsFundingDetailPulled] [bit] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[StgOrganizationFunding] ADD  DEFAULT (getdate()) FOR [InsertedDate]
ALTER TABLE [dbo].[StgOrganizationFunding] ADD  DEFAULT ((0)) FOR [IsProcessed]
ALTER TABLE [dbo].[StgOrganizationFunding] ADD  DEFAULT ((0)) FOR [IsFundingDetailPulled]
