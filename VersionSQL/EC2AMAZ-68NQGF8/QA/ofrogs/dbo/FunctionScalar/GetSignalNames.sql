/****** Object:  Function [dbo].[GetSignalNames]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[GetSignalNames] (@RssFeedItemId int)
RETURNS NVARCHAR(MAX) AS
BEGIN
	declare @Names nvarchar(max),
	 @AppUserId int = 1
	

	declare @temp_table TABLE([Name] nvarchar(max))

	insert into @temp_table select distinct T.[Name] from
	(   select distinct Signal.DisplayName COLLATE database_default as [Name]
		from RssFeedItem I 
		INNER JOIN RssFeedItemSignal ON RssFeedItemSignal.RssFeedItemId = I.Id
		INNER JOIN Signal ON Signal.id = RssFeedItemSignal.SignalId
		where 
			I.Id = @RssFeedItemId 

		UNION 

		select distinct T.label COLLATE database_default as [Name]
		from RssFeedItem RFI ,Topic T 
		where 
			RFI.Id = @RssFeedItemId 
			and RFI.Id = T.RssFeedItemId 
			and T.score >= 0.45
	) T

	select @Names = COALESCE(@Names + ',','') +  T.[Name] from (select * from @temp_table) T
	return @Names
END
