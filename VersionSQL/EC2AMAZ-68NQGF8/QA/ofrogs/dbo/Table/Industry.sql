/****** Object:  Table [dbo].[Industry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Industry](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[SectorId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[IsOfList] [varchar](1) NOT NULL,
	[ForLeadScore] [bit] NOT NULL,
	[IsServedIndustry] [bit] NULL,
	[SequencingWeight] [int] NULL,
	[IndustryGroup] [varchar](200) NULL,
	[IndustryGroupId] [int] NULL,
 CONSTRAINT [PK_Industry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
