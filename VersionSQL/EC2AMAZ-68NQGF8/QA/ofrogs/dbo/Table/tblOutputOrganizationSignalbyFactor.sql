/****** Object:  Table [dbo].[tblOutputOrganizationSignalbyFactor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblOutputOrganizationSignalbyFactor](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppUserId] [int] NULL,
	[OrganizationName] [varchar](100) NULL,
	[MagazineId] [int] NULL,
	[Score] [int] NULL,
	[Recommendation_Flag] [varchar](100) NULL,
	[BusinessChallenge_Flag] [varchar](100) NULL,
	[Initiative_Flag] [varchar](100) NULL,
	[ITSpend_Flag] [varchar](100) NULL,
	[TopicNames] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
