/****** Object:  Table [dbo].[temp_Iprofbis_SoundEx]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[temp_Iprofbis_SoundEx](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MATERIAL_NAME] [nvarchar](4000) NULL,
	[NO_OF_WORDS] [int] NULL,
	[Model_MATERIAL_NAME_1] [nvarchar](255) NULL,
	[SoundEx_Model_MATERIAL_NAME_1] [varchar](5) NULL,
	[Model_MATERIAL_NAME_2] [nvarchar](255) NULL,
	[SoundEx_Model_MATERIAL_NAME_2] [varchar](5) NULL,
	[Model_MATERIAL_NAME_3] [nvarchar](255) NULL,
	[SoundEx_Model_MATERIAL_NAME_3] [varchar](5) NULL
) ON [PRIMARY]
