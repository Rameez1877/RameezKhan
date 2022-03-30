/****** Object:  Table [dbo].[Jobs]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Jobs](
	[RssFeedItemId] [int] NOT NULL,
	[JobLocation] [nvarchar](max) NULL,
	[SenorityLevel] [nvarchar](max) NULL,
	[OrganizationName] [nvarchar](max) NULL,
	[JobTitle] [nvarchar](max) NULL,
	[Functionality] [nvarchar](max) NULL,
	[Technology] [nvarchar](max) NULL,
	[Summary] [nvarchar](max) NULL,
	[JobCountry] [nvarchar](max) NULL,
	[JobSource] [nvarchar](max) NULL,
	[Inference] [nvarchar](max) NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[RssFeedItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
