/****** Object:  Table [dbo].[ProductPlanMaster]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProductPlanMaster](
	[ProductPlanID] [int] NOT NULL,
	[ProductID] [int] NULL,
	[PlanID] [int] NULL,
 CONSTRAINT [Pk_ProductPlanMaster] PRIMARY KEY CLUSTERED 
(
	[ProductPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProductPlanMaster]  WITH CHECK ADD  CONSTRAINT [FK_ProductPlanMaster_ProductID] FOREIGN KEY([ProductID])
REFERENCES [dbo].[OFProductMaster] ([ProductID])
ALTER TABLE [dbo].[ProductPlanMaster] CHECK CONSTRAINT [FK_ProductPlanMaster_ProductID]
