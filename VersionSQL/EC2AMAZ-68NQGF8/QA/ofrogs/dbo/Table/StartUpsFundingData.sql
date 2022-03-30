/****** Object:  Table [dbo].[StartUpsFundingData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[StartUpsFundingData](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Company] [varchar](150) NOT NULL,
	[TotalFunding] [int] NULL,
	[FoundingYear] [varchar](4) NULL,
	[LastFundingRoundType] [varchar](50) NULL,
	[LastFundingDate] [date] NULL,
	[WebsiteUrl] [varchar](250) NULL,
	[OrganizationId] [int] NULL,
 CONSTRAINT [Pk_WiproFundingData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
