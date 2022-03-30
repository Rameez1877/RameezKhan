/****** Object:  Table [dbo].[Awards]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Awards](
	[Title] [varchar](500) NULL,
	[Year] [float] NULL,
	[Person] [nvarchar](255) NULL,
	[Organization] [nvarchar](255) NULL,
	[Designation] [nvarchar](255) NULL,
	[LinkedIn_Url] [nvarchar](255) NULL,
	[Email_Address] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[Rank] [float] NULL,
	[Type] [nvarchar](255) NULL,
	[Source_Website_Url] [varchar](340) NULL,
	[Medal] [varchar](12) NULL,
	[Entry_Title] [varchar](504) NULL,
	[Excellence_in_Program_Area] [varchar](92) NULL,
	[Tagid] [int] NULL,
	[OF_OrganizationID] [int] NULL,
	[UpdateType] [varchar](30) NULL,
	[Category] [varchar](100) NULL,
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AwardSource] [varchar](500) NULL,
	[Source] [varchar](100) NULL,
	[IsLabelled] [bit] NULL,
 CONSTRAINT [pk_awards] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
