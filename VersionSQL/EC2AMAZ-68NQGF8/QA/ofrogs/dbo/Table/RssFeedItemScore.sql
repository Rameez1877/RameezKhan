/****** Object:  Table [dbo].[RssFeedItemScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeedItemScore](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RssFeedItemId] [int] NOT NULL,
	[Score] [int] NULL,
	[TagName] [nvarchar](500) NULL,
	[IndustryName] [nvarchar](500) NULL,
	[UpdateDate] [datetime] NULL,
	[TagId] [int] NULL,
	[IndustryId] [int] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_RssFeedItemScore] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__RssFeedI__79A59AAFFFDC9980] UNIQUE NONCLUSTERED 
(
	[RssFeedItemId] ASC,
	[TagId] ASC,
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
