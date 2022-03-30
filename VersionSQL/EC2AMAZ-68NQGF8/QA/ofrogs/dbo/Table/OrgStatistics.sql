/****** Object:  Table [dbo].[OrgStatistics]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrgStatistics](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TagId] [int] NOT NULL,
	[Year] [varchar](max) NOT NULL,
	[IndustryAttributeId] [int] NULL,
	[Value] [float] NOT NULL,
	[UOM] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[OrgStatistics] ADD  CONSTRAINT [DF__OrgStatis__TagId__396371BC]  DEFAULT ((0)) FOR [TagId]
ALTER TABLE [dbo].[OrgStatistics] ADD  CONSTRAINT [DF__OrgStatist__Year__3A5795F5]  DEFAULT ('') FOR [Year]
ALTER TABLE [dbo].[OrgStatistics] ADD  CONSTRAINT [DF__OrgStatis__Value__3C3FDE67]  DEFAULT ((0)) FOR [Value]
ALTER TABLE [dbo].[OrgStatistics] ADD  CONSTRAINT [DF__OrgStatisti__UOM__3D3402A0]  DEFAULT ('') FOR [UOM]
