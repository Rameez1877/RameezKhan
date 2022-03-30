/****** Object:  Table [dbo].[OutputIndustrySignalAnalyses]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OutputIndustrySignalAnalyses](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RegionName] [varchar](100) NULL,
	[ContinentName] [varchar](100) NULL,
	[CountryName] [varchar](100) NULL,
	[IndustryId] [int] NULL,
	[rssFeedItemId] [int] NULL,
	[tagId] [int] NULL,
	[tagName] [varchar](100) NULL,
	[DisplayName] [varchar](50) NULL,
	[signalWord] [varchar](200) NULL,
	[NewsQuarter] [varchar](60) NULL,
	[title] [varchar](500) NULL,
	[link] [varchar](500) NULL,
	[PubDate] [date] NULL,
 CONSTRAINT [PK__OutputIn__3213E83F1ABE41F1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
