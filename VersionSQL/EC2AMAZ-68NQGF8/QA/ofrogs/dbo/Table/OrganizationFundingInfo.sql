/****** Object:  Table [dbo].[OrganizationFundingInfo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationFundingInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrganizationId] [int] NULL,
	[TotalFunding] [int] NULL,
	[FoundingYear] [int] NULL,
	[LastFundingRoundType] [varchar](200) NULL,
	[FundingStatus] [varchar](200) NULL,
	[LastFundingDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationFundingInfo]  WITH CHECK ADD  CONSTRAINT [FK_OrganizationId2] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
ALTER TABLE [dbo].[OrganizationFundingInfo] CHECK CONSTRAINT [FK_OrganizationId2]
