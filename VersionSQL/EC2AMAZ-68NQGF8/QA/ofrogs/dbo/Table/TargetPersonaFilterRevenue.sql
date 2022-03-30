/****** Object:  Table [dbo].[TargetPersonaFilterRevenue]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaFilterRevenue](
	[Revenue] [varchar](100) NOT NULL,
	[OrderNo] [int] NOT NULL,
	[NoOfOrganizations] [int] NOT NULL,
 CONSTRAINT [PK_TargetPersonaFilterRevenue] PRIMARY KEY CLUSTERED 
(
	[Revenue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
