/****** Object:  Procedure [dbo].[SaveSurgeContactDetail]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[SaveSurgeContactDetail] 
	@UserId int,
	@Name nvarchar(1000),
	@Organization	nvarchar(1000),
	@Designation	nvarchar(1000) ,
	@SeniorityLevel	varchar(100) = null,
	@Location nvarchar(500) = null,
	@EmailId	nvarchar(500) = null,
	@Phone nvarchar(1000) = null,
	@Url nvarchar(500) = null,
	@Gender nvarchar(5) = null
		
AS
BEGIN
	SET NOCOUNT ON;
	declare @TagId int = null
	
	IF NOT EXISTS (SELECT Url FROM SurgeContactDetail where UserId = @UserId and Url = @Url)
	BEGIN
			insert into SurgeContactDetail(UserId,Name, Designation,Organization, EmailId, Phone, Url,
				GeneratedBy, EmailGeneratedDate, Location, Gender, Source,SeniorityLevel,isNew)
			values(@UserId, @Name, @Designation, @Organization, @EmailId, @Phone, 
				@Url,'Manual',getdate(),@Location, @Gender, 'Target Accounts',
				@SeniorityLevel,1)

		print('Success.')
	End
	
	ELSE
	BEGIN
		print('Already exists.')
	END
END
