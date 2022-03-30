/****** Object:  Table [dbo].[JobInstance]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobInstance](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[JobId] [int] NOT NULL,
	[JobStatusId] [int] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[ErrorMessage] [varchar](5000) NULL,
 CONSTRAINT [PK_JobInstance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JobInstance]  WITH CHECK ADD  CONSTRAINT [FK_JobInstance_Job] FOREIGN KEY([JobId])
REFERENCES [dbo].[Job] ([Id])
ALTER TABLE [dbo].[JobInstance] CHECK CONSTRAINT [FK_JobInstance_Job]
ALTER TABLE [dbo].[JobInstance]  WITH CHECK ADD  CONSTRAINT [FK_JobInstance_JobStatus] FOREIGN KEY([JobStatusId])
REFERENCES [dbo].[JobStatus] ([Id])
ALTER TABLE [dbo].[JobInstance] CHECK CONSTRAINT [FK_JobInstance_JobStatus]
