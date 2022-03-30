/****** Object:  Table [dbo].[TechnoGraphicsDashBoardDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TechnoGraphicsDashBoardDetail](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SectionName] [varchar](50) NULL,
	[Technology] [varchar](100) NULL,
	[DataValue] [varchar](100) NULL,
	[PercentValue] [decimal](10, 2) NULL,
	[OrderNumber] [int] NULL,
 CONSTRAINT [PK_TechnoGraphicsDashBoardDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
