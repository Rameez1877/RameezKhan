/****** Object:  Table [dbo].[RssFeed]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeed](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssSourceId] [int] NULL,
	[Title] [nvarchar](2000) NULL,
	[Link] [nvarchar](2048) NULL,
	[Description] [nvarchar](max) NULL,
	[Language] [varchar](50) NULL,
	[Category] [varchar](100) NULL,
	[Docs] [varchar](80) NULL,
	[Generator] [varchar](80) NULL,
	[ManagingEditor] [varchar](80) NULL,
	[Webmaster] [varchar](80) NULL,
	[Copyright] [varchar](500) NULL,
	[PubDate] [datetime] NULL,
	[LastBuildDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_RssFeed] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
