/****** Object:  Table [dbo].[IndustrySignal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndustrySignal](
	[IndustryId] [int] NOT NULL,
	[SignalId] [int] NOT NULL,
 CONSTRAINT [PK_IndustrySignal] PRIMARY KEY CLUSTERED 
(
	[IndustryId] ASC,
	[SignalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[IndustrySignal]  WITH NOCHECK ADD  CONSTRAINT [FK_IndustrySignal_Signal] FOREIGN KEY([SignalId])
REFERENCES [dbo].[Signal] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[IndustrySignal] CHECK CONSTRAINT [FK_IndustrySignal_Signal]
