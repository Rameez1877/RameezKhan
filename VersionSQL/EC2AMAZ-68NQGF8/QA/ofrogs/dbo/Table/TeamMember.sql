/****** Object:  Table [dbo].[TeamMember]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TeamMember](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[ImageUrl] [varchar](4000) NOT NULL,
	[Biography] [nvarchar](max) NOT NULL,
	[Occupation] [varchar](250) NULL,
	[FacebookUrl] [varchar](500) NULL,
	[LinkedinUrl] [varchar](500) NULL,
	[TwitterUrl] [varchar](500) NULL,
	[Email] [varchar](150) NULL,
	[BirthDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_TeamMember] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TeamMember] ADD  CONSTRAINT [DF_TeamMember_IsActive]  DEFAULT ((1)) FOR [IsActive]
