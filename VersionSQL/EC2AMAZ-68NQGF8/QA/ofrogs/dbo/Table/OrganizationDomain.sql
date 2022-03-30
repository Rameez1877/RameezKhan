/****** Object:  Table [dbo].[OrganizationDomain]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationDomain](
	[OrganizationID] [int] NOT NULL,
	[DomainName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_OrganizationDomain] PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationDomain]  WITH NOCHECK ADD  CONSTRAINT [FK__Organizat__Organ__1451E89E] FOREIGN KEY([OrganizationID])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationDomain] CHECK CONSTRAINT [FK__Organizat__Organ__1451E89E]
