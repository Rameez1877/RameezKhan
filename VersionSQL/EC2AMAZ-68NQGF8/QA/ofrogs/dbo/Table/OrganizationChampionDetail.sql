/****** Object:  Table [dbo].[OrganizationChampionDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationChampionDetail](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[LinkedinId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[TrackedOrganizationId] [int] NOT NULL,
	[ProfileName] [varchar](250) NOT NULL,
	[Designation] [varchar](300) NULL,
	[OrganizationName] [varchar](500) NULL,
	[UserID] [int] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
	[Url] [varchar](500) NOT NULL,
	[Gender] [varchar](1) NULL,
	[OrganizationChampionID] [int] NOT NULL,
	[IsChampion] [bit] NOT NULL,
	[Country] [varchar](100) NULL,
	[NoOfChampion] [int] NULL,
 CONSTRAINT [PK_OrganizationChampionDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_OrganizationChampionDetail] ON [dbo].[OrganizationChampionDetail]
(
	[OrganizationChampionID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[OrganizationChampionDetail] ADD  DEFAULT ((0)) FOR [IsChampion]
ALTER TABLE [dbo].[OrganizationChampionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_OCD_OrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationChampionDetail] CHECK CONSTRAINT [FK_OCD_OrganizationId]
ALTER TABLE [dbo].[OrganizationChampionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_OCD_TrackedOrganizationId] FOREIGN KEY([TrackedOrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationChampionDetail] CHECK CONSTRAINT [FK_OCD_TrackedOrganizationId]
