/****** Object:  Table [dbo].[CustomersUploadedData]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CustomersUploadedData](
	[CustomersAccountListId] [int] NULL,
	[Organization] [varchar](100) NULL,
	[WebsiteUrl] [varchar](500) NULL,
	[IsExist] [bit] NULL,
	[OfOrganizationId] [int] NULL,
	[IsProcessed] [bit] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[CustomersUploadedData] ADD  DEFAULT ((0)) FOR [IsExist]
ALTER TABLE [dbo].[CustomersUploadedData] ADD  DEFAULT ((0)) FOR [IsProcessed]
