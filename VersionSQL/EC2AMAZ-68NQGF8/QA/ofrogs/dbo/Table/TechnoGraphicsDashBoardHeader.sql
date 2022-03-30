/****** Object:  Table [dbo].[TechnoGraphicsDashBoardHeader]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TechnoGraphicsDashBoardHeader](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Technology] [nvarchar](100) NULL,
	[NoOfCompany] [int] NULL,
	[NoOfCountry] [int] NULL,
	[NoOfIndustry] [int] NULL,
 CONSTRAINT [PK_TechnoGraphicsDashBoardHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IDX_TechnoGraphicsDashBoardHeader] ON [dbo].[TechnoGraphicsDashBoardHeader]
(
	[Technology] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
