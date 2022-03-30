/****** Object:  Table [dbo].[TargetPersonaOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersonaOrganization](
	[TargetPersonaId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[SortOrder] [int] NULL,
	[AccountStatus] [int] NOT NULL,
	[Comment] [varchar](max) NULL,
	[LeadScore] [int] NULL,
 CONSTRAINT [PK_TargetPersonaOrganization] PRIMARY KEY CLUSTERED 
(
	[TargetPersonaId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TargetPersonaOrganization] ADD  DEFAULT ((0)) FOR [SortOrder]
ALTER TABLE [dbo].[TargetPersonaOrganization] ADD  DEFAULT ((1)) FOR [AccountStatus]
ALTER TABLE [dbo].[TargetPersonaOrganization] ADD  DEFAULT ((0)) FOR [LeadScore]
