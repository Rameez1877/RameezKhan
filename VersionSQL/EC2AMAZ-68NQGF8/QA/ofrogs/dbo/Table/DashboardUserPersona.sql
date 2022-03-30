/****** Object:  Table [dbo].[DashboardUserPersona]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DashboardUserPersona](
	[Id] [int] NOT NULL,
	[Persona] [nvarchar](150) NOT NULL,
	[Functionality] [varchar](100) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
