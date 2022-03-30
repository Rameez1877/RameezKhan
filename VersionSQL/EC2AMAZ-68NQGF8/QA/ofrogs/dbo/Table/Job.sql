/****** Object:  Table [dbo].[Job]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Job](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Description] [varchar](5000) NULL,
	[RssSourceId] [int] NOT NULL,
	[Interval] [int] NULL,
	[RecurrenceInfo] [varchar](500) NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Job]  WITH NOCHECK ADD  CONSTRAINT [FK_Job_RssSource] FOREIGN KEY([RssSourceId])
REFERENCES [dbo].[RssSource] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Job_RssSource]
