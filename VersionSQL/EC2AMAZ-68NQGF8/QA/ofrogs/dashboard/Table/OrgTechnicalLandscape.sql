/****** Object:  Table [dashboard].[OrgTechnicalLandscape]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dashboard].[OrgTechnicalLandscape](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[TechnicalLandscape] [varchar](max) NOT NULL,
	[NewsLink] [varchar](max) NULL,
	[UpdatedDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dashboard].[OrgTechnicalLandscape]  WITH NOCHECK ADD  CONSTRAINT [Fk_OrgTechnicalLandscape_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dashboard].[OrgTechnicalLandscape] CHECK CONSTRAINT [Fk_OrgTechnicalLandscape_Organization]
