/****** Object:  Table [dbo].[Message]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Message](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Title] [nvarchar](1000) NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[MessageTypeId] [int] NOT NULL,
	[ParentId] [int] NULL,
	[IndustryId] [int] NULL,
	[SubIndustryId] [int] NULL,
	[FunctionalityId] [int] NULL,
	[TechnologyId] [int] NULL,
	[HorizontalId] [int] NULL,
	[OrganizationId] [int] NULL,
	[CreatedById] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedById] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Functionality] FOREIGN KEY([FunctionalityId])
REFERENCES [dbo].[Functionality] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Functionality]
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Horizontal] FOREIGN KEY([HorizontalId])
REFERENCES [dbo].[Horizontal] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Horizontal]
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_MessageType] FOREIGN KEY([MessageTypeId])
REFERENCES [dbo].[MessageType] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_MessageType]
ALTER TABLE [dbo].[Message]  WITH NOCHECK ADD  CONSTRAINT [FK_Message_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Organization]
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_SubIndustry] FOREIGN KEY([SubIndustryId])
REFERENCES [dbo].[SubIndustry] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_SubIndustry]
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_Technology] FOREIGN KEY([TechnologyId])
REFERENCES [dbo].[Technology] ([Id])
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Technology]
