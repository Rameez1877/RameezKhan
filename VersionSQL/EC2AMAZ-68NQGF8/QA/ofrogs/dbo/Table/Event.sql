/****** Object:  Table [dbo].[Event]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](4000) NULL,
	[AppUserId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[OrganizationId] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_StartDate]  DEFAULT (getdate()) FOR [StartDate]
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[Event]  WITH NOCHECK ADD  CONSTRAINT [FK_Event_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_Organization]
