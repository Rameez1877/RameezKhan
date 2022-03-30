/****** Object:  Table [dashboard].[OrgStatistics]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dashboard].[OrgStatistics](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Year] [date] NOT NULL,
	[Value] [decimal](16, 2) NOT NULL,
	[Parameter] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dashboard].[OrgStatistics]  WITH NOCHECK ADD  CONSTRAINT [Fk_OrgStatistics_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dashboard].[OrgStatistics] CHECK CONSTRAINT [Fk_OrgStatistics_Organization]
