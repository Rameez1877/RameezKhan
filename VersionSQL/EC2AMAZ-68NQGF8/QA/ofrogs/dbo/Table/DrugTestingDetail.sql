/****** Object:  Table [dbo].[DrugTestingDetail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DrugTestingDetail](
	[OrganizationID] [int] NOT NULL,
	[DrugName] [varchar](100) NOT NULL,
	[TestingPhase] [varchar](10) NOT NULL,
	[ApprovedDate] [date] NOT NULL,
 CONSTRAINT [PK_DrugTestingDetail] PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC,
	[DrugName] ASC,
	[TestingPhase] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DrugTestingDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_DTD_OrganizationID] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[DrugTestingDetail] CHECK CONSTRAINT [FK_DTD_OrganizationID]
ALTER TABLE [dbo].[DrugTestingDetail]  WITH CHECK ADD  CONSTRAINT [Chk_DTD_TestingPhase] CHECK  (([TestingPhase]='Phase 4' OR [TestingPhase]='Phase 3' OR [TestingPhase]='Phase 2' OR [TestingPhase]='Phase 1'))
ALTER TABLE [dbo].[DrugTestingDetail] CHECK CONSTRAINT [Chk_DTD_TestingPhase]
