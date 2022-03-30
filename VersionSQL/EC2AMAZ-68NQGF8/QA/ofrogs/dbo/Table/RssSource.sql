/****** Object:  Table [dbo].[RssSource]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssSource](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[Url] [nvarchar](2500) NOT NULL,
	[IndustryId] [int] NULL,
	[Description] [varchar](5000) NULL,
	[Tags] [nvarchar](3000) NULL,
	[CreatedById] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedById] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[SourceTypeId] [int] NULL,
	[rssTypeId] [int] NULL,
	[IsValid] [bit] NULL,
	[ValidateDate] [datetime] NULL,
 CONSTRAINT [PK_RssSource] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RssSource] ADD  CONSTRAINT [DF_RssSource_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[RssSource] ADD  CONSTRAINT [DF_RssSource_IsActive]  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[RssSource] ADD  CONSTRAINT [DF_RssSource_rssTypeId]  DEFAULT ((1)) FOR [rssTypeId]
ALTER TABLE [dbo].[RssSource]  WITH NOCHECK ADD  CONSTRAINT [FK_RssSource_SourceType] FOREIGN KEY([SourceTypeId])
REFERENCES [dbo].[SourceType] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[RssSource] CHECK CONSTRAINT [FK_RssSource_SourceType]
