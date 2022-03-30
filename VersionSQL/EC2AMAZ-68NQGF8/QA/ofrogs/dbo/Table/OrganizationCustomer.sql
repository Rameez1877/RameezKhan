/****** Object:  Table [dbo].[OrganizationCustomer]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationCustomer](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationID] [int] NOT NULL,
	[CustomerOrganizationID] [int] NULL,
	[CustomerOrganizationName] [varchar](200) NOT NULL,
	[CustomerOrganizationWebsiteURL] [varchar](500) NULL,
	[CountryID] [int] NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OrganizationCustomer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationCustomer]  WITH NOCHECK ADD  CONSTRAINT [FK_OrganizationCustomerCustomerOrganizationID] FOREIGN KEY([CustomerOrganizationID])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationCustomer] CHECK CONSTRAINT [FK_OrganizationCustomerCustomerOrganizationID]
ALTER TABLE [dbo].[OrganizationCustomer]  WITH NOCHECK ADD  CONSTRAINT [FK_OrganizationCustomerOrganizationID] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationCustomer] CHECK CONSTRAINT [FK_OrganizationCustomerOrganizationID]
