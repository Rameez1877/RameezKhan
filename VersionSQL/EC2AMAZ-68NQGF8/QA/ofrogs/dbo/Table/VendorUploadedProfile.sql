/****** Object:  Table [dbo].[VendorUploadedProfile]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VendorUploadedProfile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[OrganizationId] [int] NOT NULL,
	[OrganizationName] [varchar](500) NOT NULL,
	[WebsiteUrl] [varchar](500) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Designation] [varchar](500) NULL,
	[LinkedInUrl] [varchar](500) NULL,
	[Country] [varchar](500) NULL,
	[Email] [varchar](200) NULL,
	[Phone] [varchar](50) NULL,
	[VerificationStatus] [varchar](50) NULL,
	[ConfidenceScore] [int] NULL,
	[EmailVerificationStatus] [varchar](1000) NULL,
	[IsVerified] [bit] NULL,
	[SnapshotId] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[IsProcessed] [bit] NULL,
	[Revenue] [varchar](50) NULL,
	[City] [varchar](100) NULL,
	[Remarks] [nvarchar](500) NULL,
	[EmployeeCount] [varchar](50) NULL,
 CONSTRAINT [PK_VendorUploadedProfile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[VendorUploadedProfile] ADD  CONSTRAINT [DF_VendorUploadedProfile_IsVerified]  DEFAULT ((0)) FOR [IsVerified]
ALTER TABLE [dbo].[VendorUploadedProfile] ADD  CONSTRAINT [DF_VendorUploadedProfile_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
ALTER TABLE [dbo].[VendorUploadedProfile] ADD  CONSTRAINT [DF__VendorUpl__IsPro__1A095D10]  DEFAULT ((0)) FOR [IsProcessed]
