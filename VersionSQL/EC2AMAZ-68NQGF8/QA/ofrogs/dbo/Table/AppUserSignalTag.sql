/****** Object:  Table [dbo].[AppUserSignalTag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppUserSignalTag](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppUserId] [int] NOT NULL,
	[TagId] [int] NULL,
	[tagtypeid] [int] NULL,
 CONSTRAINT [PK_AppUserSignalTag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
