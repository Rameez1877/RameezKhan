/****** Object:  Function [dbo].[GetTopicNames]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetTopicNames] (@RssFeedItemId int)
RETURNS NVARCHAR(MAX) AS
BEGIN
	declare @Names nvarchar(max),
	 @AppUserId int = 1
	
	

	declare @temp_table TABLE([Name] nvarchar(max))

	insert into @temp_table select distinct T.[Name] from
	(   select distinct [Name] COLLATE database_default as [Name]
		from RssFeedItem RFI 
			join CategoryScore CS on RFI.Id = CS.RssFeedItemId 
			join Category C on CS.CategoryId = C.Id 
			join Label L on C.LabelId = L.Id
			join ofuser.AppUserTopic AUT on L.Name Collate Latin1_General_CI_AI = AUT.LabelName
			
		where 
			RFI.Id = @RssFeedItemId and AUT.AppUserId =@AppUserId
     
		union

		select distinct T.label COLLATE database_default as [Name]
		from RssFeedItem RFI ,Topic T 
		where 
			RFI.Id = @RssFeedItemId 
			and RFI.Id = T.RssFeedItemId 
			and T.score > 0.5

		--select Label COLLATE database_default from Topic where RssFeedItemId = @RssFeedItemId and Score >= 0.9
	
	
	
	) T

	select @Names = COALESCE(@Names + ',','') +  T.[Name] from (select * from @temp_table) T

	return @Names
END
