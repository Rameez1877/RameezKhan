/****** Object:  Table [dbo].[PlanMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlanMaster](
	[PlanID] [int] NOT NULL,
	[PlanName] [varchar](255) NULL,
	[PRICE] [varchar](150) NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [Pk_PlanMaster] PRIMARY KEY CLUSTERED 
(
	[PlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
