/****** Object:  Table [dbo].[Job_FuzzyLogic_Result]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Job_FuzzyLogic_Result](
	[Company] [nvarchar](255) NULL,
	[Org_Name] [varchar](255) NULL,
	[_Similarity] [float] NULL,
	[_Confidence] [float] NULL,
	[_Similarity_Company_New] [float] NULL,
	[Result] [nvarchar](50) NULL,
	[Company_New] [nvarchar](510) NULL,
	[BaseURL] [nvarchar](510) NULL,
	[JobURL] [nvarchar](510) NULL
) ON [PRIMARY]
