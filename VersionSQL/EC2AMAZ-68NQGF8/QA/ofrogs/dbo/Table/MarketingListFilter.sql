/****** Object:  Table [dbo].[MarketingListFilter]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MarketingListFilter](
	[TargetPersonaID] [int] NOT NULL,
	[Location] [varchar](100) NOT NULL,
	[Seniority] [varchar](100) NOT NULL,
	[NoOfRecords] [int] NOT NULL,
	[Industry] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MarketingListFilter] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaID] ASC,
	[Location] ASC,
	[Industry] ASC,
	[Seniority] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
