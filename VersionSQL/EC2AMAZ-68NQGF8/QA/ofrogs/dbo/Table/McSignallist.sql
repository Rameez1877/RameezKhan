/****** Object:  Table [dbo].[McSignallist]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[McSignallist](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppUserId] [int] NOT NULL,
	[SignalId] [int] NULL,
	[SignallistName] [varchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[Name] [varchar](max) NOT NULL,
 CONSTRAINT [PK_McSignallist] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[McSignallist] ADD  DEFAULT ('') FOR [Name]
ALTER TABLE [dbo].[McSignallist]  WITH NOCHECK ADD  CONSTRAINT [Fk_McSignallist_Tag] FOREIGN KEY([SignalId])
REFERENCES [dbo].[Tag] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[McSignallist] CHECK CONSTRAINT [Fk_McSignallist_Tag]
