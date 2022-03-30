/****** Object:  Table [cache].[DecisionMakerFunctionality]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [cache].[DecisionMakerFunctionality](
	[DecisionMakerId] [int] NOT NULL,
	[Functionality] [varchar](50) NOT NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DecisionMakerFunctionality] ON [cache].[DecisionMakerFunctionality]
(
	[DecisionMakerId] ASC,
	[Functionality] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
