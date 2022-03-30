/****** Object:  Procedure [dbo].[SaveOrganization]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SaveOrganization] 
	@Id int = 0,
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
	@Datasource varchar(100) = null,
	@GlassDoorIndustry varchar(100) = null,
	@WebsiteTitle varchar(250) = null,
	@WebsiteDescription varchar(4000) = null,
	@WebsiteKeywords varchar(4000) = null,
	@Revenue varchar(100) = NULL,
	@EmployeeCount varchar(100) = NULL,
	@GlassdoorDescription varchar(7000) = NULL
		
AS
BEGIN
	SET NOCOUNT ON;
	declare @TagId int = null
	
	IF @Name is not null and NOT EXISTS (SELECT name FROM Organization where name=@Name)
	BEGIN

	  if @IndustryId is not null and @RegionId is not null
	  Begin
		if @Id = 0 or @Id is null
		Begin
			insert into Organization(Name, FullName, Name2, WebsiteUrl, [Description], 
				CreatedById, CreatedDate, UpdatedById, UpdatedDate, IsActive, 
				Category, IndustryId, RegionId,WikiName,Countryid,SubIndustryid,DataSource,GlassDoorIndustry,WebsiteTitle,WebsiteDescription,WebsiteKeywords, Revenue, EmployeeCount,GlassdoorDescription)
			values(@Name, @FullName, @Name2, @WebsiteUrl, @Description, 
				1, getdate(), null, null, 1,
				@Category, @IndustryId, @RegionId,@WikiName,@Countryid,@SubIndustryid,
				@DataSource,@GlassDoorIndustry,@WebsiteTitle,@WebsiteDescription,@WebsiteKeywords,@Revenue,@EmployeeCount,@GlassdoorDescription)

			set @Id = @@Identity
			insert RssSource(Name, [Url], IndustryId, [Description], Tags, CreatedById, CreatedDate, UpdatedById, UpdatedDate, IsActive, SourceTypeId, 
				rssTypeId, IsValid, ValidateDate)
			select Name, 'https://news.google.com/news/feeds?pz=1&cf=all&ned=en&hl=COUNTRY&q=' + replace(Name, ' ', '+') + '&output=rss' as [Url], 
				IndustryId, [Description], null, 1, getdate(), null, null, 1, 1, null, null, null
			from Organization
			where
				Id = @Id

			select @TagId = Id from Tag where Name = @Name and tagtypeid = 1
			
			If @TagId is null
			Begin
				insert Tag(Name, TagTypeID,OrganizationId) values(@Name, 1,@Id)
				set @TagId = @@Identity
			End
			Else
			Begin
				update Tag
				set
					Name = @Name,
					TagTypeId=1,
					OrganizationId=@Id

				where
					Id = @TagId
			END
			--print @TagId
			IF @TagId is not null and NOT EXISTS (SELECT * FROM IndustryTag WHERE IndustryId = @IndustryId and TagId = @TagId )
			BEGIN
				INSERT IndustryTag (IndustryId, TagId)
				VALUES (@IndustryId, @TagId)
				
				--exec Usp_SignalJob_Count_Signal_Words @TagId, 0 , 0
			END
			--exec ProcessRssFeedItem2 @Name, 2017 commented on 15th Aug 2018 By Janna + Vinay Input as this feature is not used

			print('Success.')
		End
		Else
		Begin
			declare @TagName nvarchar(1000) = null
			
			select @TagName = Name from Organization where Id = @Id
			
			update Organization
			set
				Name = @Name, 
				FullName = @FullName, 
				Name2 = @Name2,
				WebsiteUrl = @WebsiteUrl, 
				[Description] = @Description, 
				UpdatedById = @UpdatedById, 
				UpdatedDate = getUtcDate(), 
				IsActive = 1, 
				Category = @Category, 
				IndustryId = @IndustryId, 
				RegionId = @RegionId,
				Countryid=@Countryid,
				SubIndustryid = @SubIndustryid,
				GlassDoorIndustry = @GlassDoorIndustry,
				WebsiteTitle = @WebsiteTitle,
				WebsiteDescription = @WebsiteDescription,
				WebsiteKeywords = @WebsiteKeywords
			where
				Id = @Id

			select @TagId = Id from Tag where Name = @TagName
			
			If @TagId is null
			Begin
				--insert Tag(Name) values(@Name)
				insert Tag(Name, TagTypeID,OrganizationId) values(@Name, 1,@Id)
				set @TagId = @@Identity
			End
			Else
			Begin
				update Tag
				set
					Name = @Name,
					TagTypeId=1,
					OrganizationId=@Id

				where
					Id = @TagId
			END

			IF @TagId is not null and NOT EXISTS (SELECT * FROM IndustryTag WHERE IndustryId = @IndustryId and TagId = @TagId)
			BEGIN
				INSERT IndustryTag (IndustryId, TagId)
				VALUES (@IndustryId, @TagId)

			END

			--exec ProcessRssFeedItem2 @Name, 2017; commented on 15th Aug 2018 By Janna + Vinay Input as this feature is not used
			

			print('Success.')
		

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
END
