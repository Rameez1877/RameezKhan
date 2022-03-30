/****** Object:  Table [dbo].[IndustryTag]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustryTag](
	[IndustryId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
 CONSTRAINT [PK_IndustryTag] PRIMARY KEY CLUSTERED 
(
	[IndustryId] ASC,
	[TagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_IndustryTag_5_1541580530__K2_K1_2166] ON [dbo].[IndustryTag]
(
	[TagId] ASC,
	[IndustryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TRIGGER [dbo].[IndustryTag_Prevent_delete]
ON [dbo].[IndustryTag]
INSTEAD OF DELETE AS
       BEGIN
          RAISERROR ('Removing IndustryTag entries prevented by trigger.  Contact your administrator', 16, 1)
       END
       RETURN

ALTER TABLE [dbo].[IndustryTag] DISABLE TRIGGER [IndustryTag_Prevent_delete]
