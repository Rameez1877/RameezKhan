/****** Object:  Table [dbo].[LeadScoreUserEmpCountIndustryScore]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LeadScoreUserEmpCountIndustryScore](
	[UserID] [int] NOT NULL,
	[EmpCount] [varchar](25) NOT NULL,
	[IndustryID] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[TYPE] [varchar](10) NOT NULL,
 CONSTRAINT [PK_LeadScoreUserEmpCountIndustryScore] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC,
	[EmpCount] ASC,
	[IndustryID] ASC,
	[TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LeadScoreUserEmpCountIndustryScore]  WITH CHECK ADD  CONSTRAINT [CHK_TYPE_LeadScoreUserEmpCountIndustryScore] CHECK  (([type]='Non App' OR [type]='App'))
ALTER TABLE [dbo].[LeadScoreUserEmpCountIndustryScore] CHECK CONSTRAINT [CHK_TYPE_LeadScoreUserEmpCountIndustryScore]
