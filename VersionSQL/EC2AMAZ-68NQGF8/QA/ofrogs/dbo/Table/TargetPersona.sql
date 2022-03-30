/****** Object:  Table [dbo].[TargetPersona]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TargetPersona](
	[Id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Name] [varchar](250) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[EmployeeCounts] [varchar](3000) NULL,
	[Revenues] [varchar](3000) NULL,
	[HotAccounts] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[Type] [varchar](10) NOT NULL,
	[AppCategories] [varchar](3000) NULL,
	[NoOfDownloads] [varchar](3000) NULL,
	[Locations] [varchar](8000) NULL,
	[Industries] [varchar](3000) NULL,
	[Technologies] [varchar](max) NULL,
	[Gics] [varchar](3000) NULL,
	[Segment] [varchar](8000) NULL,
	[Products] [varchar](200) NULL,
	[Solutions] [varchar](200) NULL,
	[COEs] [varchar](1000) NULL,
	[SequenceNumber] [int] NULL,
	[Intent] [varchar](8000) NULL,
	[TechnologyCategory] [varchar](8000) NULL,
	[PersonaIDs] [varchar](100) NULL,
	[RegionIDs] [varchar](100) NULL,
	[IndustryGroupIDs] [varchar](100) NULL,
	[CustomerType] [varchar](100) NULL,
	[CustomTechnologyPersonaID] [varchar](200) NULL,
	[CustomIntentPersonaID] [varchar](200) NULL,
	[CustomTeamPersonaID] [varchar](200) NULL,
	[HasCustomPersona] [bit] NULL,
 CONSTRAINT [PK_TargetPersona] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[TargetPersona] ADD  CONSTRAINT [DF_TargetPersona_CreateDate]  DEFAULT (getutcdate()) FOR [CreateDate]
ALTER TABLE [dbo].[TargetPersona] ADD  DEFAULT ('Non App') FOR [Type]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER Trg_TargetPersona_Demo_Acc
   ON  TargetPersona
    AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @UserID INT, @TargetPersonaID INT, @AppRoleID INT, @Count INT

    SELECT @UserID = CreatedBy, @TargetPersonaID = ID FROM  Inserted I
	
	Select @AppRoleID = AppRoleID FROM AppUser
	WHERE ID = @userID

	SELECT @Count = count(*) from Targetpersona where createdby = @Userid

	If @Count > 5 and @AppRoleID = 3
	begin
	RAISERROR ('Maximum Number Of Personas Allowed Per Demo Account is Limited to 5' ,10,1)
	ROLLBACK TRANSACTION
	end 

END

ALTER TABLE [dbo].[TargetPersona] DISABLE TRIGGER [Trg_TargetPersona_Demo_Acc]
