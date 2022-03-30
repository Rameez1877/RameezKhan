/****** Object:  Table [dbo].[OrganizationChampion]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrganizationChampion](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[Status] [bit] NOT NULL,
	[UserID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[InsertedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OrganizationChampion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_OrganizationChampion] UNIQUE NONCLUSTERED 
(
	[OrganizationId] ASC,
	[CountryId] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[OrganizationChampion] ADD  DEFAULT ((1)) FOR [IsActive]
ALTER TABLE [dbo].[OrganizationChampion]  WITH NOCHECK ADD  CONSTRAINT [FK_OrganizationChampionOrganizationId] FOREIGN KEY([OrganizationId])
REFERENCES [dbo].[Organization] ([Id])
NOT FOR REPLICATION 
ALTER TABLE [dbo].[OrganizationChampion] CHECK CONSTRAINT [FK_OrganizationChampionOrganizationId]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
-- =============================================
-- Author:    	<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[TR_OrganizatinChampionDetail]
ON [dbo].[OrganizationChampion]
AFTER INSERT
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  DECLARE @OrganizationId int,
          @userId int,
		  @OrganizationChampionID INT,
		  @CountryId int
  SELECT
    @OrganizationId = OrganizationId,
    @userId = UserID,
	@OrganizationChampionID = ID,
	@CountryId = CountryId
  FROM inserted;

  EXEC PopulateOrganizationChampionDetail @userId,@OrganizationId, @OrganizationChampionID, @CountryId
END


ALTER TABLE [dbo].[OrganizationChampion] ENABLE TRIGGER [TR_OrganizatinChampionDetail]
