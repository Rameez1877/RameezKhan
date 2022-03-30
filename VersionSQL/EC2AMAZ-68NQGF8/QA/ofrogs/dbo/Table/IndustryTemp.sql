/****** Object:  Table [dbo].[IndustryTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustryTemp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[SectorId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[IsOfList] [varchar](1) NOT NULL,
	[ForLeadScore] [bit] NOT NULL,
	[IsServedIndustry] [bit] NULL,
	[SequencingWeight] [int] NULL,
	[IndustryGroup] [varchar](200) NULL
) ON [PRIMARY]
