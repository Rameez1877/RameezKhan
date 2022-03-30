/****** Object:  Table [dbo].[KeywordList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[KeywordList](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Keywords] [varchar](2500) NULL,
	[userid] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[name1] [varchar](500) NULL,
 CONSTRAINT [PK_KeywordList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[KeywordList] ADD  DEFAULT ((1)) FOR [IsActive]
