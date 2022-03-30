/****** Object:  Table [dbo].[LabelConceptWord]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LabelConceptWord](
	[LabelId] [int] NOT NULL,
	[ConceptWordId] [int] NOT NULL,
 CONSTRAINT [Pk_LabelConceptWord] PRIMARY KEY CLUSTERED 
(
	[LabelId] ASC,
	[ConceptWordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LabelConceptWord]  WITH CHECK ADD  CONSTRAINT [Fk_LabelConceptWord_ConceptWord] FOREIGN KEY([ConceptWordId])
REFERENCES [dbo].[ConceptWord] ([Id])
ALTER TABLE [dbo].[LabelConceptWord] CHECK CONSTRAINT [Fk_LabelConceptWord_ConceptWord]
ALTER TABLE [dbo].[LabelConceptWord]  WITH CHECK ADD  CONSTRAINT [Fk_LabelConceptWord_Label] FOREIGN KEY([LabelId])
REFERENCES [dbo].[Label] ([Id])
ALTER TABLE [dbo].[LabelConceptWord] CHECK CONSTRAINT [Fk_LabelConceptWord_Label]
