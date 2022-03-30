/****** Object:  Table [dbo].[UserFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UserFunctionality](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserId] [int] NOT NULL,
	[FunctionalityId] [int] NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_UserFunctionality] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
