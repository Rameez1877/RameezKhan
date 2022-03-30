/****** Object:  Procedure [dbo].[UpsertTag]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpsertTag]
	@IndustryName varchar(250),
	@TagName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	declare @IndustryId int
	declare @TagId int

	select @IndustryId = Id from Industry where Name = @IndustryName

	if @IndustryId is null
	Begin
		print('Industry Domain: "' + @IndustryName + '" not found.')
    End
	else
	Begin
		select @TagId = Id from Tag where Name = @TagName

		If @TagId is null
		Begin
			insert Tag(Name) values(@TagName)
			set @TagId = @@Identity
		End

		IF @TagId is not null and NOT EXISTS (SELECT * FROM IndustryTag WHERE IndustryId = @IndustryId and TagId = @TagId)
		BEGIN
			INSERT IndustryTag (IndustryId, TagId)
			VALUES (@IndustryId, @TagId)
			print('Success.')
		END
		Else
		Begin
			print('Could not insert tag: "' + @TagName + '".')
		End
	End
END
