/****** Object:  Table [dbo].[Feedback]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Feedback](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Title] [nvarchar](2000) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[FeedbackTypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UserId] [int] NULL,
 CONSTRAINT [PK_Feedback] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD  CONSTRAINT [FK_Feedback_FeedbackType] FOREIGN KEY([FeedbackTypeId])
REFERENCES [dbo].[FeedbackType] ([Id])
ALTER TABLE [dbo].[Feedback] CHECK CONSTRAINT [FK_Feedback_FeedbackType]
