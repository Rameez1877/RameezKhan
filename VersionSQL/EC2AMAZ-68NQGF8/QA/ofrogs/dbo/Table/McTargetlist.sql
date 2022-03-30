/****** Object:  Table [dbo].[McTargetlist]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[McTargetlist](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppUserId] [int] NOT NULL,
	[TargetId] [int] NULL,
	[TargetlistName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[Name] [varchar](max) NOT NULL,
 CONSTRAINT [PK_McTargetlist] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[McTargetlist] ADD  DEFAULT ('') FOR [Name]
ALTER TABLE [dbo].[McTargetlist]  WITH NOCHECK ADD  CONSTRAINT [Fk_McTargetlist_Organization] FOREIGN KEY([TargetId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[McTargetlist] CHECK CONSTRAINT [Fk_McTargetlist_Organization]
