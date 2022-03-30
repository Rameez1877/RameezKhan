/****** Object:  Table [InboundCRM].[InboundInput]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [InboundCRM].[InboundInput](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[FirstName] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[PhoneNumber] [varchar](max) NULL,
	[Email] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Country] [varchar](max) NULL,
	[Industry] [varchar](max) NULL,
	[CompanyName] [varchar](max) NULL,
	[InsertedDate] [datetime] NOT NULL,
	[ClientName] [varchar](max) NULL,
	[EmailVerificationStatus] [varchar](max) NULL,
	[EmailRunDate] [datetime] NULL,
	[EnrichedFirstName] [varchar](255) NULL,
	[EnrichedLastName] [varchar](255) NULL,
	[ExtractedCompanyName] [varchar](255) NULL,
	[IsPersonalEmail] [int] NULL,
	[Gender] [varchar](5) NULL,
	[RunDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TRIGGER [InboundCRM].[TRG_InboundCRM_Enrich]
ON [InboundCRM].[InboundInput]

FOR INSERT

AS
BEGIN
  DECLARE
    @IsPersonalEmail varchar(30),
    @Email varchar(200),
    @EmailVerificationStatus varchar(30),
    @ExtractedCompanyName varchar(200),
	@NameFromEmail  varchar(200),
	@FirstName varchar(200),
	@LastName varchar(200),
    @FirstName1 varchar(200),
	@LastName1 varchar(200)
	
  SELECT
    @Email = Email,@EmailVerificationStatus = EmailVerificationStatus, @FirstName = FirstName, @LastName = LastName,
	@FirstName1 = CASE
    WHEN
      CHARINDEX('.',
      REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), '')) > 0 THEN  substring(REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), ''),1,charindex('.',REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), ''))-1)
    ELSE NULL
	end ,
	@LastName1 = CASE
    WHEN
      CHARINDEX('.',
      REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), '')) > 0 THEN substring(REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), ''),charindex('.',REPLACE(email,
      REVERSE(LEFT(REVERSE(email), CHARINDEX('@', REVERSE(email)))), '')) + 1,100)
    ELSE NULL
end 
FROM inserted i
   SET @IsPersonalEmail = 0 -- Initialized as personal email
 
  IF CHARINDEX('gmail.com', @Email) = 0
    AND CHARINDEX('hotmail.com', @Email) = 0
    AND CHARINDEX('yahoo.com', @Email) = 0
   
   SET @IsPersonalEmail = 1--It is corporate enail
   
   -- Below code for all records

   SET @ExtractedCompanyName = SUBSTRING(REPLACE(@Email, LEFT(@Email, LEN(@Email) - CHARINDEX('@', REVERSE(@Email))), ''), 2, CHARINDEX('.',
    REPLACE(@Email, LEFT(@Email, LEN(@Email) - CHARINDEX('@', REVERSE(@Email))), '')) - 2)
	
	begin
	
  If @FirstName IS NULL Or len(@FirstName) = 0
  begin
  SET @FirstName = @FirstName1 -- First Name from EMail
 
  If @LastName IS NULL or len(@LastName) = 0
   
  SET @LastName = @LastName1 -- Last Name from EMail
   end 
  
end 

-- First name

If (@FirstName IS NULL Or len(@FirstName) = 0) and charindex (' ',@LastName) > 0
begin
SET @FirstName = reverse(SUBSTRING(reverse(@LastName),1, charindex(' ',reverse(@LastName))-1))
SET @LastName = REPLACE(@LastName,@FirstName,'')
end 
--
------- last name 
--
  If (@LastName IS NULL or len(@LastName) = 0 )and charindex (' ',@FirstName) > 0
  begin
  SET @LastName = reverse(SUBSTRING(reverse(@FirstName),1, charindex(' ',reverse(@FirstName))-1))
  print @LastName
  SET @FirstName = REPLACE(@FirstName,@LastName,'')
  print @FirstName
  end 
  UPDATE InboundCRM.InboundInput
  SET IsPersonalEmail = @IsPersonalEmail,
	 ExtractedCompanyName = @ExtractedCompanyName,
	  EnrichedFirstName = @FirstName,
	  EnrichedLastName = @LastName
  FROM InboundCRM.InboundInput
  INNER JOIN Inserted i
    ON i.id = InboundCRM.InboundInput.id
END

ALTER TABLE [InboundCRM].[InboundInput] ENABLE TRIGGER [TRG_InboundCRM_Enrich]
