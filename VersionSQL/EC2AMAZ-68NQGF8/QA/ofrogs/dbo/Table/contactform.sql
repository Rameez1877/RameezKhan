/****** Object:  Table [dbo].[contactform]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[contactform](
	[ID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](20) NULL,
	[Industry] [varchar](50) NULL,
	[Designation] [varchar](50) NULL,
	[Msg] [varchar](500) NULL
) ON [PRIMARY]
