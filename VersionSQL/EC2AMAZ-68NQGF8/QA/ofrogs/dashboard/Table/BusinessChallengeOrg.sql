/****** Object:  Table [dashboard].[BusinessChallengeOrg]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dashboard].[BusinessChallengeOrg](
	[BusinessChallengeId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[Value] [bit] NULL,
	[UpdatedDate] [date] NULL,
 CONSTRAINT [Pk_BusinessChallengeOrganization] PRIMARY KEY CLUSTERED 
(
	[BusinessChallengeId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_BusinessChallenge] UNIQUE NONCLUSTERED 
(
	[BusinessChallengeId] ASC,
	[OrganizationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dashboard].[BusinessChallengeOrg]  WITH CHECK ADD  CONSTRAINT [Fk_BusinessChallengeOrganization_BusinessChallenge] FOREIGN KEY([BusinessChallengeId])
REFERENCES [dashboard].[BusinessChallenge] ([Id])
ALTER TABLE [dashboard].[BusinessChallengeOrg] CHECK CONSTRAINT [Fk_BusinessChallengeOrganization_BusinessChallenge]
ALTER TABLE [dashboard].[BusinessChallengeOrg]  WITH NOCHECK ADD  CONSTRAINT [Fk_BusinessChallengeOrganization_Organization] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dashboard].[BusinessChallengeOrg] CHECK CONSTRAINT [Fk_BusinessChallengeOrganization_Organization]
