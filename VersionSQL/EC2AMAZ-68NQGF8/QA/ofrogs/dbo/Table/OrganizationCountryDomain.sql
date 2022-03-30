/****** Object:  Table [dbo].[OrganizationCountryDomain]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationCountryDomain](
	[OrganizationId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[DomainName] [varchar](40) NULL,
 CONSTRAINT [PK_OrgCountryDomain] PRIMARY KEY CLUSTERED 
(
	[OrganizationId] ASC,
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationCountryDomain]  WITH NOCHECK ADD  CONSTRAINT [FK__Organizat__Organ__59CC7A65] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationCountryDomain] CHECK CONSTRAINT [FK__Organizat__Organ__59CC7A65]
