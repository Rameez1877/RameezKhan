/****** Object:  Table [dbo].[JobHistory]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[JobHistory](
	[Id] [int] NOT NULL,
	[JobId] [int] NOT NULL,
	[JobStatusId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ErrorMessage] [varchar](5000) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_JobHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[JobHistory]  WITH CHECK ADD  CONSTRAINT [FK_JobHistory_Job] FOREIGN KEY([JobId])
REFERENCES [dbo].[Job] ([Id])
ALTER TABLE [dbo].[JobHistory] CHECK CONSTRAINT [FK_JobHistory_Job]
ALTER TABLE [dbo].[JobHistory]  WITH CHECK ADD  CONSTRAINT [FK_JobHistory_JobStatus] FOREIGN KEY([JobStatusId])
REFERENCES [dbo].[JobStatus] ([Id])
ALTER TABLE [dbo].[JobHistory] CHECK CONSTRAINT [FK_JobHistory_JobStatus]
