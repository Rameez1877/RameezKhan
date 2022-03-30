/****** Object:  Table [dbo].[AR1AForm]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AR1AForm](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NULL,
	[LabelId] [int] NOT NULL,
	[IndustryId] [int] NULL,
	[RiskFactors] [varchar](max) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[Year] [smallint] NOT NULL,
	[OrganizationName] [varchar](max) NOT NULL,
	[IndustryName] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
