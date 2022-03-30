/****** Object:  Table [dbo].[IndustryForbes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustryForbes](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[YearForbes] [int] NULL,
	[SectorForbes] [varchar](100) NOT NULL,
	[IndustryForbes] [varchar](100) NOT NULL
) ON [PRIMARY]
