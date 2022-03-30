/****** Object:  Table [InboundCRM].[InboundLinkedinAPI]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [InboundCRM].[InboundLinkedinAPI](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[searchKeyword] [varchar](100) NULL,
	[insertedDate] [date] NULL,
	[Match_NoMatch] [varchar](10) NULL,
	[Completed_Flag] [varchar](20) NULL,
	[EnrichedProfileID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [InboundCRM].[InboundLinkedinAPI]  WITH CHECK ADD FOREIGN KEY([EnrichedProfileID])
REFERENCES [InboundCRM].[EnrichedProfile] ([id])
