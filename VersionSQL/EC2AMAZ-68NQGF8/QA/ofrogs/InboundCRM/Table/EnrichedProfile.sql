/****** Object:  Table [InboundCRM].[EnrichedProfile]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [InboundCRM].[EnrichedProfile](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InboundInputID] [int] NULL,
	[APIName] [varchar](max) NULL,
	[RunDate] [datetime] NULL,
	[Designation] [varchar](max) NULL,
	[EmployerName] [varchar](max) NULL,
	[LinkedinURL] [varchar](max) NULL,
	[Location] [varchar](max) NULL,
	[FirstName] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[APICallStatus] [varchar](max) NULL,
	[Country] [varchar](100) NULL,
	[Name] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [InboundCRM].[EnrichedProfile]  WITH CHECK ADD FOREIGN KEY([InboundInputID])
REFERENCES [InboundCRM].[InboundInput] ([id])
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TRIGGER [InboundCRM].[MarketingList_InboundAI]   
ON [InboundCRM].[EnrichedProfile]

For Insert
As
Begin
Declare
		@id int,
		@Designation varchar(100)

		select @id=id, @Designation=Designation  from Inserted
 
		INSERT INTO InboundAIMarketingList (Id,
    MarketingListName)


      SELECT @id, Name
       
      FROM McDecisionMaker  
      WHERE IsOFList = 1
	  and ISactive=1
      AND CHARINDEX(' ' + keyword + ' ', ' ' + @Designation  + ' ') > 0
      AND Name <> 'Others'

End
ALTER TABLE [InboundCRM].[EnrichedProfile] ENABLE TRIGGER [MarketingList_InboundAI]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TRIGGER [InboundCRM].[TRG_CorrectingDesignation]
ON [InboundCRM].[EnrichedProfile]
AFTER  Insert
AS
BEGIN
    SET NOCOUNT ON;
    
Declare @Designation varchar(200),
@FirstName varchar(50),
@LastName varchar(50),
@CompanyName varchar(100),
@count int,
@country varchar(100),
@countryID int


select @Designation = Designation, @FirstName = FirstName, @LastName = LastName, @CompanyName = EmployerName, @country = country from inserted i
Print @country

select @count = count(*) from Decisionmakerlist where charindex(keyword, @Designation) > 0

if @count = 0
Begin
 Select @countryID = ID from Country where name = @country
 insert into LinkedinApi (SearchKeyword, countryID, isactive, inserteddate, marketinglist,appuserid, kywdtype, appPriority, appbatch)
  values (@FirstName+' '+ @LastName+ ', '+@CompanyName, @countryID, 1, getdate(), 910, 1, 'keyword', 1, 1)
 insert into ofrogs.InboundCRM.InboundLinkedinAPI (searchKeyword, insertedDate) values (@FirstName+' '+ @LastName+ ', '+@CompanyName, getdate())
End
End


--select * from ofrogs.InboundCRM.InboundLinkedinAPI
--select * from ofrogs.InboundCRM.EnrichedProfile
ALTER TABLE [InboundCRM].[EnrichedProfile] DISABLE TRIGGER [TRG_CorrectingDesignation]
EXEC sp_settriggerorder @triggername=N'[InboundCRM].[TRG_CorrectingDesignation]', @order=N'Last', @stmttype=N'INSERT'
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



CREATE TRIGGER [InboundCRM].[TRG_InboundCRM_Extract]
ON [InboundCRM].[EnrichedProfile]

FOR INSERT

AS
BEGIN

  DECLARE @country varchar(100),
          @position varchar(100),
          @Location varchar(100),
		  @id int,
          @Designation varchar(200),
          @FirstName varchar(50),
          @LastName varchar(50),
          @CompanyName varchar(100),
          @count int,
          @countryID int,
		  @FN varchar(50),
		  @LN varchar(50),
		  @EnrichedProfileID int



  SELECT
    @position =
    CHARINDEX(',', Location),
    @Location = Location,
    @Designation = Designation,
    @FirstName = FirstName,
    @LastName = LastName,
    @CompanyName = EmployerName,
	@EnrichedProfileID = id
  FROM inserted i

	
	

    
	SELECT
	@country = case when charindex(',',@Location) > 0 then
       LTRIM(REVERSE(LEFT(REVERSE([I].Location), CHARINDEX(',', REVERSE([I].Location)) - 1))) 
	  else @Location end,
	  @FN = LEFT(Name,CHARINDEX(' ',Name + ' ')-1),
	  @LN = ltrim(reverse(substring(reverse(Name),1,charindex(' ',reverse(Name)))))
    FROM inserted i

	

  UPDATE [InboundCRM].[EnrichedProfile]
  SET Country = @country, EmployerName =
  case 
  when CHARINDEX(' at ', @CompanyName)>0 then 
  SUBSTRING(@CompanyName,CHARINDEX(' at ', @CompanyName)+4,len(@CompanyName)-CHARINDEX(' at ', @CompanyName))

  when CHARINDEX(' bei ', @CompanyName)>0  then 
  SUBSTRING(@CompanyName,CHARINDEX(' bei ', @CompanyName)+5,len(@CompanyName)-CHARINDEX(' bei ', @CompanyName))

  when CHARINDEX(' ?? ', @CompanyName)>0 then 
  SUBSTRING(@CompanyName,CHARINDEX(' ?? ', @CompanyName)+4,len(@CompanyName)-CHARINDEX(' ?? ', @CompanyName))


  else @CompanyName end

  FROM [InboundCRM].[EnrichedProfile]
  INNER JOIN Inserted i
    ON i.id = InboundCRM.EnrichedProfile.id

  SELECT
    @count = COUNT(*)
  FROM Decisionmakerlist
  WHERE CHARINDEX(keyword, @Designation) > 0 

  If @count = 0
  SELECT
    @count = COUNT(*)
  FROM InfluencerList
  WHERE CHARINDEX(keyword, @Designation) > 0


  UPDate [InboundCRM].[EnrichedProfile]
  set firstName = @FN, lastName = @LN
  where id = @EnrichedProfileID

  IF @count = 0
  BEGIN
    SELECT
      @countryID = ID
    FROM Country
    WHERE name = @country

	If @countryID is null
	begin
    select @countryID = c.id from state s, country c
	where s.countryid=c.id
	and s.name= @country
	end

	If @countryID is null
		Set @countryID = 243

	IF @LN is null
		Set @LN = ''
	
    INSERT INTO LinkedinApi (SearchKeyword, countryID, isactive, inserteddate, marketinglist, appuserid, kywdtype, appPriority, appbatch)
      VALUES (@FN + ' ' + @LN + ', ' + @CompanyName, @countryID, 1, GETDATE(), 910, 1, 'keyword', 1, 1)
    INSERT INTO ofrogs.InboundCRM.InboundLinkedinAPI (searchKeyword, insertedDate,EnrichedProfileID)
      VALUES (@FN + ' ' + @LN + ', ' + @CompanyName, GETDATE(), @EnrichedProfileID)
  END

END
ALTER TABLE [InboundCRM].[EnrichedProfile] ENABLE TRIGGER [TRG_InboundCRM_Extract]
