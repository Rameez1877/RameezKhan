/****** Object:  Table [dbo].[RssFeedItem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeedItem](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedId] [int] NOT NULL,
	[Title] [nvarchar](4000) NULL,
	[Link] [varchar](2048) NULL,
	[Description] [nvarchar](max) NULL,
	[PubDate] [datetime] NULL,
	[Guid] [varchar](5000) NULL,
	[RootWords] [nvarchar](max) NULL,
	[Tags] [nvarchar](4000) NULL,
	[IsActive] [bit] NOT NULL,
	[StatusId] [int] NOT NULL,
	[News] [varchar](max) NULL,
	[WordCount] [int] NULL,
	[ValidationDate] [datetime] NULL,
	[tagStatus] [int] NULL,
	[tagid] [int] NOT NULL,
 CONSTRAINT [PK_RssFeedItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
