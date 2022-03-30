/****** Object:  Table [dbo].[AppUserIndustry]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AppUserIndustry](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[UserId] [int] NOT NULL,
	[IndustryId] [varchar](1000) NOT NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_AppUserIndustry] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TRIGGER [dbo].[AppUserIndustry_Prevent_delete]
ON [dbo].[AppUserIndustry]
INSTEAD OF DELETE AS
       BEGIN
          RAISERROR ('Removing AppUserIndustry entries prevented by trigger.  Contact your administrator', 16, 1)
       END
       RETURN

ALTER TABLE [dbo].[AppUserIndustry] DISABLE TRIGGER [AppUserIndustry_Prevent_delete]
