/****** Object:  Table [dbo].[AppRoleMenus]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppRoleMenus](
	[AppRoleId] [int] NOT NULL,
	[MenuId] [int] NOT NULL,
	[CustomerType] [varchar](20) NULL
) ON [PRIMARY]
