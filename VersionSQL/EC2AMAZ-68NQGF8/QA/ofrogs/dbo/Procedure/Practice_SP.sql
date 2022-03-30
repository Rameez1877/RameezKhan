/****** Object:  Procedure [dbo].[Practice_SP]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure Practice_SP @tagtypeID nvarchar(max) 
as
Select tag.*,industrytag.IndustryId from tag
inner join industrytag on tag.id=industrytag.tagid
where tagtypeid = @tagtypeID
