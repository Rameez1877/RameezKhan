/****** Object:  Table [dbo].[tempTopic2Term]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tempTopic2Term](
	[TPrunID] [int] NOT NULL,
	[topic1] [varchar](100) NOT NULL,
	[topic2] [varchar](100) NULL,
	[topic3] [varchar](100) NULL,
	[topic4] [varchar](100) NULL,
	[topic5] [varchar](100) NULL,
	[topic6] [varchar](100) NULL,
	[topic7] [varchar](100) NULL,
	[topic8] [varchar](100) NULL,
	[topic9] [varchar](100) NULL,
	[topic10] [varchar](100) NULL,
 CONSTRAINT [tempTopic2Term_PK] PRIMARY KEY CLUSTERED 
(
	[TPrunID] ASC,
	[topic1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tempTopic2Term]  WITH CHECK ADD  CONSTRAINT [tempTopic2Term_tempParamTmodel_FK] FOREIGN KEY([TPrunID])
REFERENCES [dbo].[tempParamTmodel] ([TPrunID])
ALTER TABLE [dbo].[tempTopic2Term] CHECK CONSTRAINT [tempTopic2Term_tempParamTmodel_FK]
