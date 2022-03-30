/****** Object:  Table [dbo].[DecisionMakerList]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DecisionMakerList](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Keyword] [varchar](76) NULL,
	[IsActive] [bit] NULL,
	[SeniorityLevel] [varchar](50) NULL,
	[Sequence] [int] NULL,
	[Technical_Roles] [bit] NULL,
	[Sales_Roles] [bit] NULL,
	[Marketing_Roles] [bit] NULL,
	[Consultant_Roles] [bit] NULL,
	[Generic_C_level] [bit] NULL,
	[HumanResource] [bit] NULL,
	[Finance] [bit] NULL,
	[IsConcatenate] [bit] NULL,
	[NonEnglish] [bit] NULL,
 CONSTRAINT [PK_DecisionMakerList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
