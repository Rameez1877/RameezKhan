/****** Object:  Procedure [dbo].[SaveDatadotcomOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveDatadotcomOrganization] 
@datadotcomid int
AS
BEGIN
declare @Id int = 0,
	@Name nvarchar(1000),
	@FullName	nvarchar(1000),
	@Name2	nvarchar(1000) ,
	@WebsiteUrl	varchar(500) = null,
	@Description nvarchar(4000) = null,
	@Category	nvarchar(2000) = null,
	@IndustryId	int,
	@RegionId	int ,
	@UpdatedById int = 2,
	@Countryid	int ,
	@WikiName nvarchar(1000) = null,
	@SubIndustryid int,	
	@TagId int = null,
	@Revenue Varchar(50),
	@Empcount varchar(50),	
	@DataSource varchar(250) = 'Datadotcom', 
	@Phone nvarchar(250) , 
	@Org_Ownership varchar(25),
	@Ddc_UpdatedDate Datetime = getdate(),
	@NoOfContacts int
	
	select 
	@Revenue=Rev, 
	@Empcount=Emp,
	@Name = Company,
	@FullName = Company,
	@Name2 = Company,
	@WebsiteUrl	 = Website,	
	@Category = 'Major',
	@IndustryId	= IndustryId,
	@RegionId	= RegionId,
	@UpdatedById = 2,
	@Countryid = Countryid ,	
	@SubIndustryid = SubIndustryid,
	@Phone = Phone,
	@Org_Ownership = ownership,
	@NoOfContacts = null 
	from DataDotcom_Ofrogs_Orgs_Combined where id=@datadotcomid
	and IsProcessed ='N'
	
----
	SET NOCOUNT ON;
	
	IF @Name is not null and NOT EXISTS (SELECT name FROM Organization where name=@Name)
	
	BEGIN
	-- Make Sure we do not have an entry in Tag and proceed
	IF @Name is not null and NOT EXISTS (SELECT name FROM Tag where name=@Name and tagtypeid = 1)
	
	BEGIN
	  if @IndustryId is not null and @RegionId is not null
	  Begin
	 
		if @Id = 0 or @Id is null
		Begin

			insert into Organization(Name, FullName, Name2, WebsiteUrl, Description, 
				CreatedById, CreatedDate, UpdatedById, UpdatedDate, IsActive, 
				Category, IndustryId, RegionId,WikiName,Countryid,SubIndustryid,
				DataSource,Phone, Org_Ownership,NoOfContacts)
			values(@Name, @FullName, @Name2, @WebsiteUrl, @Description, 
				1, @Ddc_UpdatedDate, null, null, 1,
				@Category, @IndustryId, @RegionId,@WikiName,@Countryid,@SubIndustryid,
				@DataSource,@Phone, @Org_Ownership,@NoOfContacts)

			set @Id = @@Identity
			If @Revenue is not null
			insert into organizationattribute(organizationid,attributeid,attributevalue)
			values(@Id,17,@Revenue)
			If @Empcount is not null
			insert into organizationattribute(organizationid,attributeid,attributevalue)
			values(@Id,18,@Empcount)
			
	
			select @TagId = Id from Tag where Name = @Name and tagtypeid = 1
			
			If @TagId is null
			Begin
				insert Tag(Name, TagTypeID,OrganizationId) values(@Name, 1,@Id)
				select @TagId = Id from Tag where Name = @Name and tagtypeid = 1 and OrganizationId = @Id				
			    IF @TagId is not null and NOT EXISTS (SELECT * FROM IndustryTag WHERE  TagId = @TagId  )
			BEGIN
				INSERT IndustryTag (IndustryId, TagId)
				VALUES (@IndustryId, @TagId)
				update DataDotcom_Ofrogs_Orgs_Combined 
					set
					IsProcessed = 'Y'
				WHERE Id = @datadotcomid
							
				print('Success.')
			END
			ELSE 
			-- Save Error Flag 'E' on Datadotcom IsProcessed , needs approval to decide, which Industry the Organization belongs to
			BEGIN
			update DataDotcom_Ofrogs_Orgs_Combined 
			set
			IsProcessed = 'E'
			WHERE Id = @datadotcomid
			print('we already have a Tag and Industry association.')
			END	
			End
		End
		
	END
	END
	END	
	Else IF ((SELECT IsActive FROM Organization where name=@Name) =0)
	Begin
	
			print('Organization Skipped due to In-Active Status. Name: ' +@Name)
	End
	ELSE
	BEGIN
		print('Already exists.')
	END
--	-
--	2)  get organizationid

END
