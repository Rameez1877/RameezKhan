/****** Object:  Table [dbo].[OrganizationProduct]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationProduct](
	[organizationID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
 CONSTRAINT [PK_OrganziationProduct] PRIMARY KEY CLUSTERED 
(
	[organizationID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationProduct]  WITH NOCHECK ADD  CONSTRAINT [FK_OP_OrganziationID] FOREIGN KEY([organizationID])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationProduct] CHECK CONSTRAINT [FK_OP_OrganziationID]
