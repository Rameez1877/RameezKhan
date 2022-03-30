/****** Object:  Table [dbo].[ContactListGraphDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ContactListGraphDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MarketingListId] [int] NULL,
	[FilterType] [varchar](50) NULL,
	[DataValues] [varchar](500) NULL,
	[RecordCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
