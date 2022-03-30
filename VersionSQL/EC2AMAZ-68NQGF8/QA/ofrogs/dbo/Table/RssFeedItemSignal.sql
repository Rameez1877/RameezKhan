/****** Object:  Table [dbo].[RssFeedItemSignal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RssFeedItemSignal](
	[RssFeedItemId] [int] NOT NULL,
	[SignalId] [int] NOT NULL,
	[SignalWord] [nvarchar](50) NULL,
	[IndustryId] [int] NULL,
	[TagId] [int] NULL,
	[ScoreDate] [date] NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_RssFeedItemSignal] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
